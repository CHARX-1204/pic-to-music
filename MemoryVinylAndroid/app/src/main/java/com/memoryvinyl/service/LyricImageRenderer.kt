package com.memoryvinyl.service

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import kotlin.math.max

object LyricImageRenderer {

    fun render(baseImage: Bitmap, lyrics: List<String>, footer: String): Bitmap {
        val source = baseImage.copy(Bitmap.Config.ARGB_8888, true)
        val canvas = Canvas(source)

        val width = source.width.toFloat()
        val height = source.height.toFloat()

        val drawLines = lyrics + footer

        val fontSize = max(28f, width * 0.038f)
        val lineHeight = fontSize * 1.45f
        val totalHeight = drawLines.size * lineHeight

        val startX = width * 0.08f
        val startY = max(height * 0.12f, height - totalHeight - height * 0.1f)

        val shadowPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.argb(115, 0, 0, 0)
            textSize = fontSize
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
        }
        val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.argb(242, 255, 255, 255)
            textSize = fontSize
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
        }

        drawLines.forEachIndexed { index, line ->
            val baseline = startY + index * lineHeight + fontSize
            canvas.drawText(line, startX + 2f, baseline + 2f, shadowPaint)
            canvas.drawText(line, startX, baseline, textPaint)
        }

        return source
    }
}
