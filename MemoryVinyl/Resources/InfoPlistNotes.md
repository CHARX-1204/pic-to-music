# Info.plist 需要添加的权限说明

- `NSPhotoLibraryUsageDescription`：用于从相册选择照片生成歌词图。
- `NSPhotoLibraryAddUsageDescription`：用于将生成结果保存到相册。

可直接在 Xcode Target -> Info 中新增，或在 `Info.plist` 写入：

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>我们需要访问你的相册来选择照片</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>我们需要保存生成的歌词图到你的相册</string>
```
