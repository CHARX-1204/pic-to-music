import SwiftUI
import UIKit

enum EmotionAnalyzer {
    static func analyze(_ image: UIImage) -> EmotionProfile {
        guard let avg = averageColor(image) else {
            return EmotionProfile(category: "城市孤独", mainEmotion: "孤独", tags: ["城市", "低饱和", "安静"])
        }

        let red = avg.r
        let green = avg.g
        let blue = avg.b
        let luminance = (red + green + blue) / 3

        if red > blue + 0.08 {
            return EmotionProfile(category: "暖色黄昏", mainEmotion: "治愈", tags: ["暖色", "黄昏", "温柔"])
        }
        if blue > red + 0.08 && luminance < 0.46 {
            return EmotionProfile(category: "蓝色夜晚", mainEmotion: "安静", tags: ["蓝色", "夜晚", "怀旧"])
        }
        if luminance > 0.62 {
            return EmotionProfile(category: "海边日落", mainEmotion: "自由", tags: ["开阔", "风景", "浪漫"])
        }
        return EmotionProfile(category: "城市孤独", mainEmotion: "孤独", tags: ["城市", "低饱和", "安静"])
    }

    private static func averageColor(_ image: UIImage) -> (r: CGFloat, g: CGFloat, b: CGFloat)? {
        guard let cgImage = image.cgImage else { return nil }
        let width = 40
        let height = 40
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var raw = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let context = CGContext(
            data: &raw,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        context.interpolationQuality = .medium
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        let count = CGFloat(width * height)

        for i in stride(from: 0, to: raw.count, by: 4) {
            r += CGFloat(raw[i]) / 255
            g += CGFloat(raw[i + 1]) / 255
            b += CGFloat(raw[i + 2]) / 255
        }
        return (r / count, g / count, b / count)
    }
}
