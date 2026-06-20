package com.memoryvinyl.ui

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.memoryvinyl.model.Song
import com.memoryvinyl.viewmodel.AppFlowViewModel

@Composable
fun RecommendScreen(viewModel: AppFlowViewModel) {
    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            TurntableView(
                image = viewModel.selectedImage,
                insertedProgress = 1f,
                playing = true,
                statusText = "主情绪：${viewModel.emotionProfile?.mainEmotion ?: "安静"} · 默认试听中"
            )

            viewModel.currentSong?.let { song ->
                SongCard(song, viewModel)
                PickedLyricsPreview(viewModel)

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    OutlinedButton(onClick = { viewModel.switchSong(-1) }) { Text("上一首") }
                    Text("${viewModel.currentSongIndex + 1} / ${viewModel.songs.size}", color = Color.White.copy(alpha = 0.7f))
                    OutlinedButton(onClick = { viewModel.switchSong(1) }) { Text("下一首") }
                }

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(10.dp)
                ) {
                    OutlinedButton(
                        onClick = { viewModel.openLyricOverlay() },
                        modifier = Modifier.weight(1f)
                    ) { Text("选择歌词") }
                    Button(
                        onClick = { viewModel.generateResult() },
                        enabled = viewModel.selectedLyrics.isNotEmpty(),
                        modifier = Modifier.weight(1f)
                    ) { Text("生成歌词图") }
                }
            }
        }

        if (viewModel.showLyricOverlay) {
            LyricOverlay(viewModel)
        }
    }
}

@Composable
private fun SongCard(song: Song, viewModel: AppFlowViewModel) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(16.dp))
            .background(Color.White.copy(alpha = 0.08f))
            .padding(14.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(song.songName, fontSize = 22.sp, fontWeight = FontWeight.SemiBold, color = Color.White)
        Text(song.artist, color = Color.White.copy(alpha = 0.7f))
        Text(
            song.reason,
            fontSize = 13.sp,
            color = Color.White.copy(alpha = 0.7f),
            textAlign = TextAlign.Center
        )
        val tags = ((viewModel.emotionProfile?.tags ?: emptyList()) + song.emotionTags).distinct().take(6)
        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            tags.forEach { tag ->
                Text(
                    tag,
                    fontSize = 12.sp,
                    color = Color(0xFFD6EFFF),
                    modifier = Modifier
                        .clip(RoundedCornerShape(50))
                        .background(Color(0x337FD1FF))
                        .padding(horizontal = 8.dp, vertical = 5.dp)
                )
            }
        }
    }
}

@Composable
private fun PickedLyricsPreview(viewModel: AppFlowViewModel) {
    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        if (viewModel.selectedLyrics.isEmpty()) {
            Text("尚未选择歌词，点击\u201c选择歌词\u201d开始", fontSize = 13.sp, color = Color.White.copy(alpha = 0.6f))
        } else {
            viewModel.selectedLyrics.forEach { line ->
                Text(
                    line,
                    color = Color.White,
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(10.dp))
                        .background(Color.White.copy(alpha = 0.12f))
                        .padding(horizontal = 10.dp, vertical = 8.dp)
                )
            }
        }
        Text("已选择 ${viewModel.selectedLyrics.size} / 3 段歌词", fontSize = 12.sp, color = Color.White.copy(alpha = 0.6f))
    }
}

@Composable
private fun LyricOverlay(viewModel: AppFlowViewModel) {
    val context = LocalContext.current
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    listOf(Color.Black.copy(alpha = 0.92f), Color.Black.copy(alpha = 0.96f))
                )
            )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 14.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                "✕",
                fontSize = 22.sp,
                color = Color.White.copy(alpha = 0.7f),
                modifier = Modifier.clickable { viewModel.closeLyricOverlay() }
            )
            Text(
                "选择歌词",
                fontSize = 22.sp,
                fontWeight = FontWeight.SemiBold,
                color = Color.White.copy(alpha = 0.95f),
                textAlign = TextAlign.Center,
                modifier = Modifier.weight(1f)
            )
            Box(modifier = Modifier.size(22.dp))
        }

        Column(
            modifier = Modifier
                .weight(1f)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 12.dp),
            verticalArrangement = Arrangement.spacedBy(4.dp)
        ) {
            viewModel.currentSong?.lyricLines?.forEach { line ->
                val selected = viewModel.selectedLyrics.contains(line)
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clip(RoundedCornerShape(12.dp))
                        .background(if (selected) Color.White.copy(alpha = 0.08f) else Color.Transparent)
                        .clickable { viewModel.toggleLyric(line) }
                        .padding(vertical = 10.dp, horizontal = 6.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        if (selected) "✓" else " ",
                        fontSize = 18.sp,
                        color = Color.White.copy(alpha = 0.86f),
                        modifier = Modifier.size(20.dp)
                    )
                    Column(modifier = Modifier.weight(1f), horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(
                            line,
                            fontSize = 20.sp,
                            fontWeight = FontWeight.SemiBold,
                            color = if (selected) Color.White.copy(alpha = 0.95f) else Color.White.copy(alpha = 0.4f)
                        )
                        Text(
                            "情绪释义：$line",
                            fontSize = 14.sp,
                            color = if (selected) Color.White.copy(alpha = 0.74f) else Color.White.copy(alpha = 0.35f)
                        )
                    }
                }
            }
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(Color.Black.copy(alpha = 0.34f))
                .padding(horizontal = 8.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            ToolButton("✎", "摘录歌词") { toast(context, "已摘录选中歌词") }
            ToolButton("⧉", "复制歌词") { copyLyrics(context, viewModel.selectedLyrics) }
            ToolButton("▣", "图片分享") { viewModel.generateResult() }
            ToolButton("▶", "视频分享") { toast(context, "视频分享为演示占位能力") }
        }
    }
}

@Composable
private fun androidx.compose.foundation.layout.RowScope.ToolButton(
    icon: String,
    title: String,
    onClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .weight(1f)
            .clickable { onClick() }
            .padding(vertical = 4.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Text(
            icon,
            fontSize = 14.sp,
            color = Color.White.copy(alpha = 0.82f),
            modifier = Modifier
                .size(22.dp)
                .clip(RoundedCornerShape(7.dp))
                .background(Color.White.copy(alpha = 0.12f)),
            textAlign = TextAlign.Center
        )
        Text(title, fontSize = 11.sp, color = Color.White.copy(alpha = 0.82f))
    }
}

private fun copyLyrics(context: Context, lyrics: List<String>) {
    if (lyrics.isEmpty()) {
        toast(context, "请先选择歌词")
        return
    }
    val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
    clipboard.setPrimaryClip(ClipData.newPlainText("lyrics", lyrics.joinToString("\n")))
    toast(context, "已复制选中歌词")
}

private fun toast(context: Context, message: String) {
    Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
}
