package com.memoryvinyl.ui

import android.graphics.Bitmap
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun TurntableView(
    image: Bitmap?,
    insertedProgress: Float,
    playing: Boolean,
    statusText: String?,
    modifier: Modifier = Modifier
) {
    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(500.dp),
        contentAlignment = Alignment.TopCenter
    ) {
        PhotoCard(image = image, insertedProgress = insertedProgress)

        Box(modifier = Modifier.padding(top = 130.dp)) {
            Machine(playing = playing, statusText = statusText)
        }
    }
}

@Composable
private fun PhotoCard(image: Bitmap?, insertedProgress: Float) {
    val startY = -420f
    val endY = 90f
    val currentY = startY + (endY - startY) * insertedProgress

    Box(
        modifier = Modifier
            .offset(y = currentY.dp)
            .size(width = 240.dp, height = 320.dp)
            .clip(RoundedCornerShape(12.dp))
            .background(Color.White.copy(alpha = 0.95f)),
        contentAlignment = Alignment.TopCenter
    ) {
        Box(
            modifier = Modifier
                .padding(top = 8.dp)
                .size(width = 224.dp, height = 264.dp)
                .clip(RoundedCornerShape(8.dp))
                .background(
                    Brush.verticalGradient(
                        listOf(Color(0xFF6D8594), Color(0xFF3F5564))
                    )
                ),
            contentAlignment = Alignment.Center
        ) {
            if (image != null) {
                Image(
                    bitmap = image.asImageBitmap(),
                    contentDescription = "用户照片",
                    contentScale = ContentScale.Crop,
                    modifier = Modifier.fillMaxSize()
                )
            }
        }

        Row(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.BottomCenter)
                .padding(horizontal = 12.dp, vertical = 10.dp),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text("Memory 01", color = Color.Gray, fontSize = 11.sp)
            Text("●", color = Color(0xFFFFB21A), fontSize = 11.sp)
        }
    }
}

@Composable
private fun Machine(playing: Boolean, statusText: String?) {
    val rotation = if (playing) {
        val transition = rememberInfiniteTransition(label = "vinyl")
        transition.animateFloat(
            initialValue = 0f,
            targetValue = 360f,
            animationSpec = infiniteRepeatable(
                animation = tween(3600, easing = LinearEasing),
                repeatMode = RepeatMode.Restart
            ),
            label = "vinylRotation"
        ).value
    } else 0f

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(360.dp)
            .clip(RoundedCornerShape(24.dp))
            .background(
                Brush.linearGradient(
                    listOf(Color.White, Color(0xFFE6E6E9), Color(0xFFD6D6DC))
                )
            ),
        contentAlignment = Alignment.Center
    ) {
        Text(
            "Q",
            color = Color(0xFF9CA2AC),
            fontSize = 26.sp,
            fontWeight = FontWeight.Bold,
            modifier = Modifier
                .align(Alignment.TopStart)
                .padding(start = 20.dp, top = 14.dp)
        )

        Box(contentAlignment = Alignment.Center) {
            Box(
                modifier = Modifier
                    .size(250.dp)
                    .clip(CircleShape)
                    .background(
                        Brush.linearGradient(
                            listOf(Color(0xFFF2F2F5), Color(0xFFC7CBD3))
                        )
                    )
            )
            Box(
                modifier = Modifier
                    .size(214.dp)
                    .rotate(rotation)
                    .clip(CircleShape)
                    .background(Color.Black),
                contentAlignment = Alignment.Center
            ) {
                Box(
                    modifier = Modifier
                        .size(78.dp)
                        .clip(CircleShape)
                        .background(Color.White)
                )
            }
        }

        Tonearm(
            playing = playing,
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(top = 36.dp, end = 26.dp)
        )

        if (statusText != null) {
            Text(
                statusText,
                color = Color(0xFF5D646F),
                fontSize = 13.sp,
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .padding(bottom = 16.dp)
            )
        }
    }
}

@Composable
private fun Tonearm(playing: Boolean, modifier: Modifier = Modifier) {
    val armRotation = if (playing) 28f else 38f
    Box(modifier = modifier) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(CircleShape)
                .background(Color.Gray.copy(alpha = 0.45f))
        )
        Box(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .offset(x = (-10).dp, y = 22.dp)
                .rotate(armRotation)
        ) {
            Spacer(
                modifier = Modifier
                    .width(150.dp)
                    .height(8.dp)
                    .clip(RoundedCornerShape(4.dp))
                    .background(
                        Brush.verticalGradient(
                            listOf(Color.White, Color.Gray)
                        )
                    )
            )
        }
    }
}
