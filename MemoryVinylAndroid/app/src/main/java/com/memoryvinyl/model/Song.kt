package com.memoryvinyl.model

import java.util.UUID

data class Song(
    val id: String = UUID.randomUUID().toString(),
    val songName: String,
    val artist: String,
    val lyricLines: List<String>,
    val emotionTags: List<String>,
    val reason: String
)
