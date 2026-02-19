#!/bin/bash

# =============================================================================
# Agent Skills 一键安装脚本
# 用法: 把此脚本放到任意项目根目录执行
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Skills 模板目录 (与脚本同目录)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Agent Skills 一键安装脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检测当前目录是否为 Git 项目
if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "project.godot" ]; then
    echo -e "${YELLOW}⚠️  警告: 当前目录可能不是项目根目录${NC}"
    echo ""
fi

# 项目路径
PROJECT_DIR="$(pwd)"
echo -e "${GREEN}📂 项目目录: $PROJECT_DIR${NC}"
echo ""

# 安装函数
install_skills() {
    echo -e "${BLUE}🔧 正在安装 Agent Skills...${NC}"
    echo ""

    # 检查模板是否存在
    if [ ! -d "$SKILLS_DIR/.claude" ] || [ ! -d "$SKILLS_DIR/.factory" ] || [ ! -d "$SKILLS_DIR/.opencode" ]; then
        echo -e "${RED}❌ 错误: 找不到 Skills 模板目录${NC}"
        echo "请确保以下目录存在:"
        echo "  - $SKILLS_DIR/.claude"
        echo "  - $SKILLS_DIR/.factory"
        echo "  - $SKILLS_DIR/.opencode"
        exit 1
    fi

    # 复制文件
    echo "📦 复制配置文件..."

    # .claude
    if [ -d "$SKILLS_DIR/.claude" ]; then
        mkdir -p .claude
        cp -r "$SKILLS_DIR/.claude/." .claude/
        echo "  ✅ .claude/"
    fi

    # .factory
    if [ -d "$SKILLS_DIR/.factory" ]; then
        mkdir -p .factory
        cp -r "$SKILLS_DIR/.factory/." .factory/
        echo "  ✅ .factory/"
    fi

    # .opencode
    if [ -d "$SKILLS_DIR/.opencode" ]; then
        mkdir -p .opencode
        cp -r "$SKILLS_DIR/.opencode/." .opencode/
        echo "  ✅ .opencode/"
    fi

    echo ""
    echo -e "${GREEN}✅ 安装完成！${NC}"
    echo ""
}

# 分析项目并生成专属 Skills
generate_skills() {
    echo -e "${BLUE}📊 正在分析项目结构...${NC}"
    echo ""

    # 检测项目类型
    PROJECT_TYPE="unknown"
    PROJECT_NAME="myproject"

    if [ -f "project.godot" ]; then
        PROJECT_TYPE="Godot"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  🎮 检测到: Godot 项目"
    elif [ -f "package.json" ]; then
        PROJECT_TYPE="Node.js"
        PROJECT_NAME=$(node -p "require('./package.json').name" 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()' || echo "myapp")
        echo "  🟢 检测到: Node.js 项目"
    elif [ -f "go.mod" ]; then
        PROJECT_TYPE="Go"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  🔵 检测到: Go 项目"
    elif [ -f "Cargo.toml" ]; then
        PROJECT_TYPE="Rust"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  🦀 检测到: Rust 项目"
    elif [ -f "requirements.txt" ]; then
        PROJECT_TYPE="Python"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  🐍 检测到: Python 项目"
    elif [ -f "pom.xml" ]; then
        PROJECT_TYPE="Java"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  ☕ 检测到: Java 项目"
    elif [ -f "*.csproj" ]; then
        PROJECT_TYPE=".NET"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  #️⃣ 检测到: .NET 项目"
    else
        PROJECT_TYPE="Generic"
        PROJECT_NAME=$(basename "$PROJECT_DIR" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '()')
        echo "  📦 检测到: 通用项目"
    fi

    echo "  📛 项目名称: $PROJECT_NAME"
    echo ""

    # 检查是否有 AIGO 工具（Godot项目优先使用）
    if [ "$PROJECT_TYPE" = "Godot" ] && [ -f "$SKILLS_DIR/generate_agent_skills.py" ]; then
        echo -e "${BLUE}🛠️  使用 AIGO 自动生成专属 Skills...${NC}"
        echo ""
        python3 "$SKILLS_DIR/generate_agent_skills.py" "$PROJECT_DIR" -o ".factory/droids"
        echo ""
        echo -e "${GREEN}✅ 已生成专属 Skills 文档！${NC}"
    else
        # 原有生成逻辑
        echo -e "${BLUE}🛠️  正在生成专属 Skills...${NC}"
        echo ""

        # 为 WARP 生成 skill
        cat > ".factory/droids/${PROJECT_NAME}-core.json" << EOF
{
  "name": "${PROJECT_NAME}-core",
  "description": "[${PROJECT_NAME} 专属] 核心业务逻辑开发专家",
  "version": "1.0.0",
  "scope": "project",
  "projectPath": "${PROJECT_DIR}",
  "projectName": "${PROJECT_NAME}",
  "framework": "${PROJECT_TYPE}",
  "tools": [],
  "contextPatterns": {
    "src": "src/",
    "lib": "lib/",
    "core": "core/"
  },
  "patterns": {
    "files": ["**/*.${PROJECT_TYPE:-*}"],
    "code": []
  },
  "codingConventions": {
    "naming": "follow project defaults"
  },
  "todoFocus": ["核心功能开发"]
}
EOF
        echo "  ✅ .factory/droids/${PROJECT_NAME}-core.json"

        # 为测试生成 skill
        cat > ".factory/droids/${PROJECT_NAME}-testing.json" << EOF
{
  "name": "${PROJECT_NAME}-testing",
  "description": "[${PROJECT_NAME} 专属] 测试与调试专家",
  "version": "1.0.0",
  "scope": "project",
  "projectPath": "${PROJECT_DIR}",
  "projectName": "${PROJECT_NAME}",
  "framework": "${PROJECT_TYPE}",
  "tools": [],
  "contextPatterns": {
    "tests": "tests/",
    "spec": "spec/",
    "__tests__": "__tests__/"
  },
  "patterns": {
    "files": ["**/*Test*", "**/*test*", "**/*Spec*"],
    "code": ["test\\(", "describe\\(", "it\\(", "assert\\."]
  },
  "codingConventions": {
    "naming": "follow project defaults"
  },
  "todoFocus": ["编写测试", "调试问题"]
}
EOF
        echo "  ✅ .factory/droids/${PROJECT_NAME}-testing.json"

        # 为 Bug 修复生成 skill
        cat > ".factory/droids/${PROJECT_NAME}-bug-fix.json" << EOF
{
  "name": "${PROJECT_NAME}-bug-fix",
  "description": "[${PROJECT_NAME} 专属] Bug 修复专家",
  "version": "1.0.0",
  "scope": "project",
  "projectPath": "${PROJECT_DIR}",
  "projectName": "${PROJECT_NAME}",
  "framework": "${PROJECT_TYPE}",
  "tools": [],
  "patterns": {
    "files": [],
    "code": ["TODO", "FIXME", "BUG", "HACK"]
  },
  "codingConventions": {
    "naming": "follow project defaults"
  },
  "todoFocus": ["修复 Bug", "代码审查"]
}
EOF
        echo "  ✅ .factory/droids/${PROJECT_NAME}-bug-fix.json"

        echo ""
        echo -e "${GREEN}✅ 已生成 3 个专属 Skills！${NC}"
    fi
    echo ""
}

# 显示帮助
show_help() {
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  install     安装 Skills 模板（默认）"
    echo "  generate    安装并生成专属 Skills"
    echo "  help        显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0                    # 只安装模板"
    echo "  $0 generate           # 安装并生成专属 Skills"
    echo "  $0 help               # 显示帮助"
}

# 主逻辑
case "${1:-install}" in
    install)
        install_skills
        ;;
    generate)
        install_skills
        generate_skills
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}❌ 未知命令: $1${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac

echo "========================================"
echo ""
