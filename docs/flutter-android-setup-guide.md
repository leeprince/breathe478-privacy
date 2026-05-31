# Flutter + Android 开发环境搭建指南

> 本文档记录了从零开始搭建 Flutter Android 开发环境的完整过程，包括工具选择、常见问题和网络优化。
> 
> **目标：** 在 Windows 11 上搭建 Flutter 开发环境，用于开发 Android 应用并上架 Google Play。
> 
> **最后更新：** 2026-05-16

---

## 一、技术方案选择

### 1.1 跨平台框架对比

在开发 Android 应用时，我们对比了三种技术方案：

| 方案 | 优势 | 劣势 | 适用场景 |
|---|---|---|---|
| **原生 Kotlin + Jetpack Compose** | 性能最好、生态最完整、Google 官方支持 | 学习曲线陡（需学 Kotlin、Compose、Gradle、Android Framework 四件套） | 大型商业应用、性能敏感场景 |
| **Capacitor (HTML/CSS/JS)** | 零移动端学习成本、浏览器即可调试、开发最快 | WebView 包装方案、性能有天花板、扩展性受限 | 快速原型、内容展示类应用 |
| **Flutter** | 单代码库跨平台（Android/iOS/Web/桌面）、动画性能接近原生、Dart 语法对后端工程师友好、Google 主推 | 需学新语言 Dart、APK 体积较大 | 中小型商业应用、需要跨平台的项目 |

**最终选择：Flutter**

理由：
- 当前与 React Native 并列最流行的跨平台框架
- 单语言 Dart 学习成本低于原生 Android
- 动画系统原生级流畅，特别适合呼吸圆圈这种持续动效场景
- 未来可低成本扩展到 iOS

---

## 二、环境搭建步骤

### 2.1 前置条件

- Windows 11（或 Windows 10）
- 至少 10GB 可用磁盘空间
- 稳定的网络连接（建议配置国内镜像）

### 2.2 安装 Android Studio

#### 为什么需要 Android Studio？

Android Studio 在 Flutter 开发中扮演两个角色：

| 角色 | 是否必须 | 说明 |
|---|---|---|
| **作为 IDE（写代码）** | ❌ 不必须 | VS Code / Cursor / Trae 等都可以替代 |
| **作为 Android SDK 的载体** | ✅ 必须 | 提供编译工具链（SDK、Build Tools、Platform Tools） |

**结论：** 必须安装 Android Studio 以获取 Android SDK，但日常写代码可以用其他编辑器。

#### 安装步骤

1. **下载 Android Studio**
   - 官网：https://developer.android.com/studio
   - 下载 Windows 版（约 1GB）
   - 建议版本：Hedgehog (2023.1) 或更新

2. **安装配置**
   - 安装路径：默认即可（避免中文路径）
   - 首次启动会自动下载 Android SDK

3. **配置 SDK**
   - 启动 Android Studio → More Actions → SDK Manager
   - **SDK Platforms** 标签页勾选：
     - Android 14.0 (API 34) — 最新稳定版
   - **SDK Tools** 标签页勾选：
     - Android SDK Build-Tools 34
     - Android SDK Platform-Tools
     - **Android SDK Command-line Tools (latest)** ⚠️ 必装
   - 点 Apply，等下载完成（约 2GB）

4. **配置环境变量**
   
   Windows 设置 → 系统 → 关于 → 高级系统设置 → 环境变量。
   
   新建用户变量：
   - `ANDROID_HOME` = `C:\Users\你的用户名\AppData\Local\Android\Sdk`
   
   在 `Path` 里追加：
   - `%ANDROID_HOME%\platform-tools`

5. **验证安装**
   ```bash
   adb --version
   ```
   预期输出：`Android Debug Bridge version x.x.x`

### 2.3 安装 Flutter SDK

#### 下载 Flutter SDK

**官方下载（国外网络）：**
- https://docs.flutter.dev/release/archive?tab=windows
- 选择 **Stable** 通道最新版（当前 3.24.x）

**国内镜像（推荐）：**
- 清华镜像：https://mirrors.tuna.tsinghua.edu.cn/flutter/flutter_infra_release/releases/stable/windows/
- 选择最新的 `flutter_windows_x.x.x-stable.zip`

⚠️ **注意：** 如果从镜像下载，可能默认是 `master` 通道（开发版），需要手动切换到 `stable`。

**常见问题：清华镜像默认 master 通道**

从清华镜像下载的 Flutter SDK 默认在 `master` 通道（开发版）。需要手动切换：
```bash
flutter channel stable
flutter upgrade
```

`flutter upgrade` 可能报 "Upstream repository is not a standard remote" 警告，因为 git remote 指向镜像地址。不影响使用，可忽略。如需彻底修复，设置环境变量 `FLUTTER_GIT_URL=https://github.com/flutter/flutter.git` 或手动改 git remote。

#### 解压与配置

1. **解压到合适路径**
   - ✅ 推荐：`C:\flutter` 或 `D:\flutter-sdk`
   - ❌ 避免：`C:\Program Files\flutter`（路径有空格）
   - ❌ 避免：包含中文、空格、特殊字符的路径

2. **配置 PATH 环境变量**
   
   在用户变量的 `Path` 里追加：
   ```
   D:\flutter-sdk\bin
   ```
   （根据你的实际解压路径调整）

3. **配置国内镜像（强烈推荐）**
   
   新建两个用户环境变量：
   
   | 变量名 | 值 |
   |---|---|
   | `PUB_HOSTED_URL` | `https://pub.flutter-io.cn` |
   | `FLUTTER_STORAGE_BASE_URL` | `https://storage.flutter-io.cn` |
   
   这两个镜像由 Flutter 中文社区维护，大幅提升依赖下载速度。

4. **重启终端**
   
   ⚠️ 环境变量修改后必须关闭所有终端窗口重新打开才能生效。IDE（VS Code / Cursor / Android Studio）也需要完全关闭重新打开，否则 IDE 内置终端不会继承新的 PATH。
   
   **临时解决方案（不想重启 IDE 时）：**
   ```powershell
   $env:Path += ";D:\flutter-sdk\bin"
   ```

#### 验证安装

```bash
flutter --version
dart --version
```

预期输出：
```
Flutter 3.24.x • channel stable
Dart 3.x.x
```

如果显示 `channel master`，说明下载的是开发版，需要切换：
```bash
flutter channel stable
flutter upgrade
```

#### 运行健康检查

```bash
flutter doctor -v
```

首次运行会自动下载 Dart SDK 和一些工具（几分钟）。

**预期输出：**
```
[✓] Flutter (Channel stable, 3.24.x)
[✓] Windows Version
[!] Android toolchain - develop for Android devices
    ✗ cmdline-tools component is missing
    ✗ Android license status unknown
[✓] Chrome - develop for the web
[✗] Visual Studio - develop Windows apps
[✓] Connected device
[✓] Network resources
```

### 2.4 修复 Android toolchain 问题

#### 问题 1：cmdline-tools component is missing

**原因：** Android Studio 默认不安装 Command-line Tools，但 Flutter 需要它来管理 SDK。

**解决方法：**

1. 打开 Android Studio
2. File → Settings → Languages & Frameworks → Android SDK
3. 切到 **SDK Tools** 标签页
4. 勾选 **Android SDK Command-line Tools (latest)**
5. 点 Apply → OK，等下载完成

#### 问题 2：Android license status unknown

**原因：** 首次使用 Android SDK 需要接受许可证。

**解决方法：**

```bash
flutter doctor --android-licenses
```

一路输入 `y` 接受所有许可证（约 7-8 个）。

⚠️ **注意：** 必须先装好 cmdline-tools 才能运行这条命令，否则会报错：
```
Android sdkmanager not found.
```

#### 问题 3：Visual Studio not installed

**是否需要修复：** ❌ 不需要

这个警告是针对开发 Windows 桌面应用的，我们只做 Android，可以忽略。

#### 最终验证

再次运行：
```bash
flutter doctor
```

预期所有 Android 相关项都是 `[✓]`：
```
[✓] Flutter (Channel stable, 3.24.x)
[✓] Windows Version
[✓] Android toolchain - develop for Android devices (Android SDK version 34.x.x)
[✓] Chrome - develop for the web
[✗] Visual Studio (可忽略)
[✓] Connected device
[✓] Network resources
```

### 2.5 配置真机调试

1. **手机开启 USB 调试**
   - 设置 → 关于手机 → 连续点"版本号"7 次
   - 返回 → 系统 → 开发者选项 → 打开"USB 调试"

2. **连接手机到电脑**
   - USB 接电脑
   - 手机弹"是否允许 USB 调试"，勾"始终允许" → 确定

3. **验证连接**
   ```bash
   adb devices
   ```
   预期输出：
   ```
   List of devices attached
   XXXXXXXXX	device
   ```
   
   如果显示 `unauthorized`，重新拔插 USB 并在手机上重新授权。

---

## 三、IDE 选择

### 3.1 三种 IDE 对比

| 特性 | VS Code | Cursor / Trae | Android Studio |
|---|---|---|---|
| **Flutter 插件** | 官方支持，体验好 | 继承 VS Code 插件 | 官方支持，最全 |
| **AI 辅助** | GitHub Copilot | 内置 AI（强） | Gemini（弱） |
| **启动速度** | 快（秒级） | 快（秒级） | 慢（10-30 秒） |
| **内存占用** | 低（500MB-1GB） | 低（500MB-1GB） | 高（2-4GB） |
| **模拟器管理** | 命令行 | 命令行 | 图形化 Device Manager |
| **签名打包** | 命令行 | 命令行 | 图形化向导 |
| **布局检查器** | 无 | 无 | 有 Layout Inspector |
| **适合人群** | 轻量级开发 | AI 辅助开发 | 全功能开发 |

### 3.2 推荐方案

**日常写代码：** 用 AI IDE（Cursor / Trae / Kiro）
- AI 辅助写 Dart 效率最高
- 启动快、内存占用低
- 支持 Flutter 插件

**只在以下场景打开 Android Studio：**
1. 管理 SDK（装 cmdline-tools、更新 SDK）
2. 生成签名 AAB（图形化向导更直观，也可用命令行代替）
3. 调试复杂布局问题（用 Layout Inspector）

### 3.3 VS Code / Cursor 配置

1. **安装 Flutter 扩展**
   - 扩展商店搜 "Flutter"（作者 Dart Code）
   - 点 Install（会自动安装 Dart 扩展）

2. **选择设备**
   - `Ctrl+Shift+P` → "Flutter: Select Device"
   - 选择你的真机

3. **运行项目**
   - 打开 Flutter 项目
   - 按 `F5` 或点右上角运行按钮
   - 首次编译较慢（5-15 分钟），后续 hot reload 秒级

---

## 四、常见问题与解决方案

### 4.1 网络问题

#### 问题：下载 Flutter SDK / Gradle 依赖超时

**解决方案 1：配置 Flutter 国内镜像**

环境变量：
```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

**解决方案 2：配置 Gradle 国内镜像**

创建文件 `~/.gradle/init.gradle`（Windows 路径：`C:\Users\你的用户名\.gradle\init.gradle`）：

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

#### 问题：flutter doctor 报 "Upstream repository is not a standard remote"

**原因：** 从清华镜像下载的 Flutter SDK，git remote 指向镜像地址。

**影响：** 不影响使用，只是 `flutter upgrade` 会从镜像更新。

**解决方案（可选）：**
```bash
cd D:\flutter-sdk
git remote set-url origin https://github.com/flutter/flutter.git
```

#### 问题：`flutter pub get` 报 socket error / 连接超时

**原因：** pub.dev 在国内被屏蔽。

**解决方案：** 设置国内镜像环境变量（PowerShell）：
```powershell
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
flutter pub get
```

建议把这两个变量加到系统环境变量，一劳永逸。

### 4.2 编译问题

#### 问题：首次编译 Gradle 同步很慢（5-15 分钟）

**原因：** Gradle 需要下载大量依赖。

**解决方案：**
- 配置 Gradle 国内镜像（见上）
- 耐心等待，只有首次慢，后续秒级

#### 问题：Android license status unknown

**解决方案：**
```bash
flutter doctor --android-licenses
```

如果报 `sdkmanager not found`，先装 cmdline-tools（见 2.4 节）。

#### 问题：Execution failed for task ':app:checkDebugAarMetadata'

**原因：** Gradle 版本或依赖冲突。

**解决方案：**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### 问题：Windows 构建提示 "Please enable Developer Mode"

**原因：** Flutter 插件在 Windows 上需要 symlink 支持，默认关闭。

**解决方案：**
```powershell
start ms-settings:developers
```
打开「开发人员模式」开关，重新构建即可。

#### 问题：`flutter pub run` 报 deprecated 警告

`flutter pub run` 已废弃。改用：
```bash
dart run
```

### 4.3 签名与打包问题

#### 问题：keytool 命令找不到

**原因：** Android Studio 自带的 JDK 不在系统 PATH 里。

**解决方案：** 使用完整路径调用：
```powershell
D:\android-studio-panda4\jbr\bin\keytool.exe -genkey ...
```
（根据你的 Android Studio 安装路径调整）

#### 问题：keytool 中文确认提示无法输入（PowerShell 编码问题）

**现象：** keytool 在中文 locale 下显示 "是否正确?[否]"，输入 `y` 无效，陷入死循环。

**解决方案：** 运行 keytool 前设置 Java 语言为英文：
```powershell
$env:JAVA_TOOL_OPTIONS = "-Duser.language=en"
D:\android-studio-panda4\jbr\bin\keytool.exe -genkey ...
```
此时确认提示变为英文 "Is CN=... correct? [no]:"，输入 `yes` 即可。

#### 问题：key.properties 导致 NullPointerException in signReleaseBundle

**原因 1：** PowerShell `Out-File -Encoding utf8` 会写入 UTF-8 BOM，Java 无法解析带 BOM 的 properties 文件。

**原因 2：** 路径使用了双反斜杠 `E:\\path\\to\\key.jks`，Gradle/Java 需要正斜杠。

**解决方案：** 用以下方式写入 key.properties（无 BOM + 正斜杠）：
```powershell
$content = @"
storePassword=你的密码
keyPassword=你的密码
keyAlias=你的别名
storeFile=E:/personal_value/project/your-key.jks
"@
[System.IO.File]::WriteAllText(
    "E:/your/project/android/key.properties",
    $content,
    [System.Text.UTF8Encoding]::new($false)
)
```

### 4.4 设备问题

#### 问题：adb devices 显示 unauthorized

**解决方案：**
1. 拔掉 USB 重新插
2. 手机上重新点"允许 USB 调试"
3. 勾选"始终允许此计算机"

#### 问题：flutter run 找不到设备

**解决方案：**
```bash
flutter devices
```

如果列表为空：
1. 确认手机已开启 USB 调试
2. 确认 USB 线支持数据传输（不是只充电的线）
3. 尝试换个 USB 口
4. 重启 adb：`adb kill-server && adb start-server`

#### 问题：华为手机找不到开发者选项

**原因：** 华为隐藏了开发者选项入口，路径与标准 Android 不同。

**解决步骤：**
1. 设置 → 关于手机 → 连续点击「版本号」7 次
2. 返回 → 系统 → 开发者选项 → 打开「USB 调试」
3. USB 连接后，在通知栏下拉，选择「传输文件 (MTP)」模式（默认是充电模式，ADB 无法识别）

#### 问题：华为手机开启 USB 调试后 flutter devices 仍然为空

**原因：** 华为设备需要专用驱动（HiSuite）。

**解决方案：**
- 安装 HiSuite（华为手机助手），安装完后可以关闭它，驱动会留在系统里
- 或者改用 Android 模拟器（Pixel 8, API 34, Google Play Store 镜像），避免真机驱动问题

---

## 五、验证环境完整性

### 5.1 创建测试项目

```bash
cd E:/personal_value/project/chrome_play_dev
flutter create --org com.test --project-name test_app test_app
cd test_app
```

### 5.2 运行测试项目

```bash
flutter run
```

首次编译 5-15 分钟，后续秒级。

**预期结果：**
- 手机上出现 Flutter 默认的计数器 demo
- 点击 + 按钮，数字增加
- 终端显示 "Flutter run key commands"

### 5.3 测试 hot reload

1. 打开 `lib/main.dart`
2. 修改第 11 行的 `'Flutter Demo Home Page'` 为 `'测试'`
3. 保存文件
4. 终端按 `r` 或 IDE 点热重载按钮
5. 手机上标题立即变成"测试"（无需重新编译）

**如果 hot reload 生效，说明环境搭建成功。**

---

## 六、下一步

环境搭建完成后，可以开始正式开发：

1. **创建正式项目**
   ```bash
   flutter create --org com.你的包名前缀 --project-name breathe478 breathe478
   ```

2. **配置项目**
   - 修改 `pubspec.yaml` 添加依赖
   - 配置 `android/app/build.gradle` 设置包名和版本号

3. **开发流程**
   - 写代码 → 保存 → hot reload（`r`）
   - 添加依赖 → `flutter pub get`
   - 完整重启 → `R`（大写）
   - 退出 → `q`

4. **构建 release 包**
   ```bash
   flutter build appbundle --release
   ```

---

## 七、参考资料

- Flutter 官方文档：https://docs.flutter.dev
- Flutter 中文网：https://flutter.cn
- Dart 语言教程：https://dart.dev/guides
- Android 开发者文档：https://developer.android.com
- Flutter 中文社区镜像：https://flutter-io.cn

---

## 附录：环境变量清单

| 变量名 | 值 | 用途 |
|---|---|---|
| `Path` | `D:\flutter-sdk\bin` | Flutter 命令行工具 |
| `Path` | `%ANDROID_HOME%\platform-tools` | adb 等 Android 工具 |
| `ANDROID_HOME` | `C:\Users\你的用户名\AppData\Local\Android\Sdk` | Android SDK 路径 |
| `PUB_HOSTED_URL` | `https://pub.flutter-io.cn` | Dart 包镜像（国内必须） |
| `FLUTTER_STORAGE_BASE_URL` | `https://storage.flutter-io.cn` | Flutter 资源镜像（国内必须） |
| `FLUTTER_GIT_URL` | `https://github.com/flutter/flutter.git` | 可选，修复清华镜像 git remote 警告 |
| `JAVA_TOOL_OPTIONS` | `-Duser.language=en` | 临时用，解决 keytool 中文确认死循环 |

---

**文档版本：** 1.1  
**适用系统：** Windows 11 / Windows 10  
**Flutter 版本：** 3.24.x (stable)  
**最后验证：** 2026-05-17
