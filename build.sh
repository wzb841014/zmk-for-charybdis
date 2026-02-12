#!/bin/bash

# ZMK Config Charybdis - 快速构建脚本
# 使用方法: ./build.sh [选项]
#
# 选项:
#   left      - 构建左键盘
#   right     - 构建右键盘
#   dongle64  - 构建 SSD1306 128x64 Dongle（推荐用于 1.69寸 OLED）
#   dongle32  - 构建 SSD1306 128x32 Dongle
#   all       - 构建所有固件
#   help      - 显示帮助信息

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置变量
BUILD_DIR="build"
BOARDS=("nice_nano_v2")

echo -e "${BLUE}🔧 ZMK Charybdis 构建脚本${NC}"
echo "===================================="

# 检查依赖
check_dependencies() {
    echo -e "${YELLOW}📦 检查依赖...${NC}"

    if ! command -v west &> /dev/null; then
        echo -e "${RED}❌ west 未安装${NC}"
        echo "   请安装 Zephyr SDK 和 west:"
        echo "   pip install west"
        exit 1
    fi

    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ git 未安装${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ 依赖检查完成${NC}"
}

# 初始化 ZMK workspace
init_workspace() {
    echo -e "${YELLOW}📁 初始化 ZMK workspace...${NC}"

    if [ ! -d ".west" ]; then
        west init -l config
        west update
    else
        echo "   Workspace 已初始化"
    fi

    echo -e "${GREEN}✅ Workspace 初始化完成${NC}"
}

# 构建函数
build_firmware() {
    local shield=$1
    local desc=$2

    echo -e "${BLUE}🔨 构建: ${desc}${NC}"
    echo "   Shield: ${shield}"

    west build -b nice_nano_v2 \
        -s app \
        -d "${BUILD_DIR}/${shield}" \
        -- -DSHIELD="${shield}"

    if [ -f "${BUILD_DIR}/${shield}/zephyr/zmk.uf2" ]; then
        cp "${BUILD_DIR}/${shield}/zephyr/zmk.uf2" "${BUILD_DIR}/"
        echo -e "${GREEN}✅ 固件已保存: ${BUILD_DIR}/$(basename ${BUILD_DIR}/${shield}/zephyr/zmk.uf2)${NC}"
    else
        echo -e "${RED}❌ 构建失败${NC}"
        exit 1
    fi
}

# 构建所有固件
build_all() {
    echo -e "${BLUE}🚀 开始构建所有固件...${NC}"
    echo ""

    mkdir -p "${BUILD_DIR}"

    # 构建基础键盘
    build_firmware "charybdis_left" "左键盘"
    echo ""
    build_firmware "charybdis_right" "右键盘"
    echo ""

    # 构建 Dongle
    echo -e "${YELLOW}🖥️  构建 OLED Dongle（支持 SSD1306 1.69寸）...${NC}"
    build_firmware "dongle_nice_64 dongle_display" "Nice!Nano Dongle (128x64/1.69寸)"
    echo ""

    echo -e "${GREEN}✨ 所有固件构建完成！${NC}"
    echo ""
    echo "固件位置: ${BUILD_DIR}/"
    ls -lh "${BUILD_DIR}"/*.uf2 2>/dev/null || echo "   无固件文件"
}

# 显示帮助
show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  left      构建左键盘固件"
    echo "  right     构建右键盘固件"
    echo "  dongle64  构建 SSD1306 128x64 Dongle（推荐用于 1.69寸 OLED）"
    echo "  dongle32  构建 SSD1306 128x32 Dongle"
    echo "  all       构建所有固件（默认）"
    echo "  help      显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 all        # 构建所有固件"
    echo "  $0 dongle64   # 仅构建 1.69寸 OLED Dongle"
    echo "  $0 left       # 仅构建左键盘"
}

# 主程序
main() {
    local mode=${1:-all}

    case $mode in
        left)
            check_dependencies
            init_workspace
            build_firmware "charybdis_left" "左键盘"
            ;;
        right)
            check_dependencies
            init_workspace
            build_firmware "charybdis_right" "右键盘"
            ;;
        dongle64)
            check_dependencies
            init_workspace
            build_firmware "dongle_nice_64 dongle_display" "Nice!Nano Dongle (128x64/1.69寸)"
            ;;
        dongle32)
            check_dependencies
            init_workspace
            build_firmware "dongle_nice_32 dongle_display" "Nice!Nano Dongle (128x32)"
            ;;
        all)
            check_dependencies
            init_workspace
            build_all
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${RED}❌ 未知选项: $mode${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
