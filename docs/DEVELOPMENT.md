# 开发进度记录

> 本文档记录"深呼吸"App 从立项到上架的完整开发历程，包含背景、决策、当前状态和后续计划。

**最后更新：** 2026-05-17

---

## 项目背景

### 起因
个人 Google Play 开发者账号（注册时支付 25 美金）因长期闲置面临关闭风险。Google 邮件通知**必须在 2026-05-20 之前创建并发布应用**，否则账号关闭。

### 目标
- 6 天内（截止 2026-05-20）开发并提交一款 App 到 Google Play 审核
- 应用要解决大众真实痛点，不是临时拼凑的 demo
- 第一次开发 Android 应用，希望能稳定通过审核

### 约束
- 开发者本职是后端工程师，无 Android / iOS 开发经验
- 时间紧（首次提交建议 5 天内完成，留 1-2 天审核缓冲）
- 个人项目，无团队支持

---

## 关键决策

### 决策 1：选什么 App
**结论：4-7-8 呼吸练习**

讨论过 100 个候选方案，最终从中挑选基于以下标准：
- ✅ 解决真实痛点（焦虑、失眠、压力大场景常见）
- ✅ 技术实现简单（无需后端、无需账号、无敏感权限）
- ✅ 过审风险低（健康类正向应用，不涉及隐私敏感数据）
- ✅ 可持续性好（每月小更新即可保活账号）

### 决策 2：用什么技术栈
**对比过三种方案：**

| 方案 | 学习成本 | 性能 | 上 iOS 难度 | 选择 |
|---|---|---|---|---|
| 原生 Kotlin + Jetpack Compose | 高 | 最佳 | 不能复用 | ❌ 否决 |
| Capacitor (HTML/CSS/JS) | 最低 | 一般（WebView） | 能 | 备选 |
| **Flutter** | 中 | 接近原生 | 能 | ✅ 最终采用 |

**选 Flutter 的原因：**
- Google 主推、社区活跃、当前与 React Native 并列最流行
- Dart 语法接近 Java/JS，对后端工程师友好
- 动画系统原生级流畅，特别适合呼吸圆圈这种持续动效
- 单代码库覆盖 Android/iOS/Web/桌面，未来扩展空间大

### 决策 3：架构如何最小化
**原则：MVP 阶段不引入"以后可能有用"的依赖。**

不用：
- ❌ 状态管理库（Provider/Riverpod/Bloc）— 三页 + 一个计时器，StatefulWidget 足够
- ❌ 路由库（go_router/auto_route）— Navigator.push/pop 直接导航
- ❌ 代码生成（freezed/json_serializable）— 数据模型手写够了
- ❌ 国际化框架 — 一期只做中文

只用：
- ✅ Flutter SDK 自带（Material 3、AnimationController、HapticFeedback、SystemSound）
- ✅ shared_preferences（设置持久化，社区标准）

---

## 开发时间线

### 2026-05-14 立项与计划
- ✅ 讨论 App 创意（最终选定呼吸练习）
- ✅ 对比技术方案，选定 Flutter
- ✅ 写完 14 任务详细实现计划（[plan](../docs/superpowers/plans/2026-05-14-breathing-app.md)）

### 2026-05-15 开始环境搭建
- ✅ 安装 Android Studio
- ✅ 下载 Flutter SDK（清华镜像）
- ✅ 配置 PATH、PUB_HOSTED_URL、FLUTTER_STORAGE_BASE_URL
- ✅ 切换到 stable 通道（master 太不稳定）
- ✅ 安装 cmdline-tools，接受 Android licenses
- ✅ 写完[环境搭建文档](../docs/flutter-android-setup-guide.md)

### 2026-05-16 编码
- ✅ Task 2: 项目骨架 + git 初始化
- ✅ Task 3: BreathingPattern 数据模型
- ✅ Task 4: Material 3 青绿主题
- ✅ Task 5: HomeScreen（模式列表）
- ✅ Task 6: BreathingCircle 动画组件
- ✅ Task 7: SessionScreen（计时 + 阶段切换）
- ✅ Task 8: DoneScreen + 导航串联
- ✅ 在 Web 端验证 UI 完整跑通
- ✅ 创建 Android 模拟器（Pixel 8, API 34, Google Play Store）
- ✅ **优化 1**：进入练习页默认暂停，需手动点「开始」
- ✅ **优化 2**：阶段倒计时归零时震动 / 响铃（可独立开关）
- ✅ **优化 3**：增加设置页（持久化用户偏好）

### 2026-05-17 ~ 2026-05-19 计划
- ⏸️ Task 9: 应用图标 + 屏幕常亮 + 横屏锁
- ⏸️ Task 10: 真机完整测试
- ⏸️ Task 11: 生成签名 release AAB
- ⏸️ Task 12: 准备 Play Store 素材（图标 / 截图 / 文案 / 隐私政策）

### 2026-05-19（提交日）计划
- ⏸️ Task 13: 填 Play Console 表单
- ⏸️ Task 14: 提交审核

---

## 当前状态总览

### 已实现的功能（核心 MVP）

| 模块 | 实现状态 |
|---|---|
| 三种呼吸法（4-7-8 / 方块 / 深呼吸） | ✅ 完成 |
| 呼吸圆圈动画 | ✅ 完成 |
| 三阶段视觉色 | ✅ 完成 |
| 计时与轮次跟踪 | ✅ 完成 |
| 暂停 / 继续 | ✅ 完成 |
| 完成页 | ✅ 完成 |
| Material 3 主题 + 深色模式 | ✅ 完成 |
| 设置页 | ✅ 完成 |
| 阶段提醒（震动/响铃） | ✅ 完成 |
| 设置持久化 | ✅ 完成 |
| 进入即暂停 | ✅ 完成 |

### 待完成（上架前必须）

| 任务 | 优先级 | 说明 |
|---|---|---|
| 应用图标 | P0 | 自定义图标，区别于 Flutter 默认 |
| 屏幕常亮 | P0 | 练习时不熄屏 |
| 横屏锁 | P0 | 锁定竖屏 |
| 真机测试 | P0 | Android 真机或模拟器完整跑一遍 |
| 签名打包 AAB | P0 | 生成 release AAB |
| Play Store 截图 | P0 | 至少 2 张手机截图 |
| 隐私政策 URL | P0 | 托管到公开网页 |
| 应用描述文案 | P0 | 简短 + 完整描述 |
| Play Console 表单 | P0 | 内容分级、目标受众、数据安全等 |

### 未来可优化（不影响上架）

- 用户练习历史记录
- 振动节拍引导（每秒一震）
- 更柔和的提示音（替代系统提示音）
- 多语言（英文）
- iOS 版本（代码已经能跑，需要 Apple 开发者账号）
- 自定义呼吸节奏

---

## 技术亮点

### 1. 圆圈动画的连续性
关键挑战：阶段切换时，圆圈应该从**当前位置**继续动画，而不是跳回起点。

解决方案：
- 用 `_baseScale` 字段记录当前 Tween 的起点
- 阶段切换时把 `_scale.value` 赋给 `_baseScale`
- 重新 setup tween，新动画从 baseScale 开始

详见 `lib/widgets/breathing_circle.dart` 中的 `didUpdateWidget`。

### 2. 设置的响应式更新
设置页和首页同时引用 `AppSettings` 时，需要响应变化重新渲染。

解决方案：
- `AppSettings extends ChangeNotifier`
- 设置页用 `AnimatedBuilder(animation: AppSettings.instance, ...)` 监听
- toggle 时调 `notifyListeners()`，UI 自动刷新

### 3. 跨平台振动 / 响铃
不引入第三方 vibration / audioplayers 包：

- 振动：Flutter 自带 `HapticFeedback.mediumImpact()`
- 响铃：Flutter 自带 `SystemSound.play(SystemSoundType.click)`

省去配资源文件、跨平台兼容性问题。

### 4. 零网络声明
为了在 Play Console 数据安全表单上勾选"未收集任何数据"：
- 不引入 dio / http 等网络包
- 不引入 firebase / 友盟 / 数据上报 SDK
- 不申请 INTERNET 权限（Android Manifest 不写）
- 隐私政策直接声明"不联网、不收集"

这是过审的关键，也是产品理念。

---

## 经验沉淀（可复用到下个项目）

### 国内网络问题
- Flutter SDK 用清华镜像下载
- pub 包用 `PUB_HOSTED_URL=https://pub.flutter-io.cn`
- Flutter 下载用 `FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn`
- Gradle 仓库用阿里云镜像（在 `~/.gradle/init.gradle` 配）

### IDE 选择
- **写代码**用 Cursor / Trae / VS Code（启动快、内存占用低、AI 辅助强）
- **管理 SDK / 创建模拟器 / 生成图标**用 Android Studio
- 不必把所有事情都在 Android Studio 里做

### 调试顺序
- **第一阶段**用 Web 端调试 UI（hot reload 秒级、不依赖模拟器）
- **第二阶段**用 Android 模拟器测交互（震动等需要 Android 平台）
- **第三阶段**用真机测最终效果（屏幕常亮、性能、横屏锁）

### flutter run 交互模式（核心开发体验）

`flutter run` 启动后终端进入交互模式，按键即可操作 App，**不需要重新编译**：

| 按键 | 功能 | 适用场景 |
|---|---|---|
| `r` | Hot reload | 改 UI/样式/文案，保留当前状态，<1 秒生效 |
| `R` | Hot restart | 改 main()/数据模型/依赖，重置状态，2-5 秒 |
| `d` | Detach | 断开调试但 App 继续运行 |
| `q` | Quit | 终止 App |

**什么时候 `r` 不够用必须 `R`：**
- 修改了 `main()` 函数
- 添加/删除了 pubspec.yaml 依赖
- 修改了枚举定义或 const 常量
- 修改了 `initState()` 里的初始化逻辑

这是 Flutter 开发效率的核心 — 改一行代码按 `r`，一秒内在设备上看到效果。传统 Android 原生开发每次改动需要重新编译 30 秒到几分钟。

### Flutter 自带 vs 第三方包
能用 Flutter 自带的就不引第三方：
- Material 3 → 不用第三方主题包
- AnimationController → 不用 lottie 等动画库
- HapticFeedback → 不用 vibration
- SystemSound → 不用 audioplayers
- Navigator → 不用 go_router

第三方包带来的问题：
- 增加包体积
- 跨平台兼容性风险
- 升级 Flutter 时可能 break
- 上架时需要额外披露给 Play Console

### Web 调试 vs Chrome 直接启动

`flutter run -d chrome` 有时被杀毒软件或 Chrome 版本拦截，导致启动失败。改用：
```bash
flutter run -d web-server
```
终端会输出访问 URL（如 `http://localhost:57237`），手动复制到浏览器打开，更稳定。

### 华为手机 USB 调试

华为手机开发者选项路径：设置 → 关于手机 → 连续点「版本号」7 次。USB 连接后必须在通知栏选「传输文件 (MTP)」模式，否则 ADB 无法识别设备。如果装了驱动仍然找不到，改用 Android 模拟器（Pixel 8, API 34, Google Play Store 镜像）更省事。

### Material 组件默认点击音效

所有 Material 交互组件（按钮、InkWell、SwitchListTile 等）默认 `enableFeedback: true`，会播放系统点击音。对于呼吸类冥想 App 这非常干扰。需要在每个交互组件上显式设置：
```dart
InkWell(enableFeedback: false, ...)
ElevatedButton(style: ButtonStyle(enableFeedback: false), ...)
SwitchListTile(enableFeedback: false, ...)
```
AppBar 自动生成的返回按钮也有音效，需要用 `leading: IconButton(enableFeedback: false, ...)` 覆盖。

### Flutter 3.41 API 变更

- `color.withOpacity(0.7)` 已废弃 → 改用 `color.withValues(alpha: 0.7)`
- `SwitchListTile` 的 `activeColor` 已废弃 → 改用 `activeThumbColor`

### 应用图标生成

无法在 CLI 脚本里用 `dart:ui` 生成 PNG（需要 Flutter engine，不能在命令行运行）。推荐流程：
1. 用 AI 图像工具或 Canva 生成 1024×1024 PNG 源图
2. 在 `pubspec.yaml` 配置 `flutter_launcher_icons` 包
3. 运行 `dart run flutter_launcher_icons` 自动生成所有密度变体（mdpi/hdpi/xhdpi/xxhdpi/xxxhdpi）

---

## 关键参考文档

- [完整实现计划](../docs/superpowers/plans/2026-05-14-breathing-app.md) — 14 任务详细执行清单
- [开发环境搭建指南](../docs/flutter-android-setup-guide.md) — 从零搭建环境
- [README.md](./README.md) — 产品和项目结构介绍
- [CHANGELOG.md](./CHANGELOG.md) — 版本变更记录
