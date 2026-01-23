#!/bin/bash

# Update mkinitcpio.conf to include NVIDIA modules in early boot
sudo sed -i 's/^MODULES=()$/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf

# Rebuild initramfs
sudo mkinitcpio -P
