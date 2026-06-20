package com.memoryvinyl

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.systemBarsPadding
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.lifecycle.viewmodel.compose.viewModel
import com.memoryvinyl.ui.HomeScreen
import com.memoryvinyl.ui.ReadingScreen
import com.memoryvinyl.ui.RecommendScreen
import com.memoryvinyl.ui.ResultScreen
import com.memoryvinyl.ui.theme.MemoryVinylTheme
import com.memoryvinyl.viewmodel.AppFlowViewModel
import com.memoryvinyl.viewmodel.FlowStep

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            MemoryVinylTheme {
                AppRoot()
            }
        }
    }
}

@Composable
private fun AppRoot() {
    val viewModel: AppFlowViewModel = viewModel()

    androidx.compose.foundation.layout.Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    listOf(Color(0xFF4F6878), Color(0xFF193230))
                )
            )
            .systemBarsPadding()
    ) {
        when (viewModel.step) {
            FlowStep.HOME -> HomeScreen(viewModel)
            FlowStep.READING -> ReadingScreen(viewModel)
            FlowStep.RECOMMEND -> RecommendScreen(viewModel)
            FlowStep.RESULT -> ResultScreen(viewModel)
        }
    }
}
