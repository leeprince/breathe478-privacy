# 技术栈详解

> 本文档详细说明"深呼吸"App 使用的编程语言、框架和工具库的作用、选择理由及在项目中的具体应用。

**最后更新：** 2026-05-31

---

## 核心技术栈

### Flutter 3.41.9

**作用：** 跨平台 UI 框架，用于构建整个应用的用户界面和交互逻辑。

**为什么选择 Flutter：**
- **跨平台能力**：单一代码库可编译到 Android、iOS、Web、Windows、macOS、Linux 六大平台
- **原生级性能**：使用 Skia 图形引擎直接渲染，不依赖 WebView，动画流畅度接近原生
- **丰富的动画系统**：内置 `AnimationController`、`Tween`、`Curve` 等动画 API，特别适合呼吸圆圈这种持续动效
- **热重载（Hot Reload）**：代码修改后 1 秒内在设备上生效，开发效率极高
- **成熟生态**：Google 主推，社区活跃，pub.dev 上有 4 万+ 开源包
- **学习曲线友好**：对后端工程师来说，Dart 语法接近 Java/TypeScript，上手快

**在本项目中的应用：**
- 构建所有 UI 界面（首页、练习页、完成页、设置页）
- 实现呼吸圆圈的平滑缩放动画（`AnimationController` + `Tween`）
- 处理用户交互（点击、滑动、导航）
- 跨平台编译：同一份代码可运行在 Android、Web、iOS 等平台

**相关文件：**
- `lib/screens/*.dart` — 所有页面组件
- `lib/widgets/breathing_circle.dart` — 动画组件
- `pubspec.yaml` — Flutter 项目配置

---

### Dart 3.11.5

**作用：** Flutter 的编程语言，用于编写应用的所有业务逻辑和 UI 代码。

**为什么选择 Dart：**
- **类型安全**：静态类型系统 + 空安全（Null Safety），编译时捕获大量错误
- **语法简洁**：支持现代语言特性（async/await、扩展方法、模式匹配）
- **高性能**：AOT 编译为原生机器码，运行速度接近 C/C++
- **易学习**：语法接近 Java/TypeScript/Kotlin，后端工程师 1-2 天即可上手

**在本项目中的应用：**
- 定义数据模型（`BreathingPattern` 类）
- 实现状态管理（`StatefulWidget`、`ChangeNotifier`）
- 编写业务逻辑（计时器、阶段切换、设置持久化）
- 处理异步操作（`async/await` 用于加载设置）

**相关文件：**
- `lib/models/breathing_pattern.dart` — 数据模型
- `lib/services/app_settings.dart` — 设置服务
- `lib/screens/session_screen.dart` — 计时逻辑

---

### Material 3

**作用：** Google 的设计系统，提供现代化的 UI 组件和设计规范。

**为什么选择 Material 3：**
- **现代美学**：圆角、柔和阴影、动态配色，视觉更舒适
- **开箱即用**：Flutter 内置，无需额外依赖
- **深色模式支持**：自动适配系统主题
- **无障碍友好**：组件默认支持屏幕阅读器、键盘导航

**在本项目中的应用：**
- 使用 `ThemeData.from(colorScheme: ...)` 定义青绿主题
- 使用 Material 组件：`Scaffold`、`AppBar`、`Card`、`ElevatedButton`、`SwitchListTile`
- 自动适配深色模式（用户系统设置为深色时，App 自动切换）

**相关文件：**
- `lib/main.dart` — 主题配置（`AppColors`、`ThemeData`）

---

## 依赖库

### shared_preferences ^2.2.0

**作用：** 跨平台的键值对持久化存储，用于保存用户设置。

**为什么选择：**
- **社区标准**：Flutter 官方推荐的本地存储方案
- **跨平台**：Android 用 SharedPreferences，iOS 用 NSUserDefaults，Web 用 LocalStorage
- **API 简单**：`setBool(key, value)` / `getBool(key)` 即可读写
- **轻量级**：只有几十 KB，不像 SQLite 那样重

**在本项目中的应用：**
- 保存用户设置（震动开关、响铃开关）
- App 启动时自动恢复上次的设置状态

**相关文件：**
- `lib/services/app_settings.dart` — 封装 `SharedPreferences` 读写逻辑

---

## Flutter 内置 API（无需额外依赖）

### AnimationController

**作用：** 控制动画的播放、暂停、时长、曲线。

**在本项目中的应用：**
- 驱动呼吸圆圈的缩放动画
- 支持暂停/继续（保留当前进度）
- 阶段切换时平滑过渡（从当前大小开始新动画）

**相关文件：**
- `lib/widgets/breathing_circle.dart:40-80`

---

### HapticFeedback

**作用：** 触发设备震动反馈。

**在本项目中的应用：**
- 阶段倒计时归零时震动提醒（`HapticFeedback.mediumImpact()`）
- 用户可在设置页关闭

**相关文件：**
- `lib/screens/session_screen.dart:120`

---

### SystemSound

**作用：** 播放系统提示音。

**在本项目中的应用：**
- 阶段倒计时归零时响铃提醒（`SystemSound.play(SystemSoundType.click)`）
- 用户可在设置页关闭

**相关文件：**
- `lib/screens/session_screen.dart:123`

---

### Navigator

**作用：** 管理页面导航（跳转、返回）。

**在本项目中的应用：**
- 首页 → 练习页：`Navigator.push(MaterialPageRoute(...))`
- 练习完成 → 完成页 → 返回首页：`Navigator.pushReplacement(...)`
- 设置页 ← 返回：`Navigator.pop()`

**相关文件：**
- `lib/screens/home_screen.dart:69`
- `lib/screens/session_screen.dart:145`

---

## 不使用的技术（及原因）

### ❌ 状态管理库（Provider / Riverpod / Bloc）

**原因：**
- 项目只有 3 个页面 + 1 个全局设置对象
- `StatefulWidget` + `ChangeNotifier` 足够简单清晰
- 引入状态管理库会增加学习成本和代码复杂度

**何时需要：** 当应用有 10+ 页面、复杂的状态依赖关系时再考虑。

---

### ❌ 路由库（go_router / auto_route）

**原因：**
- 只有 4 个页面，线性导航流程
- `Navigator.push/pop` 直接调用即可
- 路由库适合有深层嵌套、URL 路由、Web 深链接的场景

**何时需要：** 当需要 URL 路由、深链接、复杂导航栈管理时。

---

### ❌ 代码生成（freezed / json_serializable）

**原因：**
- 数据模型只有 1 个类（`BreathingPattern`），手写 20 行代码
- 代码生成需要额外的构建步骤和依赖
- 增加项目复杂度，不值得

**何时需要：** 当有 10+ 数据模型、需要 JSON 序列化、不可变对象时。

---

### ❌ 第三方动画库（Lottie / Rive）

**原因：**
- 呼吸圆圈是简单的缩放动画，`AnimationController` + `Tween` 即可实现
- Lottie 需要设计师导出 JSON 文件，增加协作成本
- Flutter 内置动画系统性能更好、包体积更小

**何时需要：** 当需要复杂的矢量动画、设计师主导动效时。

---

### ❌ 第三方音频库（audioplayers / just_audio）

**原因：**
- 只需要简单的提示音，`SystemSound.play()` 足够
- 第三方音频库需要打包音频文件、处理跨平台兼容性
- 增加 APK 体积

**何时需要：** 当需要播放自定义音频、背景音乐、音频控制时。

---

### ❌ 网络库（dio / http）

**原因：**
- 应用完全离线运行，不需要联网
- 不引入网络库可以在 Play Console 数据安全表单上勾选"未收集任何数据"
- 简化隐私政策，降低过审风险

**何时需要：** 当需要 API 调用、数据同步、云存储时。

---

## 技术选型原则

### 1. 优先使用 Flutter 内置能力

能用 Flutter SDK 自带的就不引第三方包：
- Material 3 → 不用第三方主题包
- AnimationController → 不用 Lottie
- HapticFeedback → 不用 vibration
- SystemSound → 不用 audioplayers
- Navigator → 不用 go_router

**好处：**
- 减少包体积
- 避免跨平台兼容性问题
- 升级 Flutter 时不会 break
- Play Console 表单更简单

---

### 2. 最小化依赖

只引入真正必需的依赖：
- ✅ `shared_preferences` — 设置持久化，社区标准
- ❌ 其他所有第三方包 — 暂不需要

**好处：**
- 编译速度快
- APK 体积小（当前 ~15MB）
- 维护成本低

---

### 3. 架构适配规模

不为"以后可能有用"的功能提前设计：
- 3 个页面不需要状态管理库
- 1 个数据模型不需要代码生成
- 线性导航不需要路由库

**何时重构：**
- 页面数 > 10 → 考虑状态管理
- 数据模型 > 10 → 考虑代码生成
- 需要 URL 路由 → 考虑 go_router

---

## 开发工具

### Android Studio

**作用：** 管理 Android SDK、创建模拟器、生成应用图标。

**使用场景：**
- 安装 Android SDK 和命令行工具
- 创建 Android 模拟器（Pixel 8, API 34）
- 运行 `flutter_launcher_icons` 生成图标

---

### VS Code / Cursor

**作用：** 日常编码、调试、热重载。

**为什么不用 Android Studio 写代码：**
- 启动速度快（<5 秒 vs 30 秒）
- 内存占用低（~500MB vs 2GB）
- AI 辅助强（Cursor / GitHub Copilot）

---

### Flutter DevTools

**作用：** 性能分析、UI 检查、内存调试。

**使用场景：**
- 检查动画帧率（确保 60fps）
- 查看 Widget 树结构
- 分析内存泄漏

---

## 平台适配

### Android

**最低版本：** API 21 (Android 5.0)  
**目标版本：** API 34 (Android 14)

**权限：**
- ✅ `VIBRATE` — 震动提醒
- ❌ `INTERNET` — 不联网，不申请

**配置文件：**
- `android/app/src/main/AndroidManifest.xml` — 权限、应用名、图标
- `android/app/build.gradle` — 版本号、签名配置

---

### Web

**渲染引擎：** CanvasKit（默认）

**限制：**
- 震动和响铃在浏览器中无效（浏览器安全限制）
- 需要在 Android 真机/模拟器上验证完整功能

**部署：**
```bash
flutter build web --release
# 产物：build/web/ 目录，可部署到任意静态托管
```

---

### iOS（未上架）

**最低版本：** iOS 12.0

**状态：**
- 代码已支持 iOS 编译
- 未上架（需要 Apple 开发者账号 $99/年）
- 未来可能上架

---

## 性能指标

| 指标 | 目标 | 实际 |
|---|---|---|
| APK 体积 | < 20MB | ~15MB |
| 启动时间 | < 2s | ~1.5s |
| 动画帧率 | 60fps | 60fps |
| 内存占用 | < 100MB | ~80MB |

---

## 参考资料

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言指南](https://dart.dev/guides)
- [Material 3 设计规范](https://m3.material.io/)
- [shared_preferences 文档](https://pub.dev/packages/shared_preferences)
- [Flutter 动画教程](https://docs.flutter.dev/ui/animations)

---

## 相关文档

- [README.md](../README.md) — 项目介绍和快速启动
- [DEVELOPMENT.md](./DEVELOPMENT.md) — 开发进度和经验沉淀
- [flutter-android-setup-guide.md](./flutter-android-setup-guide.md) — 环境搭建指南
