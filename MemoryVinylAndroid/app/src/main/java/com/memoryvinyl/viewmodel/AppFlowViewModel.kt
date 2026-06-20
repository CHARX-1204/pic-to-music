package com.memoryvinyl.viewmodel

import android.app.Application
import android.graphics.Bitmap
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.memoryvinyl.data.SongLibrary
import com.memoryvinyl.model.EmotionProfile
import com.memoryvinyl.model.Song
import com.memoryvinyl.service.EmotionAnalyzer
import com.memoryvinyl.service.Haptics
import com.memoryvinyl.service.LyricImageRenderer
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

enum class FlowStep { HOME, READING, RECOMMEND, RESULT }

class AppFlowViewModel(application: Application) : AndroidViewModel(application) {

    private val haptics = Haptics(application)

    var step by mutableStateOf(FlowStep.HOME)
        private set
    var selectedImage by mutableStateOf<Bitmap?>(null)
        private set
    var insertedProgress by mutableStateOf(0f)
        private set
    var readingText by mutableStateOf("正在读取照片氛围")
        private set
    var emotionProfile by mutableStateOf<EmotionProfile?>(null)
        private set
    var songs by mutableStateOf<List<Song>>(emptyList())
        private set
    var currentSongIndex by mutableStateOf(0)
        private set
    var selectedLyrics by mutableStateOf<List<String>>(emptyList())
        private set
    var resultImage by mutableStateOf<Bitmap?>(null)
        private set
    var showLyricOverlay by mutableStateOf(false)

    private val readingTexts = listOf("正在读取照片氛围", "正在识别画面情绪", "正在匹配音乐记忆")

    val currentSong: Song?
        get() = songs.getOrNull(currentSongIndex)

    fun handlePickedImage(bitmap: Bitmap) {
        selectedImage = bitmap
        insertedProgress = 0f
        step = FlowStep.READING
        viewModelScope.launch { runInsertAndReading() }
    }

    fun toggleLyric(line: String) {
        val current = selectedLyrics.toMutableList()
        if (current.contains(line)) {
            current.remove(line)
        } else {
            if (current.size >= 3) return
            current.add(line)
        }
        selectedLyrics = current
    }

    fun switchSong(offset: Int) {
        if (songs.isEmpty()) return
        currentSongIndex = (currentSongIndex + offset + songs.size) % songs.size
        selectedLyrics = emptyList()
    }

    fun openLyricOverlay() { showLyricOverlay = true }
    fun closeLyricOverlay() { showLyricOverlay = false }

    fun generateResult() {
        val image = selectedImage ?: return
        val song = currentSong ?: return
        if (selectedLyrics.isEmpty()) return
        val footer = "${song.songName} · ${song.artist}"
        resultImage = LyricImageRenderer.render(image, selectedLyrics, footer)
        step = FlowStep.RESULT
    }

    fun regenerate() {
        step = FlowStep.RECOMMEND
    }

    fun reset() {
        step = FlowStep.HOME
        selectedImage = null
        insertedProgress = 0f
        emotionProfile = null
        songs = emptyList()
        currentSongIndex = 0
        selectedLyrics = emptyList()
        resultImage = null
    }

    private suspend fun runInsertAndReading() {
        val tickMs = 80L
        val steps = (3800L / tickMs).toInt()

        for (i in 0..steps) {
            insertedProgress = i.toFloat() / steps.coerceAtLeast(1)
            when (i) {
                1 -> haptics.light()
                steps / 2 -> haptics.soft()
                steps -> haptics.success()
            }
            val textIndex = (i * readingTexts.size / steps.coerceAtLeast(1))
                .coerceAtMost(readingTexts.size - 1)
            readingText = readingTexts[textIndex]
            delay(tickMs)
        }

        val image = selectedImage ?: return
        val profile = EmotionAnalyzer.analyze(image)
        emotionProfile = profile
        songs = SongLibrary.byCategory[profile.category] ?: SongLibrary.fallback
        currentSongIndex = 0
        selectedLyrics = emptyList()
        step = FlowStep.RECOMMEND
    }
}
