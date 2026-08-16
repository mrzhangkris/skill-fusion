#!/bin/bash
# skill-fusion 验证门禁脚本（确定性聚合）：skill-lint + 目标技能回归 + 改动文件语法检查。
# 用法：bash verify.sh <skill-name|skill-dir> [改动文件...]
set -u
SKILL_NAME="${1:?用法: verify.sh <skill-name|skill-dir> [改动文件...]}"
shift
# 技能根解析：接受绝对路径，或按全局/各工作区 .dsh/skills 逐层探测（兼容工作区技能）
if [ -d "$SKILL_NAME" ]; then
  SKILL_DIR="$SKILL_NAME"
  SKILL_NAME="$(basename "$SKILL_NAME")"
else
  for root in "$HOME/.dsh/skills" "$HOME/Documents"/*/.dsh/skills; do
    [ -d "$root/$SKILL_NAME" ] && SKILL_DIR="$root/$SKILL_NAME" && break
  done
fi
[ -n "${SKILL_DIR:-}" ] && [ -d "$SKILL_DIR" ] || { echo "✗ 技能目录不存在: $SKILL_NAME（请传绝对路径）"; exit 2; }
fail=0

step() { printf '\n== %s ==\n' "$1"; }

step "1/3 skill-lint"
bash "$HOME/.dsh/skills/scripts/skill-lint.sh" "$SKILL_DIR"
rc=$?
if [ $rc -eq 1 ]; then fail=1; elif [ $rc -eq 2 ]; then echo "（仅 warning——按 AGENTS.md 规则 6 可登记 ignore，不判失败）"; elif [ $rc -ne 0 ]; then fail=1; fi

step "2/3 目标技能回归"
if [ -f "$SKILL_DIR/tests/run_regression.sh" ]; then
  bash "$SKILL_DIR/tests/run_regression.sh" || fail=1
else
  echo "✗ 无 tests/run_regression.sh——融合后必须固化测试并接入一键回归（流程第 6.4 条）"
  fail=1
fi

step "3/3 改动文件语法检查"
checked=0
for f in "$@"; do
  case "$f" in
    *.js) node --check "$f" || fail=1; checked=1 ;;
    *.py) python3 -m py_compile "$f" || fail=1; checked=1 ;;
    *.sh) bash -n "$f" || fail=1; checked=1 ;;
  esac
done
if [ $checked -eq 0 ]; then
  [ $# -gt 0 ] && echo "（传入的改动文件均非 .js/.py/.sh，未做语法检查）" || echo "（未传改动文件，跳过语法检查）"
fi

[ $fail -eq 0 ] && echo "✓ 验证门禁通过（lint+回归+语法——正例/负例/固化三项另按 SKILL.md 第 6 条执行，本脚本不代验）" || echo "✗ 验证门禁失败"
exit $fail
