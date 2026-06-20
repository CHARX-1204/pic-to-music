package com.memoryvinyl.ui

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.provider.MediaStore
import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.FileProvider
import com.memoryvinyl.viewmodel.AppFlowViewModel
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStream

@Composable
fun ResultScreen(viewModel: AppFlowViewModel) {
    val context = LocalContext.current

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(14.dp)
    ) {
        viewModel.currentSong?.let { song ->
            Text(song.songName, fontSize = 22.sp, fontWeight = FontWeight.SemiBold)
            Text(song.artist)
        }

        Box(
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(max = 460.dp)
                .clip(RoundedCornerShape(16.dp)),
            contentAlignment = Alignment.Center
        ) {
            val image = viewModel.resultImage
            if (image != null) {
                Image(
                    bitmap = image.asImageBitmap(),
                    contentDescription = "生成结果图",
                    contentScale = ContentScale.Fit,
                    modifier = Modifier.fillMaxWidth()
                )
            } else {
                Text("暂无生成图")
            }
        }

        Button(
            onClick = {
                viewModel.resultImage?.let { saveToGallery(context, it) }
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("保存到相册")
        }

        OutlinedButton(
            onClick = {
                viewModel.resultImage?.let { shareImage(context, it) }
            },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("分享")
        }

        OutlinedButton(
            onClick = { viewModel.regenerate() },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("重新生成")
        }
    }
}

private fun saveToGallery(context: Context, bitmap: Bitmap) {
    val fileName = "memory-vinyl-${System.currentTimeMillis()}.png"
    val values = ContentValues().apply {
        put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
        put(MediaStore.Images.Media.MIME_TYPE, "image/png")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/MemoryVinyl")
        }
    }

    val resolver = context.contentResolver
    val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
    if (uri == null) {
        Toast.makeText(context, "保存失败，请重试", Toast.LENGTH_SHORT).show()
        return
    }

    var stream: OutputStream? = null
    try {
        stream = resolver.openOutputStream(uri)
        if (stream != null) {
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            Toast.makeText(context, "已保存到相册", Toast.LENGTH_SHORT).show()
        }
    } catch (e: Exception) {
        Toast.makeText(context, "保存失败：${e.message}", Toast.LENGTH_SHORT).show()
    } finally {
        stream?.close()
    }
}

private fun shareImage(context: Context, bitmap: Bitmap) {
    try {
        val cacheDir = File(context.cacheDir, "images")
        cacheDir.mkdirs()
        val file = File(cacheDir, "share-${System.currentTimeMillis()}.png")
        FileOutputStream(file).use { out ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
        }

        val uri = FileProvider.getUriForFile(
            context,
            "${context.packageName}.fileprovider",
            file
        )

        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "image/png"
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        context.startActivity(Intent.createChooser(intent, "分享歌词图"))
    } catch (e: Exception) {
        Toast.makeText(context, "分享失败：${e.message}", Toast.LENGTH_SHORT).show()
    }
}
