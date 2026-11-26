#!/bin/bash
# 在你自己的终端运行（本环境无法安装 gh CLI / 无法访问 GitHub API）
# 用法：bash push.sh [仓库URL]
# 默认仓库：https://github.com/WanfengzzZ/RoutineCat.git

set -e
REPO="${1:-https://github.com/WanfengzzZ/RoutineCat.git}"
HERE="$(cd "$(dirname "$0")" && pwd)"
cd "$HERE"

echo "→ 初始化 git（若仓库已存在则跳过）"
if [ ! -d .git ]; then
  git init
  git checkout -b main
fi

echo "→ 确认没有代码文件被纳入"
CODE=$(find . -type f -not -path './.git/*' -not -path './.tmp/*' \
  \( -name '*.js' -o -name '*.py' -o -name '*.json' -o -name '*.html' -o -name '*.css' -o -name '*.wxss' -o -name '*.wxml' \))
if [ -n "$CODE" ]; then
  echo "发现疑似代码文件，已中止："; echo "$CODE"; exit 1
fi

echo "→ 写入 .gitignore（排除临时渲染文件）"
cat > .gitignore <<'EOF'
.tmp/
node_modules/
*.log
.DS_Store
EOF

echo "→ 添加文件"
git add README.md docs assets .gitignore
git status --short

echo "→ 提交"
git commit -m "docs: 喵呜专注产品介绍与截图（仅宣传，不含源码）" || echo "无变更可提交"

echo "→ 关联远端"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REPO"
else
  git remote add origin "$REPO"
fi

echo "→ 推送（会提示输入 GitHub 用户名 + Personal Access Token）"
echo "   Token 生成：GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic) → 勾选 repo"
git push -u origin main

echo "完成：$REPO"
