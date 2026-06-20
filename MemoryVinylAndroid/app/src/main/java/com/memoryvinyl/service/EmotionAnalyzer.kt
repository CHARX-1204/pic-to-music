package com.memoryvinyl.service

import android.graphics.Bitmap
import androidx.core.graphics.scale
import com.memoryvinyl.model.EmotionProfile

object EmotionAnalyzer {

    fun analyze(bitmap: Bitmap): EmotionProfile {
        val avg = averageColor(bitmap)
            ?: return EmotionProfile("城市孤独", "孤独", listOf("城市", "低饱和", "安静"))

        val (red, green, blue) = avg
        val luminance = (red + green + blue) / 3f

        return when {
            red > blue + 0.08f ->
                EmotionProfile("暖色黄昏", "治愈", listOf("暖色", "黄昏", "温柔"))
            blue > red + 0.08f && luminance < 0.46f ->
                EmotionProfile("蓝色夜晚", "安静", listOf("蓝色", "夜晚", "怀旧"))
            luminance > 0.62f ->
                EmotionProfile("海边日落", "自由", listOf("开阔", "风景", "浪漫"))
            else ->
                EmotionProfile("城市孤独", "孤独", listOf("城市", "低饱和", "安静"))
        }
    }

    private fun averageColor(bitmap: Bitmap): Triple<Float, Float, Float>? {
        val size = 40
        val scaled = try {
            bitmap.scale(size, size)
        } catch (e: Exception) {
            return null
        }

        var r = 0f
        var g = 0f
        var b = 0f
        val count = (size * size).toFloat()

        for (y in 0 until size) {
            for (x in 0 until size) {
                val pixel = scaled.getPixel(x, y)
                r += ((pixel shr 16) and 0xFF) / 255f
                g += ((pixel shr 8) and 0xFF) / 255f
                b += (pixel and 0xFF) / 255f
            }
        }
        return Triple(r / count, g / count, b / count)
    }
}
