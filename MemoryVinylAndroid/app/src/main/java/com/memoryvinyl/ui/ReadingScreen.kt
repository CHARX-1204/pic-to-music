package com.memoryvinyl.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.memoryvinyl.viewmodel.AppFlowViewModel

@Composable
fun ReadingScreen(viewModel: AppFlowViewModel) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        TurntableView(
            image = viewModel.selectedImage,
            insertedProgress = viewModel.insertedProgress,
            playing = true,
            statusText = viewModel.readingText
        )
        Text("请稍候，系统正在匹配音乐记忆...", color = Color.White.copy(alpha = 0.7f), fontSize = 13.sp)
    }
}
