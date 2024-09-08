#!/bin/bash

# Using Rissu Fork of KSU instead because tiann removed the Non-GKI support
# Use tiann's installer if kernel is GKI, or modify some parts of this script to support it


case "$1" in
    "--kernel:4.19")
        HOOK_TARGET="4.19_hook_patch.diff"
        SPECIAL_TRIGGER=0
        ;;
    "--kernel:4.14")
        HOOK_TARGET="4.14_hook_patch.diff"
        SPECIAL_TRIGGER=0
        ;;
    "--kernel:4.9")
        HOOK_TARGET="4.9_hook_patch.diff"
        SPECIAL_TRIGGER=0
        ;;
    "--kernel:4.4")
        HOOK_TARGET="4.4_hook_patch.diff"
        SPECIAL_TRIGGER=0
        ;;
    [--help/-h]*)
        echo ""
        echo "KSU NON-GKI Setup src"
        echo "Brought to you by rissu (on ksu fork) and SUFandom(on this script)"
        echo "v1"
        echo ""
        echo "Usage:"
        echo "./nongki_ksu.sh --<args1> --<args2>"
        echo ""
        echo "Arguments"
        echo "  --help -h                   Shows this help page"
        echo "  --kernel:<version>          Uses the patch method readily available"
        echo "  --download-move-and-link    Self explainatory, just grab repo"
        echo "                              move it, and link it (not including patching)"
        echo "  --list-conf                 Lists all available configuration"
        echo "                              That is device-specific. released by contributors"
        echo "                              "
        echo ""
        echo "Patch:"
        echo "  Usage:"
        echo "  ./nongki_ksu.sh --kernel:4.4"
        echo ""
        echo "  Version:"
        echo "      4.4 Kernel      --kernel:4.4"
        echo "      4.9 Kernel      --kernel:4.9"
        echo "      4.14 Kernel     --kernel:4.14"
        echo "      4.19 Kernel     --kernel:4.19"
        echo ""
        echo "Additional Args:"
        echo ""
        echo "Configuration Variants:"
        echo "  Usages:"
        echo "      ./nongki_ksu.sh --kernel:4.19 --conf:a12s"
        echo ""
        echo "It's the Secondary argument, meant for device-specific configurations only"
        echo "Provided by Contributors"
        echo ""
        echo "For GKI Kernels, do check with tiann's installer script instead"
        echo "Earlier than 4.4 isn't supported"
        echo ""
        exit
        ;;
    "--download-move-and-link")
        SPECIAL_TRIGGER=1
        ;;
    "--list-conf")
            echo ""
            echo "Available configurations: "
            echo ""
            echo " --conf:a12s              Configuration Made by @SUFandom"
            echo ""
            echo "Your device conf isn't here? Do make a push at https://github.com/SUFandom/KernelSU"
            echo ""
            ;;
    *)
        ./nongki_ksu.sh --help
        exit
        ;;
esac
        



DIRROOT="$(pwd)" # ENV 
# FULL_SRC="$DIRROOT/$SOURCE" # May be self-explanatory # Update : FUCKING SHIT THIS VARIABLE TURNS EVERYTHING TO FUCKING NULL WHAT IN FUCK SAKE
SOURCE="" # Kernel Source
# SYMLINKTO="$DIRROOT/$SOURCE/drivers/kernelsu" # For symlink
# DRIVERS="$DIRROOT/$SOURCE/drivers" # also explanatory
# PATCHRUN="$DIRROOT/$SOURCE/KernelSU/hook_patch/$HOOK_TARGET"
# KSU_MOVED="$DIRROOT/$SOURCE/KernelSU"

echo "ROOT: $DIRROOT"

function clone_service() {
    # Cloning KSU Fork
    # git clone https://github.com/rsuntk/KernelSU
    git clone https://github.com/SUFandom/KernelSU
}

function mvfile () {
    # MOVE KSU TO KERNEL SOURCE
    mv $DIRROOT/KernelSU $SOURCE/
}

function linkit() {
    # Link KSU
    cd $SOURCE/drivers
    ln -sf "$DIRROOT/$SOURCE/KernelSU/kernel" "$DIRROOT/$SOURCE/drivers/kernelsu" 
}

function patch() {
    cd .. # Force redir to repo
    if [ -z "$2" ]; then
        git apply --stat --check "KernelSU/hook_patch/$HOOK_TARGET"
    elif [ "$2" == "--conf:a12s"  ]
        git apply --stat --check "KernelSU/hook_patch/4.19_hook_patch-a12s.diff"
    fi
    git apply --stat --check "KernelSU/hook_patch/Kcm-4.19-a12s.diff" # This requires jsut adding 2 ksu variables
}
function revert_dir_location() {
    cd $DIRROOT
}

case $SPECIAL_TRIGGER in
    0)
        while true; do
            read -p "Do you want to try KSU and apply patches? [Y/n]: " ans
            read -p "Where is the folder?: " SOURCE
            case $ans in
                [Y/y]*)
                    echo "OK!"
                    break
                    ;;
                [N/n]*)
                    exit 1
                    exit 1 # if in doubt, double it, like gambling
                    break
                    ;;
                *)
                    echo "$ans is wrong"
                    clear
                    ;;
            esac
        done
        
        sleep 3
        echo "[-] Grabbing KSU"
        clone_service
        
        echo "[Y] DONE"
        echo "[-] Moving"
        
        mvfile
        echo "[Y] DONE"
        echo "[-] Linking"
        
        linkit
        echo "[Y] Done"
        echo "[-] Patching"
        
        patch
        echo "[Y] Done"
        
        revert_dir_location
        exit
        ;;
    1)
        while true; do
            read -p "Do you want to try KSU? [Y/n]: " ans
            case $ans in
                [Y/y]*)
                    echo "OK!"
                    break
                    ;;
                [N/n]*)
                    exit 1
                    exit 1 # if in doubt, double it, like gambling
                    break
                    ;;
                *)
                    echo "$ans is wrong"
                    clear
                    ;;
            esac
        done
        echo "[-] Grabbing KSU"
        clone_service
        echo "[Y] DONE"
        echo "[-] Moving"
        mvfile
        echo "[Y] DONE"
        echo "[-] Linking"
        linkit
        echo "[Y] Done"
        revert_dir_location
        exit
        ;;
esac



