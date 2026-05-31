# 4-7-8 呼吸练习 App 实现计划（Flutter 版）

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 6 天内（截止 2026-05-20）开发并上架一款 4-7-8 呼吸练习 App 到 Google Play，避免开发者账号被关闭。

**Architecture:** Flutter 单 Activity + Material 3 设计。三个页面：首页（呼吸模式列表）→ 练习页（动画圆圈+计时）→ 完成页。无网络、无权限、无后端、无数据库。

**Tech Stack:** Flutter 3.x stable, Dart 3.x, Material 3, wakelock_plus

---

## 方案讨论存档

**方案 A：原生 Kotlin + Jetpack Compose** — 作为后端工程师入门 Android 要同时学 Kotlin、Compose、Gradle、Android Framework 四件套，学习曲线最陡。产物纯粹、性能最好，但 MVP 阶段收益不抵成本。否决。

**方案 B：Capacitor (HTML/CSS/JS)** — 零移动端学习成本，浏览器即可调试，开发最快。但本质是 WebView 包装，体验有玻璃天花板，未来上 iOS 或扩功能时受限。作为备选。

**方案 C：Flutter（最终采用）** — Google 主推、当前与 React Native 并列最流行的跨平台移动框架。单语言 Dart、单代码库覆盖 Android/iOS/桌面/Web，动画系统原生级流畅特别适合呼吸圆圈场景，Dart 语法接近 Java/JS 对后端工程师友好。

---

## 关键决策

- **不用状态管理库（Provider/Riverpod/Bloc）** — 三个页面 + 一个计时器，StatefulWidget 足够，引入状态库是过度工程
- **不用路由库（go_router/auto_route）** — Navigator.push/pop 直接导航，三页不需要声明式路由
- **不用代码生成（freezed/json_serializable）** — 数据模型手写 3 个类就够
- **只引一个第三方包 `wakelock_plus`** — 练习时保持屏幕常亮，其余全用 Flutter 自带
- **包名用 `com.huangzi.breathe478`** — 你需要把 `huangzi` 换成你想要的、唯一的包名前缀

---

## 文件结构

```
breathe478/
├── pubspec.yaml                              # Flutter 项目配置 + 依赖
├── lib/
│   ├── main.dart                             # 入口 + Material 3 主题 + 根 Widget
│   ├── models/
│   │   └── breathing_pattern.dart            # 呼吸模式数据类
│   ├── screens/
│   │   ├── home_screen.dart                  # 首页（模式列表）
│   │   ├── session_screen.dart               # 练习页（核心动画+计时）
│   │   └── done_screen.dart                  # 完成页
│   └── widgets/
│       └── breathing_circle.dart             # 呼吸圆圈动画组件
├── android/
│   └── app/
│       ├── build.gradle                      # 应用级构建（改包名/版本号）
│       └── src/main/
│           ├── AndroidManifest.xml           # 清单（横屏锁等）
│           └── res/mipmap-*/ic_launcher.*    # 应用图标
├── docs/play-store-assets/                   # Play Store 上架素材
└── .gitignore
```

**职责划分：**
- `main.dart` 只做"配主题 + 启动 HomeScreen"两件事
- 每个 `*_screen.dart` 是独立 Widget，通过 Navigator 跳转，互相不知道对方存在
- `breathing_circle.dart` 是纯展示组件，接收 phase/duration 参数，内部管动画
- `breathing_pattern.dart` 是 immutable 数据类，三种模式硬编码在静态列表里

---

## 任务总览

> **进度更新（2026-05-16）：** Task 1-8 已完成，Web 端 UI 验证通过。Android 模拟器（Pixel 8, API 34）已就绪。
> 
> **额外完成（计划外优化）：** 设置页（震动/响铃开关 + 持久化）、进入即暂停、阶段提醒反馈。

| 阶段 | 任务 | 预计时长 | 状态 |
|---|---|---|---|
| 准备 | Task 1：装 Flutter SDK + Android Studio | 1.5-2小时 | ✅ 完成 |
| 准备 | Task 2：创建 Flutter 项目骨架 | 30分钟 | ✅ 完成 |
| 编码 | Task 3：定义呼吸模式数据模型 | 20分钟 | ✅ 完成 |
| 编码 | Task 4：配置 Material 3 主题配色 | 30分钟 | ✅ 完成 |
| 编码 | Task 5：写 HomeScreen（模式列表） | 1小时 | ✅ 完成 |
| 编码 | Task 6：写 BreathingCircle 动画组件 | 2小时 | ✅ 完成 |
| 编码 | Task 7：写 SessionScreen（计时+阶段切换） | 2小时 | ✅ 完成 |
| 编码 | Task 8：写 DoneScreen + 串联导航 | 1小时 | ✅ 完成 |
| 编码 | **额外：设置页 + 阶段提醒 + 进入即暂停** | 1.5小时 | ✅ 完成 |
| 编码 | Task 9：应用图标 + 屏幕常亮 + 横屏锁 | 1.5小时 | ⏸️ 待做 |
| 测试 | Task 10：真机完整测试 | 1小时 | ⏸️ 待做 |
| 上架 | Task 11：生成签名 release AAB | 1小时 | ⏸️ 待做 |
| 上架 | Task 12：准备 Play Store 素材 | 2-3小时 | ⏸️ 待做 |
| 上架 | Task 13：填 Play Console 表单 | 1-2小时 | ⏸️ 待做 |
| 上架 | Task 14：提交审核 | 30分钟 | ⏸️ 待做 |

---

### Task 1：装 Flutter SDK + Android Studio

**目的：** 准备好 Flutter 开发环境，能在真机或模拟器跑一个空 App。

**Files：**
- 无（全是装软件和配环境变量）

- [ ] **Step 1：下载 Flutter SDK**

打开 https://docs.flutter.dev/get-started/install/windows/mobile，按指引下载 Flutter SDK zip（约 1GB）。
解压到一个**不含中文和空格**的路径，比如 `C:\flutter`。

- [ ] **Step 2：配 PATH 环境变量**

Windows 设置 → 系统 → 关于 → 高级系统设置 → 环境变量。
在用户变量的 `Path` 里追加：`C:\flutter\bin`。

**关掉所有终端窗口重新打开**，验证：
```bash
flutter --version
dart --version
```
预期：Flutter 3.x.x / Dart 3.x.x。

- [ ] **Step 3：装 Android Studio**

打开 https://developer.android.com/studio，下载 Windows 版。
安装路径默认（不要中文路径）。

- [ ] **Step 4：首次启动配置 SDK**

启动 Android Studio → More Actions → SDK Manager。
SDK Platforms 标签页，勾选：
- Android 14.0 (API 34)

SDK Tools 标签页，勾选：
- Android SDK Build-Tools 34
- Android SDK Platform-Tools
- Android SDK Command-line Tools (latest)

点 Apply，等下载完成。

- [ ] **Step 5：装 Flutter 和 Dart 插件**

Android Studio → Plugins → 搜索 "Flutter" → Install（会自动装 Dart 插件）。
重启 Android Studio。

- [ ] **Step 6：接受 Android 许可证**

```bash
flutter doctor --android-licenses
```
一路输入 `y` 接受。

- [ ] **Step 7：配 ANDROID_HOME（如果 flutter doctor 报缺）**

Windows 环境变量新建：
- `ANDROID_HOME` = `C:\Users\你的用户名\AppData\Local\Android\Sdk`

Path 追加：
- `%ANDROID_HOME%\platform-tools`

- [ ] **Step 8：开启手机 USB 调试**

手机：设置 → 关于手机 → 连续点"版本号"7 次 → 返回 → 开发者选项 → 打开"USB 调试"。
USB 接电脑，手机弹"是否允许 USB 调试"，勾"始终允许" → 确定。

- [ ] **Step 9：运行 flutter doctor 确认全绿**

```bash
flutter doctor -v
```

预期输出所有项都是 `[✓]`（Chrome 那项可以忽略，我们只需要 Android）。
如果有 `[✗]`，按提示修复。最常见的问题：
- cmdline-tools 没装 → 回 SDK Manager 装
- licenses 没接受 → 跑 `flutter doctor --android-licenses`
- JAVA_HOME 没设 → 设成 `C:\Program Files\Android\Android Studio\jbr`

- [ ] **Step 10：装 Gradle 国内镜像（可选但强烈推荐）**

国内访问 Gradle 仓库经常超时。在用户目录下建 `~/.gradle/init.gradle`：

```groovy
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/public' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
        google()
        mavenCentral()
    }
}
```

---

### Task 2：创建 Flutter 项目骨架

**目的：** 用 Flutter CLI 创建项目，确认空 App 能在真机跑起来。

**Files：**
- Create: `breathe478/` 整个项目目录

- [ ] **Step 1：创建项目**

```bash
cd "E:/personal_value/project/chrome_play_dev"
flutter create --org com.huangzi --project-name breathe478 breathe478
```

> **注意：** `com.huangzi` 换成你的英文名/拼音前缀。这决定了最终包名 `com.huangzi.breathe478`。
> `--project-name` 只能用小写字母和下划线。

- [ ] **Step 2：进入项目目录，跑一次空 App**

```bash
cd breathe478
flutter run
```

如果连了真机，会自动编译并安装到手机上（首次编译 Gradle 同步很慢，5-15 分钟）。
预期：手机出现 Flutter 默认的计数器 demo App。

按 `q` 退出。

- [ ] **Step 3：检查 pubspec.yaml 关键配置**

打开 `pubspec.yaml`，确认：
```yaml
name: breathe478
description: "4-7-8 呼吸练习"
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
```

- [ ] **Step 4：检查 android/app/build.gradle 包名和 SDK 版本**

打开 `android/app/build.gradle`，确认：
```groovy
android {
    namespace = "com.huangzi.breathe478"
    compileSdk = flutter.compileSdkVersion  // 或直接写 34

    defaultConfig {
        applicationId = "com.huangzi.breathe478"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion  // 或直接写 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

如果 `minSdk` 不是 24，改成 24（覆盖 95%+ 设备）。

- [ ] **Step 5：清理默认 demo 代码**

把 `lib/main.dart` 的内容**全部替换**为：

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const Breathe478App());
}

class Breathe478App extends StatelessWidget {
  const Breathe478App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '深呼吸',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4DB6AC)),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Hello 深呼吸')),
      ),
    );
  }
}
```

- [ ] **Step 6：热重载验证**

```bash
flutter run
```

手机上应该显示 "Hello 深呼吸"。按 `r` 热重载，按 `q` 退出。

- [ ] **Step 7：初始化 git 并 commit**

```bash
git init
git add .
git commit -m "chore: initial flutter project scaffold"
```

---

### Task 3：定义呼吸模式数据模型

**目的：** 把"4-7-8 呼吸"等练习抽象成数据类，与 UI 解耦。

**Files：**
- Create: `lib/models/breathing_pattern.dart`

- [ ] **Step 1：创建 models 目录和文件**

```bash
mkdir -p lib/models
```

创建 `lib/models/breathing_pattern.dart`：

```dart
enum BreathPhase {
  inhale('吸气'),
  hold('屏息'),
  exhale('呼气');

  final String label;
  const BreathPhase(this.label);
}

class PhaseSegment {
  final BreathPhase phase;
  final int seconds;

  const PhaseSegment(this.phase, this.seconds);
}

class BreathingPattern {
  final String id;
  final String name;
  final String description;
  final List<PhaseSegment> segments;
  final int rounds;

  const BreathingPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.segments,
    required this.rounds,
  });

  int get secondsPerRound => segments.fold(0, (sum, s) => sum + s.seconds);

  static const List<BreathingPattern> all = [
    BreathingPattern(
      id: '4-7-8',
      name: '4-7-8 放松呼吸',
      description: '吸气 4 秒，屏息 7 秒，呼气 8 秒。帮助快速入睡和缓解焦虑。',
      segments: [
        PhaseSegment(BreathPhase.inhale, 4),
        PhaseSegment(BreathPhase.hold, 7),
        PhaseSegment(BreathPhase.exhale, 8),
      ],
      rounds: 4,
    ),
    BreathingPattern(
      id: 'box',
      name: '方块呼吸',
      description: '吸 4 秒、屏 4 秒、呼 4 秒、屏 4 秒。专注力训练，海军特种兵在用。',
      segments: [
        PhaseSegment(BreathPhase.inhale, 4),
        PhaseSegment(BreathPhase.hold, 4),
        PhaseSegment(BreathPhase.exhale, 4),
        PhaseSegment(BreathPhase.hold, 4),
      ],
      rounds: 5,
    ),
    BreathingPattern(
      id: 'deep',
      name: '深呼吸',
      description: '吸气 4 秒，呼气 6 秒。最简单的放松练习，随时随地都能做。',
      segments: [
        PhaseSegment(BreathPhase.inhale, 4),
        PhaseSegment(BreathPhase.exhale, 6),
      ],
      rounds: 6,
    ),
  ];
}
```

- [ ] **Step 2：编译验证**

```bash
flutter analyze
```

预期：No issues found!

- [ ] **Step 3：commit**

```bash
git add lib/models/
git commit -m "feat: add breathing pattern data model"
```

---

### Task 4：配置 Material 3 主题配色

**目的：** 把默认的紫色主题改成符合呼吸 App 调性的青绿配色，集中管理 phase 颜色常量。

**Files：**
- Modify: `lib/main.dart`

- [ ] **Step 1：替换 lib/main.dart 全部内容**

```dart
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const Breathe478App());
}

// 主题颜色常量（被多个 widget 引用，集中放这里）
class AppColors {
  static const Color calmTeal = Color(0xFF4DB6AC);
  static const Color calmTealDark = Color(0xFF00897B);
  static const Color calmTealLight = Color(0xFFB2DFDB);
  static const Color warmPeach = Color(0xFFFFAB91);
  static const Color softBg = Color(0xFFF5F7F8);
  static const Color softBgDark = Color(0xFF1A1F22);
  static const Color inkPrimary = Color(0xFF263238);
  static const Color inkSecondary = Color(0xFF607D8B);

  // 三个阶段的强调色
  static const Color inhale = Color(0xFF4DB6AC); // 青
  static const Color hold = Color(0xFFFFB74D); // 暖橙
  static const Color exhale = Color(0xFF7986CB); // 紫蓝
}

class Breathe478App extends StatelessWidget {
  const Breathe478App({super.key});

  @override
  Widget build(BuildContext context) {
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.calmTeal,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.calmTeal,
      onPrimary: Colors.white,
      primaryContainer: AppColors.calmTealLight,
      onPrimaryContainer: AppColors.calmTealDark,
      background: AppColors.softBg,
      surface: Colors.white,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.calmTeal,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.calmTealLight,
      onPrimary: AppColors.calmTealDark,
      background: AppColors.softBgDark,
    );

    return MaterialApp(
      title: '深呼吸',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: AppColors.softBg,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: AppColors.softBgDark,
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}
```

> 这一步会临时编译失败（因为 home_screen.dart 还没写）。下一个 Task 5 写完就好。

- [ ] **Step 2：commit**

```bash
git add lib/main.dart
git commit -m "feat: material 3 calm teal theme"
```

---

### Task 5：写 HomeScreen（呼吸模式列表）

**目的：** App 入口，展示三种呼吸模式卡片，点击进入练习页。

**Files：**
- Create: `lib/screens/home_screen.dart`

- [ ] **Step 1：创建 screens 目录和 home_screen.dart**

```bash
mkdir -p lib/screens
```

创建 `lib/screens/home_screen.dart`：

```dart
import 'package:flutter/material.dart';

import '../main.dart' show AppColors;
import '../models/breathing_pattern.dart';
import 'session_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '深呼吸',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.calmTealDark,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '选一种练习，找回平静',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.inkSecondary,
                    ),
              ),
              const SizedBox(height: 32),
              ...BreathingPattern.all.map(
                (pattern) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _PatternCard(
                    pattern: pattern,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SessionScreen(pattern: pattern),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '练习时请保持坐姿端正，自然呼吸。如有头晕请立即停止。',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkSecondary.withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final BreathingPattern pattern;
  final VoidCallback onTap;

  const _PatternCard({required this.pattern, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.calmTealLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pattern.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.calmTealDark,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                pattern.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.calmTealDark.withOpacity(0.85),
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '${pattern.rounds} 轮 · 每轮 ${pattern.secondsPerRound} 秒',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.calmTealDark.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2：临时给 SessionScreen 写一个空壳让编译通过**

创建 `lib/screens/session_screen.dart`，**先写一个最简版**（下一个 Task 6 后再完善）：

```dart
import 'package:flutter/material.dart';

import '../models/breathing_pattern.dart';

class SessionScreen extends StatelessWidget {
  final BreathingPattern pattern;
  const SessionScreen({super.key, required this.pattern});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pattern.name)),
      body: const Center(child: Text('Session placeholder')),
    );
  }
}
```

- [ ] **Step 3：编译验证**

```bash
flutter analyze
flutter run
```

预期：手机上显示首页，3 个青色卡片排列整齐。点任何卡片跳到一个空壳页（标题是模式名）。

- [ ] **Step 4：commit**

```bash
git add lib/screens/home_screen.dart lib/screens/session_screen.dart lib/main.dart
git commit -m "feat: add home screen with pattern cards"
```

---

### Task 6：写 BreathingCircle 动画组件

**目的：** 屏幕中心的呼吸圆圈：吸气时放大、呼气时缩小、屏息保持。这是 App 的视觉灵魂。

**Files：**
- Create: `lib/widgets/breathing_circle.dart`

- [ ] **Step 1：创建 widgets 目录和 breathing_circle.dart**

```bash
mkdir -p lib/widgets
```

创建 `lib/widgets/breathing_circle.dart`：

```dart
import 'package:flutter/material.dart';

import '../main.dart' show AppColors;
import '../models/breathing_pattern.dart';

class BreathingCircle extends StatefulWidget {
  final BreathPhase phase;
  final int phaseDurationSeconds;
  final bool paused;

  const BreathingCircle({
    super.key,
    required this.phase,
    required this.phaseDurationSeconds,
    required this.paused,
  });

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  // 缩放范围：呼气末 0.5，吸气末 1.0
  static const double _minScale = 0.5;
  static const double _maxScale = 1.0;
  double _baseScale = _minScale; // 当前阶段的起点

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.phaseDurationSeconds),
    );
    _setupAnimationForPhase(widget.phase);
    if (!widget.paused) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 暂停状态变化
    if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        _controller.stop();
      } else {
        _controller.forward();
      }
    }

    // 阶段切换：重置 controller，更新 _baseScale 为当前 _scale.value
    if (widget.phase != oldWidget.phase ||
        widget.phaseDurationSeconds != oldWidget.phaseDurationSeconds) {
      _baseScale = _scale.value;
      _controller.duration = Duration(seconds: widget.phaseDurationSeconds);
      _setupAnimationForPhase(widget.phase);
      _controller.forward(from: 0);
    }
  }

  void _setupAnimationForPhase(BreathPhase phase) {
    final double end;
    switch (phase) {
      case BreathPhase.inhale:
        end = _maxScale;
        break;
      case BreathPhase.exhale:
        end = _minScale;
        break;
      case BreathPhase.hold:
        end = _baseScale; // 保持
        break;
    }
    _scale = Tween<double>(begin: _baseScale, end: end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: phase == BreathPhase.hold ? Curves.linear : Curves.easeInOut,
      ),
    );
  }

  Color _phaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return AppColors.inhale;
      case BreathPhase.exhale:
        return AppColors.exhale;
      case BreathPhase.hold:
        return AppColors.hold;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _phaseColor(widget.phase);
    return SizedBox(
      width: 280,
      height: 280,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, _) {
          final s = _scale.value;
          return Center(
            child: Container(
              width: 280 * s,
              height: 280 * s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.9),
                    color.withOpacity(0.6),
                    color.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 2：编译验证**

```bash
flutter analyze
```

预期：No issues found（widget 还没被引用，只是确保语法对）。

- [ ] **Step 3：commit**

```bash
git add lib/widgets/breathing_circle.dart
git commit -m "feat: animated breathing circle widget"
```

---

### Task 7：写 SessionScreen（计时+阶段切换）

**目的：** 核心练习页面：显示圆圈动画 + 阶段文字 + 倒计时 + 轮次，计时结束跳完成页。

**Files：**
- Modify: `lib/screens/session_screen.dart`（替换 Task 5 的空壳）

- [ ] **Step 1：替换 session_screen.dart 全部内容**

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart' show AppColors;
import '../models/breathing_pattern.dart';
import '../widgets/breathing_circle.dart';
import 'done_screen.dart';

class SessionScreen extends StatefulWidget {
  final BreathingPattern pattern;
  const SessionScreen({super.key, required this.pattern});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late int _round;
  late int _segmentIndex;
  late int _secondsLeft;
  bool _paused = false;
  Timer? _timer;

  PhaseSegment get _currentSegment => widget.pattern.segments[_segmentIndex];

  @override
  void initState() {
    super.initState();
    _round = 1;
    _segmentIndex = 0;
    _secondsLeft = widget.pattern.segments[0].seconds;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _advance();
        }
      });
    });
  }

  void _advance() {
    final nextSeg = _segmentIndex + 1;
    if (nextSeg >= widget.pattern.segments.length) {
      if (_round >= widget.pattern.rounds) {
        _finish();
        return;
      }
      _round++;
      _segmentIndex = 0;
    } else {
      _segmentIndex = nextSeg;
    }
    _secondsLeft = widget.pattern.segments[_segmentIndex].seconds;
  }

  void _finish() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DoneScreen()),
    );
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _back() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  Color _phaseColor(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return AppColors.inhale;
      case BreathPhase.exhale:
        return AppColors.exhale;
      case BreathPhase.hold:
        return AppColors.hold;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segment = _currentSegment;
    final color = _phaseColor(segment.phase);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 顶部：返回 + 轮次
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _back,
                    child: const Text('返回'),
                  ),
                  Text(
                    '第 $_round / ${widget.pattern.rounds} 轮',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.inkSecondary,
                        ),
                  ),
                ],
              ),
              // 中间：圆圈 + 文字
              const Spacer(),
              BreathingCircle(
                phase: segment.phase,
                phaseDurationSeconds: segment.seconds,
                paused: _paused,
              ),
              const SizedBox(height: 48),
              Text(
                segment.phase.label,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: color,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_secondsLeft',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w100,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const Spacer(),
              // 底部：暂停/继续
              FilledButton(
                onPressed: _togglePause,
                child: Text(_paused ? '继续' : '暂停'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2：编译验证**

```bash
flutter analyze
```

会报 `done_screen.dart` 不存在 — 正常，下一步写。

- [ ] **Step 3：commit**

```bash
git add lib/screens/session_screen.dart
git commit -m "feat: session screen with timer and phase switching"
```

---

### Task 8：写 DoneScreen + 串联导航

**目的：** 完成练习后展示鼓励文字 + 回到首页按钮。

**Files：**
- Create: `lib/screens/done_screen.dart`

- [ ] **Step 1：创建 done_screen.dart**

```dart
import 'package:flutter/material.dart';

import '../main.dart' show AppColors;

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                '✓',
                style: TextStyle(
                  fontSize: 96,
                  color: AppColors.calmTeal,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '完成了',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                '感受一下身体的变化\n下次累的时候，记得回来',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.inkSecondary,
                      height: 1.6,
                    ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('回到首页'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2：编译并跑完整流程**

```bash
flutter analyze
flutter run
```

操作：首页 → 点 4-7-8 → 看到圆圈动画 + 倒计时 → 4 轮结束跳完成页 → 点"回到首页"回到首页。

- [ ] **Step 3：commit**

```bash
git add lib/screens/done_screen.dart
git commit -m "feat: done screen and full navigation flow"
```

---

### Task 9：应用图标 + 屏幕常亮 + 横屏锁

**目的：** 让 App 看起来不像 demo，并修练习时屏幕熄灭的问题。

**Files：**
- Modify: `pubspec.yaml`
- Modify: `android/app/src/main/AndroidManifest.xml`
- Modify: `lib/screens/session_screen.dart`
- Replace: `android/app/src/main/res/mipmap-*/ic_launcher.*`

- [ ] **Step 1：添加 wakelock_plus 依赖**

```bash
flutter pub add wakelock_plus
```

这会在 `pubspec.yaml` 的 dependencies 里加一行 `wakelock_plus: ^x.x.x`。

- [ ] **Step 2：在 SessionScreen 里启用屏幕常亮**

打开 `lib/screens/session_screen.dart`，顶部加 import：
```dart
import 'package:wakelock_plus/wakelock_plus.dart';
```

在 `initState()` 里加：
```dart
WakelockPlus.enable();
```

在 `dispose()` 里加（在 `_timer?.cancel()` 后面）：
```dart
WakelockPlus.disable();
```

在 `_finish()` 里加（在 Navigator 之前）：
```dart
WakelockPlus.disable();
```

在 `_back()` 里加（在 Navigator 之前）：
```dart
WakelockPlus.disable();
```

- [ ] **Step 3：锁定竖屏**

打开 `lib/main.dart`，在 `main()` 函数里改成：

```dart
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const Breathe478App());
}
```

- [ ] **Step 4：用 Android Studio 的 Image Asset Studio 生成图标**

用 Android Studio 打开 `breathe478/android` 目录。
右键 `android/app/src/main/res` → New → Image Asset。
- Icon Type: Launcher Icons (Adaptive and Legacy)
- Name: ic_launcher
- Foreground: Clip Art → 找 "air" / "spa" / "self_improvement" → 调色 #4DB6AC
- Background: Color → #F5F7F8
- Next → Finish

或者让 AI 生成 1024×1024 PNG，Foreground 选 Image 导入。

- [ ] **Step 5：改 App 显示名**

打开 `android/app/src/main/AndroidManifest.xml`，找到 `android:label`，改成：
```xml
android:label="深呼吸"
```

- [ ] **Step 6：编译验证**

```bash
flutter run
```

确认：
- 桌面图标是新的
- App 名是"深呼吸"
- 练习时屏幕不熄灭
- 横屏不会转

- [ ] **Step 7：commit**

```bash
git add -A
git commit -m "feat: app icon, wakelock, portrait lock"
```

---

### Task 10：真机完整测试

**目的：** 上架前最后过一遍。

**Files：**
- 无新增

- [ ] **Step 1：在真机过一遍这个清单**

- [ ] 桌面图标是新的青色图标
- [ ] App 名是"深呼吸"
- [ ] 首页 3 个模式卡片正常显示
- [ ] 点击 4-7-8 → 圆圈动画正确（吸气放大、屏息保持、呼气缩小）
- [ ] 倒计时数字与阶段同步
- [ ] 4 轮结束跳完成页
- [ ] 方块呼吸 5 轮跑完跳完成页
- [ ] 深呼吸 6 轮跑完跳完成页
- [ ] 暂停/继续工作正常
- [ ] 返回按钮回到首页
- [ ] 完成页"回到首页"按钮可用
- [ ] 横屏锁定（旋转手机不变）
- [ ] 练习时屏幕不熄灭
- [ ] App 切到后台再回来不崩溃
- [ ] 系统返回键：首页退出 App，练习页回首页

- [ ] **Step 2：在不同尺寸设备测试**

如果有两部手机最好，没有就用模拟器创建一个大屏和小屏分别测。

- [ ] **Step 3：如有 bug 修复并 commit**

```bash
git add -A
git commit -m "fix: <具体修复内容>"
```

---

### Task 11：生成签名 release AAB

**目的：** 上架 Play Store 必须用 AAB 格式且必须签名。

**Files：**
- Create: 你本地某安全位置的 `breathe478-release-key.jks`
- Create: `android/key.properties`

- [ ] **Step 1：生成签名 keystore**

```bash
keytool -genkey -v -keystore E:/personal_value/keystores/breathe478-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias breathe478
```

按提示输入密码和证书信息。**密码记到密码管理器，丢了 App 永远不能更新。**

- [ ] **Step 2：创建 android/key.properties**

在 `android/` 目录下创建 `key.properties`（**不要提交到 git**）：

```properties
storePassword=你的密码
keyPassword=你的密码
keyAlias=breathe478
storeFile=E:/personal_value/keystores/breathe478-release-key.jks
```

- [ ] **Step 3：修改 android/app/build.gradle 引用 key.properties**

在 `android/app/build.gradle` 文件顶部（`plugins {` 之前）加：

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

在 `android { ... }` 块内，`buildTypes` 之前加：

```groovy
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

把 `buildTypes { release { ... } }` 里的 `signingConfig` 改成：
```groovy
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

- [ ] **Step 4：构建 release AAB**

```bash
flutter build appbundle --release
```

构建完成后，AAB 在 `build/app/outputs/bundle/release/app-release.aab`。

- [ ] **Step 5：本地验证 release 包**

```bash
flutter build apk --release
flutter install --release
```

打开手机上的"深呼吸"，跑一遍主流程确认 release 包没问题。

- [ ] **Step 6：备份 keystore**

把 jks 文件复制到至少两个安全位置（密码管理器附件 + 加密云盘）。

- [ ] **Step 7：确认 .gitignore 排除了敏感文件**

确认 `.gitignore` 包含：
```
*.jks
*.keystore
key.properties
```

- [ ] **Step 8：commit**

```bash
git add android/app/build.gradle .gitignore
git commit -m "build: release signing config"
```

---

### Task 12：准备 Play Store 上架素材

**目的：** Google Play 商店页要求：图标、截图、特色图片、描述文本、隐私政策。

**Files：**
- Create: `docs/play-store-assets/` 目录及内部素材

- [ ] **Step 1：准备应用图标 512×512 PNG**

让 AI 生成 1024×1024 PNG（青色调、圆形、极简扁平风格），缩放到 512×512。

- [ ] **Step 2：准备特色图片 1024×500 PNG**

横向 banner，写上 "深呼吸 · 4-7-8 放松练习" + 圆圈视觉。Canva 或 Figma 做。

- [ ] **Step 3：准备至少 2 张手机截图**

在真机跑 release 包，截图首页 + 练习页（吸气状态）+ 完成页。分辨率至少 1080×1920。

- [ ] **Step 4：写应用描述**

简短描述（80 字内）：
```
4-7-8 呼吸练习。简单、安静、随时随地放松身心。
```

完整描述：
```
深呼吸是一款极简的呼吸练习 App，帮你在焦虑、失眠、压力大时快速找回平静。

【三种科学呼吸法】
· 4-7-8 放松呼吸：吸 4 秒、屏 7 秒、呼 8 秒。哈佛医学院推荐的快速入睡技巧。
· 方块呼吸：吸 4-屏 4-呼 4-屏 4。海军特种兵在用的专注力训练。
· 深呼吸：吸 4 秒、呼 6 秒。最简单的放松方式。

【特点】
· 简洁无干扰：没有广告、没有内购、没有账号
· 视觉引导：跟着圆圈缩放呼吸，不用看时间
· 隐私友好：不联网、不收集任何数据
· 离线可用：随时随地都能练习

【使用建议】
· 选择安静、舒适的坐姿
· 一组只需 1-3 分钟
· 工作间隙、睡前、紧张时来一组

如有头晕请立即停止。本应用仅作放松辅助，不能替代医疗建议。
```

- [ ] **Step 5：写隐私政策并托管成公开 URL**

保存为 `docs/play-store-assets/privacy-policy.md`：

```markdown
# 深呼吸 App 隐私政策

最后更新：2026-05-15

深呼吸（包名 com.huangzi.breathe478）是一款单机离线呼吸练习应用。

## 我们收集的信息
本应用**不收集、不存储、不上传**任何用户数据，包括但不限于：
- 个人身份信息
- 设备信息
- 使用数据
- 位置信息

## 网络访问
本应用不需要网络权限，不会发起任何网络请求。

## 第三方服务
本应用不集成任何第三方 SDK 或分析服务。

## 联系方式
如有任何问题，请发邮件至：你的真实邮箱
```

托管到公开 URL（GitHub Pages / Notion 公开页 / 任何静态托管）。**记下 URL。**

- [ ] **Step 6：commit**

```bash
mkdir -p docs/play-store-assets
git add docs/play-store-assets/
git commit -m "docs: play store listing assets"
```

---

### Task 13：在 Play Console 创建并配置应用

**目的：** 在 https://play.google.com/console 创建应用条目并填完所有审核要求的表单。

**Files：**
- 无（全在网页操作）

- [ ] **Step 1：登录 Play Console，点 "创建应用"**

填：
- 应用名称：深呼吸
- 默认语言：简体中文
- 应用或游戏：应用
- 免费或付费：免费
- 勾选声明

- [ ] **Step 2：左侧 政策 → 应用内容，逐项填**

- **隐私权政策**：填 Task 12 托管的 URL
- **广告**：否
- **应用访问权限**：所有功能均可在不受限的情况下使用
- **内容分级**：填问卷全选"否"，类别选"实用工具/健康生活"
- **目标受众**：13 岁以上
- **新闻应用**：否
- **数据安全**：选 "未收集任何数据"
- **政府应用**：否
- **金融功能**：否
- **健康功能**：否（放松辅助不是医疗）

- [ ] **Step 3：主要商品详情**

填简短描述、完整描述、上传图标/特色图片/截图、选类别"健康健身"、填联系邮箱。

- [ ] **Step 4：内部测试（强烈推荐先走）**

左侧 测试 → 内部测试 → 创建版本 → 上传 AAB → 添加测试者邮箱（你自己）→ 发布。
等几小时审核通过，用测试链接装一遍确认。

- [ ] **Step 5：正式版 → 创建版本**

上传 AAB，版本说明：
```
首个版本。包含 4-7-8 呼吸、方块呼吸、深呼吸三种练习。
```

检查仪表板"准备发布前"清单全绿。

---

### Task 14：提交审核 + 监控状态

**目的：** 正式提交并跟进 Google 审核。

**Files：**
- 无

- [ ] **Step 1：在正式版页面点 "发送审核"**

提交后状态变成"审核中"。新开发者首次提交通常 1-7 天。

- [ ] **Step 2：关注邮件**

如被拒，邮件会说明原因。最常见：隐私政策不可访问、数据安全声明与实际不符、截图模糊。

- [ ] **Step 3：审核通过后确认"已发布"状态**

商店页面变成"已发布" = 开发者账号闲置警告解除。

- [ ] **Step 4：在 Play Console 政策状态页面确认账号风险解除**

如果 5 月 20 日前还没审完但已提交且在审核中，通常 Google 会认可你"在维护账号"。**最稳妥的做法是早一天提交。**

- [ ] **Step 5：commit 最终状态**

```bash
git add -A
git commit -m "chore: app submitted to Play Store review"
```

---

## 风险与应对

| 风险 | 应对 |
|---|---|
| 审核被拒 | 多数可补救重提。严格按 Task 12/13 填几乎不会拒。被拒把邮件发我一起看 |
| 5 月 20 日前没审完 | 提交 + 在审核中通常被视为活跃。不要拖到 19 日才提交 |
| keystore 丢失 | 至少备份两份到不同位置（密码管理器 + 加密云盘） |
| 包名冲突 | 先在 Play Console 试一下包名可用性再正式开发 |
| Flutter 首次编译慢 | 正常，首次 Gradle 同步 5-15 分钟。后续 hot reload 秒级 |

---

## 后续可优化（不影响本次上架）

- 用 SharedPreferences 记录练习历史
- 加 Material You 动态取色（Android 12+）
- 加 HapticFeedback 振动节拍引导
- 加多语言（Dart intl 包）
- 上架成功后，**每月发布一个小更新**（修文案/调动画即可），确保账号永远活跃
