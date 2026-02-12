# 🪟 Windows 本地编译指南

在 Windows 上编译 ZMK 固件需要使用 WSL（Windows Subsystem for Linux）。以下是完整步骤：

## 📋 前置要求

- Windows 10/11
- 至少 10GB 空闲磁盘空间
- 稳定的网络连接

---

## 🚀 第一步：安装 WSL

### 方法 A：PowerShell（管理员模式）

```powershell
# 安装 WSL 2（会自动安装 Ubuntu）
wsl --install

# 重启电脑
```

### 方法 B：手动安装

1. 启用 **Windows Subsystem for Linux** 功能
2. 安装 **Ubuntu 20.04 LTS** 或 **22.04 LTS**（Microsoft Store）
3. 设置 WSL 2 为默认版本：
   ```powershell
   wsl --set-default-version 2
   ```

### 验证 WSL

打开 Ubuntu 终端，运行：
```bash
wsl --version
```

---

## 🐧 第二步：WSL 环境配置

打开 **Ubuntu 终端**，执行以下命令：

### 1. 更新系统

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. 安装 Python 和 pip

```bash
sudo apt install -y python3 python3-pip python3-venv git wget unzip
```

### 3. 安装 Zephyr SDK

```bash
# 创建工作目录
mkdir ~/zmk && cd ~/zmk

# 下载 Zephyr SDK 安装器
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.5/zephyr-sdk-0.16.5_linux-x86_64.tar.xz

# 解压
tar -xf zephyr-sdk-0.16.5_linux-x86_64.tar.xz

# 安装（按提示操作）
./zephyr-sdk-0.16.5_linux-x86_64/setup.sh

# 安装 udev 规则（允许访问 USB 设备）
sudo cp ~/zmk/zephyr-sdk-0.16.5_linux-x86_64/sysroots/etc/udev/rules.d/* /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger

# 添加环境变量（添加到 ~/.bashrc）
echo 'export ZEPHYR_SDK_INSTALL_DIR=~/zmk/zephyr-sdk-0.16.5_linux-x86_64' >> ~/.bashrc
source ~/.bashrc
```

---

## 📦 第三步：克隆项目

### 1. 克隆 ZMK 配置项目

```bash
cd ~/zmk
git clone https://github.com/YOUR_USERNAME/YOUR_ZMK_REPO.git
cd YOUR_ZMK_REPO
```

### 2. 初始化 ZMK workspace

```bash
west init -l config
west update
```

---

## 🔨 第四步：编译固件

### 构建所有固件

```bash
# 创建构建目录
mkdir build && cd build

# 构建 SSD1306 1.69寸 OLED Dongle
west build -b nice_nano_v2 -s app -- -DSHIELD="dongle_nice_64 dongle_display"

# 固件位置：build/zephyr/zmk.uf2
```

### 单独构建每个固件

```bash
# 左键盘
west build -b nice_nano_v2 -s app -- -DSHIELD="charybdis_left"

# 右键盘
west build -b nice_nano_v2 -s app -- -DSHIELD="charybdis_right"

# Dongle 128x64（1.69寸 OLED）
west build -b nice_nano_v2 -s app -- -DSHIELD="dongle_nice_64 dongle_display"

# Dongle 128x32
west build -b nice_nano_v2 -s app -- -DSHIELD="dongle_nice_32 dongle_display"
```

### 固件输出位置

所有 `.uf2` 文件位于：
```
build/zephyr/zmk.uf2
```

---

## 💻 第五步：刷写固件

### 1. 复制固件到 Windows

在文件资源管理器中：
```
\\wsl$\Ubuntu\home\YOUR_USERNAME\zmk\YOUR_REPO\build\zephyr\
```

### 2. 刷写步骤

1. 双击 Nice!Nano 上的 **RESET** 按钮
2. 键盘会作为 USB 磁盘挂载
3. 将 `.uf2` 文件复制到磁盘
4. 设备自动刷写并重启

---

## 🆘 常见问题

### Q: west 命令找不到

```bash
# 安装 west
pip install west

# 验证
west --version
```

### Q: USB 设备不被识别

1. 确保安装了 [USB/IP Tool](https://docs.zmk.dev/docs/new/user-setup#usb-permissions)
2. 在 WSL 中配置 USB 转发：
   ```powershell
   # 在 PowerShell 中
   usbipd list
   usbipd bind --busid=...
   wsl --install -d ubuntu
   ```
3. 或使用 [usbipd-win](https://github.com/dorssel/usbipd-win)

### Q: 编译错误

```bash
# 清理构建缓存
west build --clean

# 重新构建
west build -b nice_nano_v2 -s app -- -DSHIELD="dongle_nice_64 dongle_display"
```

### Q: 权限问题

```bash
# 添加当前用户到 dialout 组
sudo usermod -a -G dialout $USER

# 重启 WSL
exit
wsl ~
```

---

## 📞 快速参考命令

| 操作 | 命令 |
|------|------|
| 初始化项目 | `west init -l config && west update` |
| 构建所有 | `./build.sh all` |
| 构建 Dongle | `west build -b nice_nano_v2 -s app -- -DSHIELD="dongle_nice_64 dongle_display"` |
| 清理构建 | `west build --clean` |
| 查看帮助 | `./build.sh help` |

---

## 🎉 完成！

有问题？请查看：
- [ZMK 官方文档](https://zmk.dev/docs/)
- [GitHub Issues](https://github.com/YOUR_REPO/issues)
