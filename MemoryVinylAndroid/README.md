# Memory Vinyl - Android 版

参考 iOS（SwiftUI）版本制作的安卓等价 Demo，使用 Kotlin + Jetpack Compose。

## 功能闭环

与 iOS 版一致：

选择照片 → 照片缓慢进入唱片机（含分段震动反馈，AI 匹配并行进行）→ 情绪识别 → 推荐 3 首歌 → 参考图风格歌词选择层（深色蒙层 / 弱化未选 / 已选勾选 / 底部四操作栏）→ 生成带歌词图片 → 保存到相册 / 系统分享。

## 技术栈

- Kotlin
- Jetpack Compose（对应 SwiftUI）
- AndroidX Activity / Lifecycle ViewModel
- MediaStore 保存相册 + FileProvider 系统分享
- Vibrator 震动反馈

## 模块结构

```
app/src/main/java/com/memoryvinyl/
├── MainActivity.kt                      # 入口与四页路由
├── model/
│   ├── Song.kt
│   └── EmotionProfile.kt
├── data/
│   └── SongLibrary.kt                   # 本地歌曲库（按情绪分组）
├── service/
│   ├── EmotionAnalyzer.kt               # 颜色/亮度启发式情绪识别
│   ├── LyricImageRenderer.kt            # Canvas 叠加歌词生成图
│   └── Haptics.kt                       # 分段震动
├── viewmodel/
│   └── AppFlowViewModel.kt              # 状态机 + 慢速入仓 + 匹配
└── ui/
    ├── TurntableView.kt                 # 拟物唱片机组件
    ├── HomeScreen.kt
    ├── ReadingScreen.kt
    ├── RecommendScreen.kt               # 含歌词选择层
    ├── ResultScreen.kt
    └── theme/Theme.kt
```

## 运行方式（推荐：Android Studio）

1. 用 Android Studio 打开 `MemoryVinylAndroid` 目录。
2. 等待 Gradle 同步（首次会自动下载依赖与 Gradle Wrapper）。
3. 选择一个 API 24+ 的模拟器或真机。
4. 直接点击 Run 运行。

> Windows 上可以直接运行：Android 开发不依赖 macOS。
> 选图使用系统 Photo Picker，无需额外存储权限即可工作；震动需在真机体验。

## 命令行运行（可选）

若已安装 Android SDK 并配置 `ANDROID_HOME`，可在该目录执行：

```bash
gradle wrapper           # 首次生成 wrapper（或用 Android Studio 自动生成）
./gradlew assembleDebug  # 构建 APK
./gradlew installDebug   # 安装到已连接设备
```
