# temp

https://www.youtube.com/watch?v=eTWf5D092VY

- amd_iommu kernel cmdline parameter doesn't exist, you can ignore it
- amd doesn't explicitly state if iommu is enabled in dmesg
- leave at least one core and 4 GiB for host
- to pass through a usb device (steelseries gamedac) that has a device number that changes upon loading the guest, pass the pci usb controller device
- use or use a modified version of the hook scripts in the hook subdirectory
- you may also want to share a filesystem with the guest
- virtio network card

- hyperv enlightenments
- set cpu cores according to topology and pin them
- huge pages?
- https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Performance_tuning
