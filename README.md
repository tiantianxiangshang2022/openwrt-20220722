openwrt
=
Version:22.03-2023-0405

Compilation steps:

**1 安装编译依赖**
```bash
sudo apt update -y && sudo apt full-upgrade -y && 
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2 python2.7 python3 python3-pyelftools \
libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip npm \
vim wget xmlto xxd zlib1g-dev g++ 2to3 dh-python libfuse-dev file ecj java-propose-classpath lib32gcc-s1
```

**2 创建工作目录**
```bash
mkdir openwrt
```

**3 进入工作目录**
```bash
cd openwrt
```
**4 下载源代码**
```bash
git clone https://github.com/tiantianxiangshang2022/openwrt-20220722.git
```
**5 进入openwrt文件夹**
```bash
cd openwrt
```
**6 更新 feeds 并选择配置**
```bash
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
```
**7 下载 dl 库，编译固件**
```bash
make download -j8
make -j1 V=s
```

二次编译：

```bash
cd lede
git pull
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make download -j8
make V=s -j$(nproc)
```

如果需要重新配置：

```bash
rm -rf ./tmp && rm -rf .config
make menuconfig
make V=s -j$(nproc)
```
