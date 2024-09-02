#!/bin/bash

# Submit Kernel to sourceforge

read -p "Where is the source root folder? (Current: '$(pwd)') : " ROOT
read -p "Username of SFTP: " SFUSER
read -p "Address of SFTP: " SFSERVER
read -p "Folder Location of SFTP to be sent (add / at initial entry because it is not defined in process): " SFLAND

echo "This is the result:"
echo ""
echo "Root Source: $ROOT"
echo "SFTP Username: $SFUSER"
echo "Address of SFTP: $SFSERVER"
echo "Folder Location of the SFTP: $SFLAND"
echo "Make sure its like: /home/files where '/'home defined or else it would cause issues then that is your fault at a million percentage"
echo ""
read -p "Are you sure that it's correct? (y/n): " RES

case $RES in
  [Yy]*)
    echo "Sending..."
    scp "$ROOT/arch/arm64/boot/Image" "$SFUSER@$SFSERVER:$SFLAND"
    echo "Done"
    ;;
  [Nn]*)
    exit
    ;;
  *)
    echo "Invalid Response"
    echo "Use: Y or y or N or n"
    exit 1
  ` ;;
esac
