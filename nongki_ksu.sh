#!/bin/bash

# Using Rissu Fork of KSU instead because tiann removed the Non-GKI support

case "$1" in
    "--kernel:4.19")
        HOOK_TARGET="4.19_hook_patch.diff"
        ;;
    "--kernel:4.14")
        HOOK_TARGET="4.14_hook_patch.diff"
        ;;
    "--kernel:4.9")
        HOOK_TARGET="4.9_hook_patch.diff"
        ;;
    "--kernel:4.4")
        HOOK_TARGET="4.4_hook_patch.diff"
        ;;
    [--help/-h]*)
        echo ""
        echo "KSU NON-GKI Setup src"
        echo "Brought to you by rissu (on ksu fork) and SUFandom(on this script)"
        echo "v1"
        echo ""
        echo "Usage:"
        echo "./nongki_ksu.sh --<args>"
        echo ""
        echo "Arguments"
        echo "  --help -h               Shows this help page"
        echo "  --kernel:<version>      Uses the patch method readily available"
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
        echo "For GKI Kernels, do check with tiann's installer script instead"
        echo "Earlier than 4.4 isn't supported"
        echo ""
        exit
        ;;
    *)
        ./nongki_ksu.sh --help
        exit
        ;;
esac
        



ROOT="$(pwd)" # ENV 
FULL_SRC="$ROOT/$SOURCE" # May be self-explanatory
SOURCE="" # Kernel Source
SYMLINKTO="$FULL_SRC/drivers/kernelsu" # For symlink
DRIVERS="$FULL_SRC/drivers" # also explanatory
PATCHRUN="$FULL_SRC/KernelSU/hook_patch/$HOOK_TARGET"
KSU_MOVED="$FULL_SRC/KernelSU"

function clone_service() {
    # Cloning KSU Fork
    git clone https://github.com/rsuntk/KernelSU
}

function mvfile () {
    # MOVE KSU TO KERNEL SOURCE
    mv KernelSU $SOURCE/
}

function linkit() {
    # Link KSU
    cd $DRIVERS
    ln -sf "$SYMLINKTO" "$KSU_MOVED/kernel"
}


