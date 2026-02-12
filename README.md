# ZMK Config for Charybdis - with SSD1306 OLED Support

基于 [choovick/zmk-config-charybdis](https://github.com/choovick/zmk-config-charybdis) 和 [Vzhao-L/zmk-for-charybdis](https://github.com/Vzhao-L/zmk-for-charybdis) 的整合配置。

## ✨ 新增功能

### SSD1306 OLED 1.69 寸显示屏支持

本配置新增了对 **SSD1306 OLED 1.69 寸显示屏** 的支持。

**注意**：1.69 寸 SSD1306 OLED 通常分辨率为 **128x64**，与 0.96 寸版本相同。

## 📋 目录结构

```
zmk-config-charybdis/
├── boards/                          # ZMK shield 配置
│   └── shields/
│       ├── charybdis/               # Charybdis 键盘 shield
│       │   ├── charybdis.dtsi                        # 设备树定义
│       │   ├── charybdis_right_common.dtsi           # 右键盘硬件配置
│       │   ├── charybdis_trackball_processors.dtsi  # 轨迹球处理
│       │   ├── dongle_common.dtsi                   # Dongle 通用配置
│       │   ├── dongle_nice_common.dtsi              # Nice!Nano Dongle 配置
│       │   ├── dongle_nice_64.conf                   # SSD1306 128x64 配置
│       │   ├── dongle_nice_64.overlay                # 设备树 overlay
│       │   ├── dongle_nice_32.conf                   # SSD1306 128x32 配置
│       │   ├── dongle_nice_32.overlay                # 设备树 overlay
│       │   ├── Kconfig.shield                        # Shield 标识
│       │   └── Kconfig.defconfig                    # 默认配置
├── config/                          # 主配置目录
│   ├── charybdis.conf               # 全局 ZMK 配置
│   ├── charybdis.keymap             # 键盘映射（保留 Vzhao 原始配置）
│   ├── charybdis.zmk.yml            # ZMK 构建配置
│   └── west.yml                     # West 依赖清单
├── zephyr/
│   └── module.yml                   # Zephyr 模块标记
└── build.yaml                       # GitHub Actions 构建配置
```

## 🔧 使用方法

### 1. 构建固件

#### GitHub Actions（推荐）

推送更改到 GitHub，GitHub Actions 将自动构建所有配置的固件。

固件文件将在 Actions artifacts 中提供，包括：
- `charybdis_left-nice_nano_v2-zmk.uf2` - 左键盘固件
- `charybdis_right-nice_nano_v2-zmk.uf2` - 右键盘固件
- `dongle_nice_64-dongle_display-nice_nano_v2-zmk.uf2` - SSD1306 128x64 Dongle 固件
- `dongle_nice_32-dongle_display-nice_nano_v2-zmk.uf2` - SSD1306 128x32 Dongle 固件

#### 本地构建

使用 Docker 构建：

```bash
# 构建左键盘
west build -b nice_nano_v2 -s app -d build_left -- -DSHIELD="charybdis_left"

# 构建右键盘
west build -b nice_nano_v2 -s app -d build_right -- -DSHIELD="charybdis_right"

# 构建 SSD1306 128x64 Dongle（推荐用于 1.69 寸 OLED）
west build -b nice_nano_v2 -s app -d build_dongle64 -- -DSHIELD="dongle_nice_64 dongle_display"

# 构建 SSD1306 128x32 Dongle
west build -b nice_nano_v2 -s app -d build_dongle32 -- -DSHIELD="dongle_nice_32 dongle_display"
```

### 2. 刷写固件

1. **双击**控制器上的 **RESET** 按钮进入 bootloader 模式
2. 键盘将作为 USB 磁盘挂载
3. 将对应的 `.uf2` 文件复制到 USB 磁盘
4. 设备将自动刷写并重启

#### 独立模式

1. 刷写 `settings_reset-nice_nano_v2-zmk.uf2` 到**两个**键盘
2. 刷写 `charybdis_left-nice_nano_v2-zmk.uf2` 到左键盘
3. 刷写 `charybdis_right-nice_nano_v2-zmk.uf2` 到右键盘

#### Dongle 模式（带 OLED）

1. 刷写 `settings_reset-nice_nano_v2-zmk.uf3` 到**所有三个设备**
2. 刷写对应固件：
   - **128x64（1.69寸推荐）**：`dongle_nice_64-dongle_display-nice_nano_v2-zmk.uf2`
   - **128x32**：`dongle_nice_32-dongle_display-nice_nano_v2-zmk.uf2`
3. 刷写键盘固件
4. **重要**：先配对左键盘，再配对右键盘

### 3. OLED 显示屏连接

**SSD1306 OLED 接线（Nice!Nano）**：

| OLED | Nice!Nano |
|------|-----------|
| VCC  | 3.3V      |
| GND  | GND       |
| SDA  | Pin 2     |
| SCL  | Pin 3     |

## 🎯 轨迹球灵敏度调整

### 硬件 CPI（传感器灵敏度）

修改 `boards/shields/charybdis/charybdis_right_common.dtsi`：

```dts
trackball: trackball@0 {
    compatible = "pixart,pmw3610";
    cpi = <800>;  // 改为 400/800/1200/1600
};
```

### 软件缩放（移动速度）

修改 `boards/shields/charybdis/charybdis_trackball_processors.dtsi`：

```dts
// 普通移动
move {
    layers = <BASE POINTER>;
    input-processors = <&zip_xy_scaler 7 6>;
};

// 精确模式
snipe {
    layers = <SNIPING>;
    input-processors = <&zip_xy_scaler 1 3>;
};

// 滚动模式
scroll {
    layers = <SCROLL>;
    input-processors = <&zip_xy_scaler 1 10>;
};
```

公式：`output = (input × multiplier) / divisor`

## 📱 OLED 显示功能

### SSD1306 128x64 / 1.69寸显示内容

- ✅ 当前图层名称（居中滚动显示）
- ✅ 左右键盘电量
- ✅ HID 状态指示（CAPS/NUM/SCROLL）
- ✅ 输出状态（USB/BLE 连接）
- ✅ 修饰键显示（Shift/Ctrl/Alt/GUI）
- ✅ Bongo Cat 动画
- ✅ 显示超时：5 分钟（可配置）

## 🔗 依赖模块

本配置使用以下外部模块：

- **zmk-pmw3610-driver**：PMW3610 轨迹球驱动
- **prospector-zmk-module**：Prospector 显示屏模块
- **zmk-dongle-display**：SSD1306 OLED 显示屏驱动

## 📝 注意事项

1. **1.69寸 OLED**：市面上的 1.69 寸 SSD1306 OLED 通常采用 128x64 分辨率，与 0.96 寸版本兼容
2. **Dongle 模式**：使用 Dongle 时，建议先配对左键盘，再配对右键盘以正确显示电量
3. **OLED 接线**：确保 I2C 引脚正确连接（SDA→Pin 2, SCL→Pin 3）

## 🙏 致谢

- [choovick/zmk-config-charybdis](https://github.com/choovick/zmk-config-charybdis) - 原始配置和 OLED 支持
- [Vzhao-L/zmk-for-charybdis](https://github.com/Vzhao-L/zmk-for-charybdis) - 基础配置和 keymap
- [zmk-dongle-display](https://github.com/englmaxi/zmk-dongle-display) - SSD1306 驱动模块

## 📄 许可证

MIT License
