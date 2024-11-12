#!/bin/bash

# This is toolchain Grab
# Made by SUFandom to grabbing toolchains faster in your setup
# Because you want to make your work efficient as possible

# WE GRAB THE VARIABLES THAT HAS BEEN SET
CLANG=$(< repository_target/clang )
LLVM=$(< repository_target/aarch64-llvm )
CLANG_NAME=$(< repository_target/clang-name )
LLVM_NAME=$(< repository_target/llvm-name )

function transfer_souls() {
    read -p "Do you want to transfer these toolchains directly to your kernel source? (y/n): " ans
    case $ans in
        [Yy]*)
            clear
            echo "Directory: "
            echo ""
            ls -lha
            echo ""
            read -p "Directory: $(pwd)/:" loc
            read -p "Are you sure its on $(pwd)/$loc (y/n): " answ
            case $answ in
                [Yy]*)
                    mv $CLANG_NAME $(pwd)/$loc/
                    mv $LLVM_NAME $(pwd)/$loc/
                    echo "Done"
                    exit
                    ;;
                [Nn]*)
                    echo "Aborted, but the tools are already cloned and not moved"
                    exit 1
                    ;;
                *)
                    echo "$answ is not a valid response"
                    exit 1
                    ;;
            esac
            ;;
        [Nn]*)
            echo "Done, except transferring the tools to src"
            exit
            ;;
        *)
            echo "$ans is not a valid response, although the files are here, go celebrate i guess"
            exit 1
            ;;
    esac
}

function kawa_a_yan() {
    # Kawa-a yan means "grab it"

    echo "Automatically grabbing tools that are also needed on compile"
    echo "Following:"
    echo "Clang: $CLANG"
    echo "LLVM: $LLVM"
    echo "Edit entries at $(pwd)/repository_target"
    echo "Abort if necessary, do: Ctrl + C"
    echo "Starts in"
    TIMER=10
    while true; do
        echo "...$TIMER"
        $TIMER=$((--TIMER))
        sleep 1
        if [[ $TIMER == '0' ]]; then
            echo "STARTING!"
            break
        fi
    done
    git clone $CLANG $CLANG_NAME
    git clone $LLVM $LLVM_NAME
    check
}

function check() {
    if [ -e $CLANG_NAME ] && [ -e $LLVM_NAME ]; then
        transfer_souls
    else
        echo "One of them failed, retrying"
        kawa_a_yan
    fi
}

kawa_a_yan
