import SwiftUI

struct RecommendView: View {
    @ObservedObject var viewModel: AppFlowViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                TurntableView(
                    image: viewModel.selectedImage,
                    insertedProgress: 1,
                    playing: true,
                    statusText: "主情绪：\(viewModel.emotionProfile?.mainEmotion ?? "安静") · 默认试听中"
                )

                if let song = viewModel.currentSong {
                    songCard(song)
                    pickedLyricsPreview

                    HStack(spacing: 10) {
                        Button("上一首") { viewModel.switchSong(offset: -1) }
                        Spacer()
                        Text("\(viewModel.currentSongIndex + 1) / \(viewModel.songs.count)")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("下一首") { viewModel.switchSong(offset: 1) }
                    }
                    .font(.callout)

                    HStack(spacing: 10) {
                        Button("选择歌词") { viewModel.showLyricOverlay = true }
                            .buttonStyle(.bordered)
                        Button("生成歌词图") { viewModel.generateResult() }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.selectedLyrics.isEmpty)
                    }
                    .padding(.top, 6)
                }
            }
            .padding(20)

            if viewModel.showLyricOverlay {
                lyricOverlay
            }
        }
    }

    private func songCard(_ song: Song) -> some View {
        VStack(spacing: 8) {
            Text(song.songName)
                .font(.title2.weight(.semibold))
            Text(song.artist)
                .foregroundStyle(.secondary)
            Text(song.reason)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            FlowTags(tags: (viewModel.emotionProfile?.tags ?? []) + song.emotionTags)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var pickedLyricsPreview: some View {
        VStack(alignment: .leading, spacing: 6) {
            if viewModel.selectedLyrics.isEmpty {
                Text("尚未选择歌词，点击“选择歌词”开始")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.selectedLyrics, id: \.self) { line in
                    Text(line)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
                }
            }
            Text("已选择 \(viewModel.selectedLyrics.count) / 3 段歌词")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var lyricOverlay: some View {
        VStack(spacing: 0) {
            HStack {
                Button("✕") { viewModel.showLyricOverlay = false }
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text("选择歌词")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.95))
                Spacer()
                Color.clear.frame(width: 24, height: 24)
            }
            .padding(.horizontal, 14)
            .padding(.top, 10)
            .padding(.bottom, 12)

            ScrollView {
                VStack(spacing: 4) {
                    ForEach(viewModel.currentSong?.lyricLines ?? [], id: \.self) { line in
                        let selected = viewModel.selectedLyrics.contains(line)
                        Button {
                            viewModel.toggleLyric(line)
                        } label: {
                            HStack(spacing: 8) {
                                Text(selected ? "✓" : " ")
                                    .font(.headline)
                                    .frame(width: 20)
                                VStack(spacing: 3) {
                                    Text(line)
                                        .font(.title3.weight(.semibold))
                                    Text("情绪释义：\(line)")
                                        .font(.subheadline)
                                        .foregroundStyle(selected ? .white.opacity(0.74) : .white.opacity(0.4))
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 6)
                            .background(selected ? .white.opacity(0.08) : .clear)
                            .opacity(selected ? 1 : 0.58)
                            .foregroundStyle(selected ? .white.opacity(0.95) : .white.opacity(0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal, 12)
            }

            HStack {
                toolButton("✎", "摘录歌词")
                toolButton("⧉", "复制歌词")
                toolButton("▣", "图片分享")
                toolButton("▶", "视频分享")
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(.black.opacity(0.34))
        }
        .background(
            LinearGradient(colors: [.black.opacity(0.9), .black.opacity(0.95)], startPoint: .top, endPoint: .bottom)
        )
        .ignoresSafeArea()
    }

    private func toolButton(_ icon: String, _ title: String) -> some View {
        VStack(spacing: 4) {
            Text(icon)
                .frame(width: 22, height: 22)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(.white.opacity(0.4), lineWidth: 1))
            Text(title)
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white.opacity(0.82))
    }
}

private struct FlowTags: View {
    let tags: [String]

    var body: some View {
        let valid = Array(Set(tags)).prefix(6)
        HStack {
            ForEach(Array(valid), id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(.cyan.opacity(0.2), in: Capsule())
            }
        }
    }
}
