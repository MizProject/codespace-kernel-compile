<h1 align=center>Codespace Kernel Compile</h1>
<p align=center>A proper portable environment capsule for Compiling Kernels, by using Codespaces or Gitpod and even any services running Debian 12 or Ubuntu</p>

---

Status:

[![github-forks](https://img.shields.io/github/forks/SUFandom/codespace-kernel-compile?label=Fork&style=flat&logo=github)](https://github.com/SUFandom/codespace-kernel-compile) ![alttext](https://img.shields.io/badge/Compatible_with_any_Codespaces-YES-BrightGreen) 

*Please check with the compatibility table for more by pressing [me](compat.md)*

You don't have to manually set up mostly everything because these tools already got you, just fork this repo, create a workspace and get working

---

To use the tools, run `sudo ./pre_setup.sh` to install all the tools necessary for kernel Compiling

The `post_setup.sh` are usually there if you want to have extended swap, although you can have extendable storage if /tmp is separated and very large, and you can circumvent any storage restriction (Although Github already knows this and you can't do that anymore so its disabled)

The `toolchain_grab.sh` meant to try grabbing aarch-llvm and clang tools easy to grab because you can just run one command and you got your own tools, you can edit the repo links and name at [repository_target](repository_target/) but do change the clang name and aarch-llvm name so it would target those folders

The `upload_kernel_raw.sh` is a tool to upload your kernel to an SFTP server like [Sourceforge](https://sourceforge.net) or your own storage server instead. Only do that when the make says the finished product is at arm64/boot/Image

---




[![Support badge](https://img.shields.io/badge/-Donate_to_my_Ko--fi_Account-blue)](https://ko-fi.com/xynoxx)


