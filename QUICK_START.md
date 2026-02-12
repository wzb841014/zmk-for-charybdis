# 🚀 快速入门指南

## 项目包含

基于 [choovick/zmk-config-charybdis](https://github.com/choovick/zmk-config-charybdis) + [Vzhao-L/zmk-for-charybdis](https://github.com/Vzhao-L/zmk-for-charybdis)

**新增功能**：
- ✅ SSD1306 OLED 1.69 寸显示屏支持
- ✅ 完整轨迹球配置（PMW3610）
- ✅ 独立模式和 Dongle 模式
- ✅ ZMK Studio 支持

## 1️⃣ 第一步：克隆到你的 GitHub

### 方法 A：使用 GitHub Template（推荐）

1. 访问项目页面
2. 点击 **"Use this template"** 按钮
3. 创建你的私有仓库

### 方法 B：Fork 现有仓库

```bash
# Fork 本项目到你的 GitHub
# 然后克隆到本地
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO
```

## 2️⃣ 第二步：配置 GitHub Actions（自动构建）

项目已预配置 GitHub Actions，推送代码后自动构建固件。

1. 访问你的 GitHub 仓库
2. 进入 **Settings → Actions → General**
3. 确保 **Allow all actions** 已启用
4. 推送更改到 main 分支

## 3️⃣ 第三步：获取固件

### 方式 A：GitHub Actions（推荐）

1. 进入 **Actions** 标签页
2. 点击最新的 workflow run
3. 下载 **firmware.zip** 文件

### 方式 B：本地构建

```bash
# 安装依赖
pip install west

# 克隆项目
git clone https://your-repo.git
cd your-repo

# 构建所有固件
./build.sh all

# 或者单独构建
./build.sh left        # 左键盘
./build.sh right       # 右键盘
./build.sh dongle64    # SSD1306 1.69寸 Dongle（推荐）
./build.sh dongle32    # SSD1306 128x32 Dongle
```

## 4️⃣ 第四步：刷写固件

### SSD1306 OLED 1.69 寸连接图

```
Nice!Nano      SSD1306 OLED
─────────      ─────────────
  3.3V    ──►    VCC
  GND     ──►    GND
  Pin 2   ──►    SDA
  Pin 3   ──►    SCL
```

### 刷写步骤

#### Dongle 模式（带 OLED）

1. 刷写 `settings_reset-nice_nano_v2-zmk.uf2` 到**所有三个设备**
2. 刷写 `dongle_nice_64-dongle_display-nice_nano_v2-zmk.uf2` 到 **Dongle**
3. 刷写 `charybdis_left-nice_nano_v2-zmk.uf2` 到左键盘
4. 刷写 `charybdis_right-nice_nano_v2-zmk.uf2` 到右键盘
5. **重要**：先配对左键盘，再配对右键盘

#### 独立模式

1. 刷写 `settings_reset-nice_nano_v2-zmk.uf2` 到两个键盘
2. 刷写键盘固件
3. 键盘自动配对

## 📁 固件说明

| 文件 | 用途 |
|------|------|
| `charybdis_left-nice_nano_v2-zmk.uf2` | 左键盘 |
| `charybdis_right-nice_nano_v2-zmk.uf2` | 右键盘 |
| `dongle_nice_64-dongle_display-nice_nano_v2-zmk.uf2` | **Dongle（1.69寸 OLED）** |
| `dongle_nice_32-dongle_display-nice_nano_v2-zmk.uf2` | Dongle（128x32 OLED） |

## 🔧 自定义配置

### 修改键位

编辑 `config/charybdis.keymap`

### 调整轨迹球灵敏度

- **硬件 CPI**：编辑 `boards/shields/charybdis/charybdis_right_common.dtsi`
- **软件缩放**：编辑 `boards/shields/charybdis/charybdis_trackball_processors.dtsi`

### 启用 ZMK Studio

项目已默认启用 ZMK Studio。解锁方法：同时按下右键盘的三个拇指键（RET + SYMBOLS + RAISE）

## 📚 文档链接

- [完整 README](README.md)
- [OLED 显示屏说明](README.md#-oled-显示功能)
- [轨迹球调整](README.md#-轨迹球灵敏度调整)
- [ZMK 官方文档](https://zmk.dev/docs/)
- [SSD1306 驱动模块](https://github.com/englmaxi/zmk-dongle-display)

## ❓ 常见问题

### Q: 1.69 寸 OLED 用哪个配置？
**A**: 使用 `dongle_nice_64`，1.69 寸 SSD1306 通常为 128x64 分辨率。

### Q: OLED 不亮怎么办？
**A**: 检查接线：VCC→3.3V, GND→GND, SDA→Pin 2, SCL→Pin 3

### Q: 如何重新配对键盘？
**A**: 刷写 `settings_reset-nice_nano_v2-zmk.uf2` 后重新配对

### Q: 轨迹球移动太快/太慢？
**A**: 修改 `charybdis_trackball_processors.dtsi` 中的 scaler 值

## 🎉 完成！

有问题？请提 [Issue](https://github.com/YOUR_REPO/issues)

祝你的 Charybdis 键盘使用愉快！ 🎮
