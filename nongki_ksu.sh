#!/bin/bash

# After Reverse Engineering @tiann's installer script on how it can easily connect stuff
# This script is the result of hard work
# Also KSU is already obsolete so what's the point of demand for non-GKI?
# Like GKI is the norm now and ACK Kernels are going to be obsolete on January 2025

while true; do
    echo "Grabbing KernelSU v-0.9.5"
    aria2c https://archive.org/download/kernel-su-0.9.5/KernelSU-0.9.5.zip
    if [ ! -e "KernelSU-0.9.5.zip" ]; then
        echo "File missing!"
        echo "Redownloading"
        rm -rfv KernelSU*
    else
        echo "Found KSU"
        break
    fi
done


clear 
unzip KernelSU-0.9.5.zip

while true; do
    clear
    echo "Directory : $(pwd)"
    echo ""
    ls -lha
    echo ""
    read -p "Can you pinpoint where is the kernel source? [Y/n]: " SK
    case $SK in 
        [Yy]*)
            while true; do
                clear
                echo "Directory : $(pwd)"
                echo ""
                ls -lha
                echo ""
                read -p "Where is it? [$(pwd)/]: " LOC
                echo "DEBUG: LOC VAR SAYS: $LOC, ASSUMING SRC IS IN: $(pwd)/$LOC"
                echo ""
                echo "Ignore this ^ unless if theres an issue"
                DRIVER_MAKEFILE=$(pwd)/$LOC/drivers/Makefile
                DRIVER_KCONFIG=$(pwd)/$LOC/drivers/Kconfig
                if [ -e $LOC ] && [ -e $LOC/drivers ]; then 
                    echo "Source: $LOC OK"
                    echo "Driver: $LOC/drivers OK"
                    echo "Moving KSU Files to $(pwd)/$LOC"
                    ROOTDIR="$(pwd)"
                    echo "Starts"
                    mv -v "KernelSU" "$LOC/"
                    echo "Linking"
                    cd $LOC/drivers
                    ln -sf "$ROOTDIR/$LOC/KernelSU/kernel" "kernelsu" && echo "Linked!"
                    grep -q "kernelsu" || "$DRIVER_MAKEFILE" || printf "\nobj-\$(CONFIG_KSU) += kernelsu/\n" >> "$DRIVER_MAKEFILE" # Makefile Edited
                    grep -q "source \"drivers/kernelsu/Kconfig\"" "$DRIVER_KCONFIG" || sed -i "/endmenu/i\source \"drivers/kernelsu/Kconfig\"" "$DRIVER_KCONFIG" #KConfig EDited
                    echo "KConfig and Makefile edited"
                    cd $ROOTDIR
                    break
                else
                    echo "Error, can't find $(pwd)/$LOC"
                fi
            done
            ;;
        [Nn]*)
            echo "Abort"
            exit 9
            break
            ;;
        *)
            echo "Argument : $SK is not allowed, only Y or y or N or n only"
            ;;
    esac
exit
done
exit 
