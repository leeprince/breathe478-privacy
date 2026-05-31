# 深呼吸 (Breathe478)

一款极简的呼吸练习 App，帮你在焦虑、失眠、压力大时快速找回平静。

## 产品介绍

### 核心功能

提供三种科学呼吸法，跟随圆圈缩放视觉引导，无需查看时间：

| 模式 | 节奏 | 适用场景 |
|---|---|---|
| **4-7-8 放松呼吸** | 吸 4s → 屏 7s → 呼 8s × 4 轮 | 快速入睡、缓解焦虑（哈佛医学院推荐） |
| **方块呼吸** | 吸 4s → 屏 4s → 呼 4s → 屏 4s × 5 轮 | 专注力训练（海军特种兵在用） |
| **深呼吸** | 吸 4s → 呼 6s × 6 轮 | 最简单的随时随地放松 |

### 交互设计

- **进入即暂停**：点击模式后不会立刻开始，给用户时间调整坐姿。点击「开始」后才计时。
- **三阶段视觉色**：吸气青色、屏息暖橙、呼气紫蓝。用户瞥一眼颜色即知阶段，无需阅读文字。
- **暂停可继续**：随时可暂停，圆圈和倒计时同步停在当前位置，再点继续无缝衔接。
- **完成正向反馈**：跑完所有轮次后跳转完成页，"感受一下身体的变化"。

### 阶段提醒（可选）

设置页可独立开关两种提醒，每个阶段倒计时归零时触发：

| 提醒方式 | 默认 | 实现 |
|---|---|---|
| **震动提醒** | ✓ 开 | `HapticFeedback.mediumImpact()` 中等强度震动 |
| **响铃提醒** | ✗ 关 | `SystemSound.play(SystemSoundType.click)` 系统提示音 |

设置使用 `shared_preferences` 持久化到设备本地，下次启动自动恢复。

### 设计原则

- **简洁无干扰**：没有广告、没有内购、没有账号、没有数据上报
- **隐私友好**：不联网、不收集任何数据
- **离线可用**：所有功能本地运行
- **视觉引导**：圆圈随阶段缩放变色，吸气青、屏息橙、呼气紫

## 技术栈

- **Flutter** 3.41.9 (stable channel) - 跨平台 UI 框架
- **Dart** 3.11.5 - 编程语言
- **Material 3** - 设计系统
- **shared_preferences** ^2.2.0 - 设置持久化
- **目标平台**：Android (主)、iOS、Web、Windows、macOS、Linux

## 项目结构

```
breathe478/
├── lib/
│   ├── main.dart                     # 入口 + Material 3 主题 + AppColors
│   ├── models/
│   │   └── breathing_pattern.dart    # 呼吸模式数据类
│   ├── screens/
│   │   ├── home_screen.dart          # 首页（模式列表 + 设置入口）
│   │   ├── session_screen.dart       # 练习页（计时 + 阶段切换 + 阶段提醒）
│   │   ├── done_screen.dart          # 完成页
│   │   └── settings_screen.dart      # 设置页（震动/响铃开关）
│   ├── services/
│   │   └── app_settings.dart         # 全局设置（ChangeNotifier + 持久化）
│   └── widgets/
│       └── breathing_circle.dart     # 呼吸圆圈动画组件
├── android/                          # Android 平台配置
├── ios/                              # iOS 平台配置（暂不上架）
├── web/                              # Web 平台配置
├── test/
│   └── widget_test.dart              # Smoke test
├── pubspec.yaml                      # Flutter 项目配置
├── CHANGELOG.md                      # 版本变更记录
└── README.md
```

### 文件职责

| 文件 | 职责 |
|---|---|
| `main.dart` | 启动、主题、AppColors 常量、根 Widget |
| `models/breathing_pattern.dart` | Immutable 数据类，三种模式硬编码在静态列表 |
| `services/app_settings.dart` | 单例 ChangeNotifier，封装 SharedPreferences 读写 |
| `widgets/breathing_circle.dart` | 纯展示组件，接收 phase/duration/paused，内部管动画 |
| `screens/home_screen.dart` | 模式列表 + 设置入口 |
| `screens/session_screen.dart` | 状态机：rounds × segments，阶段倒计时归零触发反馈 |
| `screens/done_screen.dart` | 完成提示 + 回首页 |
| `screens/settings_screen.dart` | 监听 AppSettings 变化，渲染开关 |

## 快速启动

### 前置要求

1. **Flutter SDK** 3.x stable
   ```bash
   flutter --version
   ```
   如果未安装，参考项目根目录的 [docs/flutter-android-setup-guide.md](./docs/flutter-android-setup-guide.md)。

2. **运行健康检查**
   ```bash
   flutter doctor
   ```
   Android toolchain 必须为 `[✓]`。

### 安装依赖

```bash
cd breathe478
flutter pub get
```

国内网络慢可设置镜像（已在 PowerShell 用户环境变量配过的话可跳过）：
```bash
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
```

### 运行

#### 方式 1：Web 浏览器（最快验证 UI）

```bash
flutter run -d web-server
```

输出会显示访问 URL（如 `http://localhost:57237`），用 Chrome / Edge 打开即可。

> ⚠️ Web 端听不到响铃也感受不到震动（浏览器限制），需要在 Android 真机/模拟器上验证。

#### 方式 2：Chrome / Edge

```bash
flutter run -d chrome
flutter run -d edge
```

#### 方式 3：Android 真机

1. 手机开启"开发者选项 → USB 调试"
2. 华为机型还需在通知栏选「传输文件 (MTP)」模式
3. ```bash
   flutter devices       # 确认设备已识别
   flutter run           # 选择 Android 设备
   ```

#### 方式 4：Android 模拟器（推荐）

1. Android Studio → Device Manager → Create Device → Pixel 8 (API 34, Google Play Store)
2. 启动模拟器
3. ```bash
   flutter run
   ```

### 开发热重载

`flutter run` 启动后，终端会进入交互模式。**不需要重新编译**，直接按键即可：

| 按键 | 功能 | 说明 |
|---|---|---|
| `r` | Hot reload | 保留当前状态，秒级注入代码变更。改 UI 样式、文案等立即生效 |
| `R` | Hot restart | 重置所有状态从头启动。改 `main()`、添加依赖、改数据模型后需要用这个 |
| `h` | 帮助 | 列出所有可用的交互命令 |
| `d` | Detach | 终止 flutter run 进程，但 App 继续在设备上运行（不会被杀掉） |
| `c` | 清屏 | 清除终端输出 |
| `q` | 退出 | 终止 App 并退出 flutter run |

**Hot reload vs Hot restart 的区别：**

- **Hot reload (`r`)**：只重新执行 `build()` 方法，保留 `State` 对象和变量值。适合改 UI 布局、颜色、文案。速度极快（<1 秒）。
- **Hot restart (`R`)**：重新执行 `main()` 函数，所有状态归零。适合改数据模型、添加新依赖、修改 `initState` 逻辑。速度稍慢（2-5 秒）。

**什么时候 hot reload 不够用？**
- 修改了 `main()` 函数
- 添加/删除了 `pubspec.yaml` 依赖
- 修改了枚举定义或 const 常量
- 修改了 `initState()` 里的初始化逻辑
- 修改了全局变量的初始值

以上情况按 `R` 即可，不需要停掉重新 `flutter run`。

**实际开发体验：**

```
# 终端输出示例
Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

# 按 r 后
Performing hot reload...
Reloaded 1 of 1234 libraries in 387ms.

# 按 R 后
Performing hot restart...
Restarted application in 2,145ms.
```

> 💡 **提示：** VS Code / Cursor 里保存文件时会自动触发 hot reload（如果装了 Flutter 插件），不需要手动按 `r`。

## 构建发布版

### Android APK（直接安装到手机）

```bash
flutter build apk --release
```

产物：`build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle（上架 Play Store 用）

```bash
flutter build appbundle --release
```

产物：`build/app/outputs/bundle/release/app-release.aab`

> 上架 Play Store 需要先配置签名密钥。详见项目计划文档 [docs/superpowers/plans/2026-05-14-breathing-app.md](./docs/plans/2026-05-14-breathing-app.md) 的 Task 11。

### Web

```bash
flutter build web --release
```

产物：`build/web/` 目录，可直接部署到任意静态托管。

## 关键设计决策

| 决策 | 理由 |
|---|---|
| 不用状态管理库（Provider/Riverpod/Bloc） | 三页 + 一个计时器，StatefulWidget + ChangeNotifier 足够 |
| 不用路由库（go_router） | Navigator.push/pop 直接导航即可 |
| 不用代码生成（freezed/json_serializable） | 数据模型手写 3 个类够了 |
| 主题色 #4DB6AC（青绿） | 心理学上促进平静放松的色调 |
| Phase 三色区分 | 吸=青、屏=橙、呼=紫，用户无需文字也能识别阶段 |
| 进入即暂停 | 用户需要时间调整坐姿，避免被动开始造成节奏错乱 |
| 震动用 HapticFeedback、响铃用 SystemSound | 都是 Flutter 自带，免引入额外资源文件，跨平台稳定 |
| 设置持久化 | shared_preferences 是社区标准，比自己写文件简单 |

## 常见问题

### `flutter run -d chrome` 启动失败

Flutter 临时启动 Chrome 时被拦截（杀毒软件 / Chrome 版本问题）。

**解决：** 改用 `flutter run -d web-server`，手动复制 URL 到浏览器打开。

### IDE 终端找不到 flutter 命令

环境变量修改后 IDE 终端需要重启。完全关闭 IDE 重新打开，或在系统 PowerShell 里运行。

临时解决（不想重启 IDE 时）：
```powershell
$env:Path += ";D:\flutter-sdk\bin"
```

### `flutter pub get` 报 socket error

pub.dev 在国内被屏蔽。运行前设置镜像：
```powershell
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
flutter pub get
```
建议把这两个变量加到系统环境变量，一劳永逸。

### Hot reload 不生效

某些改动（如修改 `main()` 函数、添加新依赖）需要 Hot restart（按 `R`），单纯 `r` 不够。

### Windows 构建提示 "Please enable Developer Mode"

带 plugin 的 Flutter 项目在 Windows 构建需要 symlink 支持：
1. 在 PowerShell 运行 `start ms-settings:developers`
2. 打开「开发人员模式」开关
3. 重新构建

### 华为手机连不上 ADB

华为手机调试需要：
1. 通知栏选「传输文件 (MTP)」模式
2. 装华为驱动（HiSuite 装完后关闭它）
3. 第一次连接时手机弹窗要选「始终允许」

### 签名打包报 NullPointerException

`key.properties` 文件有两个常见坑：
1. PowerShell `Out-File` 写入的文件带 UTF-8 BOM，Java 无法解析
2. 路径用了双反斜杠 `E:\\path\\to\\key.jks`，需改为正斜杠 `E:/path/to/key.jks`

用以下方式写入（无 BOM + 正斜杠）：
```powershell
$content = "storePassword=xxx`nkeyPassword=xxx`nkeyAlias=xxx`nstoreFile=E:/path/to/key.jks"
[System.IO.File]::WriteAllText("android/key.properties", $content, [System.Text.UTF8Encoding]::new($false))
```

## 项目文档

- [开发环境搭建指南](./docs/flutter-android-setup-guide.md) — 从零搭建 Flutter + Android 开发环境
- [完整实现计划（含上架步骤）](./docs/plans/2026-05-14-breathing-app.md) — 14 个任务的详细执行清单
- [版本变更记录](./CHANGELOG.md)

## 健康提示

练习时请保持坐姿端正，自然呼吸。如有头晕请立即停止。本应用仅作放松辅助，不能替代医疗建议。
