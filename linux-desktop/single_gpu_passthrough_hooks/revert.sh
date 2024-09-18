#!/bin/bash
set -x
  
# rebind usb controller for usb dac audio
virsh nodedev-reattach pci_0000_0c_00_4

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach pci_0000_01_00_1
virsh nodedev-reattach pci_0000_01_00_0

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# Rebind VT consoles
#echo 1 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
#echo 1 > /sys/class/vtconsole/vtcon1/bind

nvidia-xconfig --query-gpu-info > /dev/null 2>&1
#echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl start sddm.service
