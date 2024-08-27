#!/bin/bash

if [ ! $(/usr/bin/id -u) == 0 ]; then
    echo "You need Root first"
    exit 1
fi

function setup_codebase_sys_swap() {
    # Assuming Codespace root gave you 32GB of Space
    # Then we will try to expand our limits here
    # Swap
    if [ -e /tmp/swap_unc ]; then
        echo "Swap already created... No need for swap adding"
    else
        read -p "Do you want to have a swap in the codespace? (Answer: y/N) Warning: Enabling this will create unencrypted swap in /tmp" ANS
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




setup_codebase_sys_swap
