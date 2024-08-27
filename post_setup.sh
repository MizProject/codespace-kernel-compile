#!/bin/bash

if [ "$1" == --help ] || [ "$1" == "-h" ]; then 
    echo "post_setup.sh"
    echo "Script to finalize setup of your codespace, by adding swap or storage (or both)"
    echo ""
    echo "Usage:"
    echo "./post_setup.sh <arg>"
    echo ""
    echo "--help -h     Help"
    echo "--umount -u   Unmount"
    exit
fi


if [ ! $(/usr/bin/id -u) == 0 ]; then
    echo "You need Root first"
    exit 1
fi

# Adding removing swap because whynot
if [ "$1" == "--umount" ] || [ "$1" == "-u" ]; then
    function umount_rm_sys_swap() {
        if [ -e /tmp/swap_unc ]; then
            echo "Found swapfile, unmounting and deleting it"
            swapoff /tmp/swap_unc
            rm -rf /tmp/swap_unc
        else
            echo "No swapfile found"
        fi
    }
    function umount_rm_storage() {
        if [ -e /workspaces/diskmnt ] && [ -e /tmp/disk_loop ]; then
            echo "Found disk, unmounting and deleting it"
            umount /workspaces/diskmnt
            rm -rf /tmp/disk_loop
        else
            echo "No loop disk found"
        fi
    }
    umount_rm_sys_swap
    umount_rm_storage
    exit
fi

function setup_codebase_sys_swap() {
    # Assuming Codespace root gave you 32GB of Space
    # Then we will try to expand our limits here
    # Swap
    if [ -e /tmp/swap_unc ]; then
        echo "Swap already created... No need for swap adding"
    else
        read -p "Do you want to have a swap in the codespace? (Answer: y/N) Warning: Enabling this will create unencrypted swap in /tmp: " ANS
        case $ANS in
            [Yy]*)
                read -p "8 or 16GB? (Answer: 8/16)" size
                case $size in
                    "8")
                        echo "Wait..."
                        fallocate -l 8G /tmp/swap_unc
                        chmod 600 /tmp/swap_unc
                        swapon /tmp/swap_unc
                        echo "Done"
                        ;;
                    "16")
                        echo "Wait..."
                        fallocate -l 16G /tmp/swap_unc
                        chmod 600 /tmp/swap_unc
                        swapon /tmp/swap_unc
                        echo "Done"
                        ;;
                    *)
                        echo "$size is invalid"
                        echo "Only allowed: 8 / 16"
                        echo "Fall back to 8G"
                        fallocate -l 8G /tmp/swap_unc
                        chmod 600 /tmp/swap_unc
                        swapon /tmp/swap_unc
                        echo "Done"
                        ;;
                esac
            [Nn]*)
                echo "Swap won't be added"
                ;;
            *)
                echo "$ANS is not a valid response"
                exit 1
                ;;
        esac
    fi
}

function setup_storage_space() {
    # You want expanded storage?? Ill give you expanded storage...
    # Idk if microsoft would patch this even i guess
    if [ -e /tmp/disk_loop ] && [ -e /workspaces/diskmnt ]; then
        echo "No need to setup storage space... its already available"
        echo "df -h /workspaces/diskmnt"
        df -h /workspaces/diskmnt
        echo "df -h /tmp/disk_loop"
        df -h /tmp/disk_loop
    else
        echo "Size Available: None[0], 24GB [24] and 40GB [40]"
        read -p "Choose what additional storage size you wanted, you can ignore this if you want... (Warning: The space/disk will be reset after codespace ends itselfm, suggest you should now wha you are doing): " STOR
        case $STOR in
            "24")
                echo "Wait..."
                mkdir -p /workspaces/diskmnt
                dd if=/dev/zero of=/tmp/disk_loop bs=1024 count=25769803776 status=progress
                echo "Done creating, now formatting and mounting"
                echo "Setting up disks"
                LS="$(losetup -f)"
                losetup "$LS" /tmp/disk_loop
                mkfs.ext4 "$LS"
                echo "Mounting on /workspaces/diskmnt"
                mount -o defaults,rw "$LS" /workspaces/diskmnt
                echo "Printing disk info to output_disks.txt"
                tune2fs -l "$LS" > output_disks.txt
                echo "Done"
                echo "Disks created + mounted"
                ;;
            "40")
                echo "Wait..."
                mkdir -p /workspaces/diskmnt
                dd if=/dev/zero of=/tmp/disk_loop bs=1024 count=42949672960 status=progress
                echo "Done creating, now formatting and mounting"
                echo "Setting up disks"
                LS="$(losetup -f)"
                losetup "$LS" /tmp/disk_loop
                mkfs.ext4 "$LS"
                echo "Mounting on /workspaces/diskmnt"
                mount -o defaults,rw "$LS" /workspaces/diskmnt
                echo "Printing disk info to output_disks.txt"
                tune2fs -l "$LS" > output_disks.txt
                echo "Done"
                echo "Disks created + mounted"
                ;;  
            "0")
                echo "Aborted creating disks"
                ;;
            *)
                echo "$STOR is invalid"
                echo "Only allowed: 0 / 24 / 40"
                exit 1
                ;;
        esac
    fi
}

setup_codebase_sys_swap
setup_storage_space