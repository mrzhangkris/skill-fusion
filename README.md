# skill-fusion

> 技能融合流水线：把货架候选（CANDIDATES.md）融进已有技能，并用验证门禁证明「增强了且没弄坏」。

## 流程

1. **差距分析**：候选 vs 目标技能的差距清单
2. **范围确认**：融合范围与用户对齐
3. **融合**：组合式（原件不动，逻辑放编排层）
4. **验证门禁**：`scripts/verify.sh` 聚合 skill-lint + 目标技能回归 + 改动文件语法检查
5. **登记**：SKILLS.md 更新 + commit

## 触发场景

- 「融进去」「融合」「升级技能」「把 XX 融进」「货架取用」「验证升级」
- 不触发：从无到有写新技能（→ cangjie）；评分优化（→ darwin）；装第三方入库（公共动作）

## 安装

```bash
git clone https://github.com/mrzhangkris/skill-fusion.git ~/.dsh/skills/skill-fusion
```

## 相关技能

- 仓颉 `cangjie` 造 · 达尔文 `darwin-skill` 优 · 华佗 `huatuo` 审

## 许可

MIT © 2026 mrzhangkris
