package com.memoryvinyl.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColors = darkColorScheme(
    primary = Color(0xFF8AD6FF),
    onPrimary = Color(0xFF0C2637),
    background = Color(0xFF1B2B2F),
    surface = Color(0xFF22343A)
)

@Composable
fun MemoryVinylTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColors,
        content = content
    )
}
