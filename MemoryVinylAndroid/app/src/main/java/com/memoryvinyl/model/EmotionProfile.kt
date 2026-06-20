package com.memoryvinyl.model

data class EmotionProfile(
    val category: String,
    val mainEmotion: String,
    val tags: List<String>
)
