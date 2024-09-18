# Cloning

## Cloning Linux

1. Change the CPU cores, memory, network device (VirtIO), and resize drive if necessary
2. Start the VM, sign in, change the hostname, and delete ```/etc/machine-id```
3. If you expanded the drive size:
    1. Run ```sudo cfdisk /dev/sda``` and expand the ext4 partition to fill the unallocated space
    2. Run ```sudo resize2fs /dev/sda2``` from ```arch-install-scripts``` to expand the ext4 filesystem to the new partition space
4. Download xrdp (install xorgxrdp-glamor or just xorgxrdp) if needed, follow the instructions on https://wiki.archlinux.org/title/Xrdp, enable the service, install and set up .xinitrc, and make sure that you launch the WM/DE by adding ```exec <WM/DE>``` to .xinitrc

## Cloning Windows

1. Change the CPU cores, memory, network device (Realtek), and resize drive if necessary
2. Start the VM, sign in, and change the hostname
3. If you expanded the drive size:
    1. Open Windows search and type ```diskman```
    2. Use the GUI to extend the C: volume to the new unallocated space

---

# Commands for System Administration

1. For shrinking a VM's disk space:
    1. Shrink the partitions in the VM such that the end of the drive is unallocated space
    2. Run ```sudo lvdisplay``` to identify which disk to shrink
    3. Run ```sudo lvresize --size -<shrinkAmount>GB <pathToDisk>``` and fill in the blanks
    4. Run ```sudo qm rescan``` to update all disk sizes

## Utilities for System Monitoring

- ```btop``` for general system monitoring

- ```iotop --only``` for disk monitoring

- ```watch -n 1 sudo arc_summary``` for zfs ARC monitoring

- ```powertop``` for power and idle monitoring

- ```watch -n 1 sensors``` for temperature monitoring

- ```sudo df -h``` to check free disk space

## Proxmox Host Migration

1. Backup /etc/pve and rename the node
    - https://pve.proxmox.com/wiki/Renaming_a_PVE_node
2. Set up PAM users: first set up the user (and their home directory) using the host shell, then
   add those users to PVE using the web GUI
3. Set up nathan-net-reconnect.sh for network reconnection in /usr/local/sbin and the service in /etc/systemd/system/.
   Make sure that the service is enabled and that you check the status to see that it runs without error.
4. Set up CPU temperature monitoring
    - https://www.reddit.com/r/homelab/comments/rhq56e/displaying_cpu_temperature_in_proxmox_summery_in/
        - ```/usr/share/pve-manager/js/pvemanagerlib.js```
        - Make sure to make a backup file with the modified UI settings so that you can restore after every update
5. Get rid of subscription notice
    - https://github.com/foundObjects/pve-nag-buster/
6. Perform system update and install standard tools for system monitoring and text editing
    - ```sudo apt update && sudo apt upgrade && sudo apt install btop iotop powertop lm-sensors vim nano git wget```
7. Change repo to non-production for updates
    - https://www.reddit.com/r/Proxmox/comments/tgojp1/removing_proxmox_subscription_notice/
8. Set zfs to low disk IO
    - https://www.reddit.com/r/Proxmox/comments/u129sw/suggestions_to_decreasing_wearout_of_ssds_in/
    - https://www.reddit.com/r/Proxmox/comments/14ka64x/how_to_reduce_memory_used_by_zfs/
9. Set CPU frequency scaling to ondemand:
    - https://www.reddit.com/r/Proxmox/comments/zt79ib/can_proxmox_reduce_the_number_of_cpu_cores_or_cpu/j1dqwu5/
    - https://forum.proxmox.com/threads/fix-always-high-cpu-frequency-in-proxmox-host.84270/
    - https://www.reddit.com/r/homelab/comments/bltm26/proxmox_power_usagemanagement_still_no_cpu_scaling/emul6ek/
10. Make sure ssh server is up
    - ```sudo systemctl enable sshd```
11. Make sure that shutdown timer is correct in /etc/system/system.conf
    - The timeout for killing/shutting a process should be ~3 seconds instead of 90 seconds
12. Make sure the correct network driver is used.
    - If you have a Realtek RTL8111, see
        - https://www.reddit.com/r/Proxmox/comments/150stgh/proxmox_8_rtl8169_nic_dell_micro_formfactors_in/
        - https://medium.com/@pattapongj/how-to-fix-network-issues-after-upgrading-proxmox-from-7-to-8-and-encountering-the-r8169-error-d2e322cc26ed
        - https://forum.proxmox.com/threads/unable-to-install-r8168-dkms-for-realtek-nic.137727/
13. Set up:
    - Templates for Linux and Windows according to the instructions below
    - DNS with Unbound, configure /etc/unbound/unbound.conf.d/main.conf, local.conf, and blacklist-*.conf. Make sure that unbound can get queries from all interfaces, you give access control to the entire local ip range, you set up the forward nameservers, you add local-data for LAN domain queries, and set up the blocklist according to Steven Black's hostfile and the hostfile->conf converter script. This should probably be done in a Docker container
    - AD, get a copy of the latest Windows Server ISO, activate it, and then set up the AD
    - NAS, use OpenMediaVault or TrueNAS Core and then set up an SMB share
    - RPX with Nginx Reverse Proxy Manager and a PKI so that you can connect to local pages and GUIs with HTTPS

## Making a New VM Template

1. Give the VM an ID that follows the convention:
    - 1xx for Windows, 2xx for Linux, 90x for templates with x being the leftmost digit of the VM ID type
2. Give the VM a name that describes what it is and can be made into a hostname
3. Load the ISO image that the VM is based on. If this is a Windows 10 or Arch Linux based VM, you should skip these steps and use a clone template instead.
4. In system, set:
    - Display: **VirtIO-GPU** (better performance?)
    - Machine: **q35** (real PCIe emulation)
    - BIOS: **OVMF (UEFI)**, set the EFI storage disk
    - If not using Windows, **Disable Pre-Enroll keys**
5. Set disk settings and set disk size to be whatever you want, I recommend the minimum to get the system running -- you can allocate more in the future
6. Set CPU type to **host**, set the cores to whatever you need for the virtual machine
7. Set the amount of memory you need and enable ballooning if you want
8. Network should be **Realtek** for Windows and misc. and **VirtIO** for everything Linux. Do not set a network rate limit because it will cause the bridge to crash
9. After setting up the VM, change the hostname
10. Install the qemu guest-agent as **VirtIO** and then enable qemu guest-agent as well as guest-trim
    - To install on Arch Linux, use pacman to install the qemu-guest-agent package
    - To install on Windows, mount the VirtIO disk in local to the Windows guest and run the .msi in the root of the mounted driver disk
11. Set the DNS server on the VM to be the DNS VM (with Unbound DNS server)
12. Install all base software that you think is necessary for all VMs
13. In the Arch template, make sure that:
    - pacman, .zsh, and paru have been configured
    - set the shutdown timeout
    - set visudo, start ssh
    - clean pacman cache using ```sudo pacman -Sccd```
    - edit pacman.conf to allow colors and 10 parallel downloads
14. In the Windows template, remember to:
    - Make a new user
    - Download chocolatey
    - Disable startup programs
    - Enable RDP, cap the pagefile
    - Edit hostfile if necessary
    - Remove bloatware
    - Adjust sleep settings
    - Disable hibernate ```powercfg -h off```
    - Enable ssh in settings and the service on boot
    - Enable pinging for VMs

---

## Packages to Install on Base Arch Template
```
arch-install-scripts
base
base-devel
btop
cronie
docker
docker-compose
efibootmgr
git
grub
iotop
linux
linux-firmware
lsof
man-db
nano neofetch
neovim
openssh
paru
powertop
qemu-guest-agent
tcpdump
tealdeer
vim
wget
zsh
```
