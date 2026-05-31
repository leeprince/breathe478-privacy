# Changelog

本项目所有重要变更都记录在此文件中。

格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增
- 设置页（齿轮图标入口在首页右上角）
- 阶段提醒：每个阶段倒计时归零时震动 / 响铃（可独立开关）
- 设置持久化（shared_preferences），重启 App 自动恢复用户偏好

### 变更
- 进入练习页默认暂停，需要点击「开始」按钮才计时（给用户调整坐姿的时间）
- 「暂停 / 继续」按钮文案首次显示为「开始」

### 修复
- 替换已废弃的 `Color.withOpacity(x)` 为 `Color.withValues(alpha: x)`
- 替换已废弃的 `SwitchListTile.activeColor` 为 `activeThumbColor`

## [1.0.0] - 2026-05-16（开发完成，待上架）

### 新增
- 三种呼吸法：4-7-8 放松呼吸、方块呼吸、深呼吸
- 呼吸圆圈动画（吸气放大、屏息保持、呼气缩小）
- 三阶段视觉色（吸=青、屏=橙、呼=紫）
- 计时主循环 + 轮次跟踪
- 中途暂停 / 继续
- 完成页正向反馈
- Material 3 平静青绿配色主题
- 支持深色模式（自动跟随系统）
