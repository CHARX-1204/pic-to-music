import SwiftUI

struct RecommendView: View {
    @ObservedObject var viewModel: AppFlowViewModel
    @State private var showShareSheet = false

    var body: some View {
        ZStack(alignment: .top) {
            if let song = viewModel.currentSong {
                VStack(spacing: 12) {
                    TurntableStage(
                        image: viewModel.selectedImage,
                        insertedProgress: 1,
                        playing: true,
                        statusText: "主情绪：\(viewModel.emotionProfile?.mainEmotion ?? "安静") · 默认试听中",
                        recordTitle: song.songName,
                        recordArtist: song.artist
                    )

                    VStack(spacing: 12) {
                        songHeader(song)
                        lyricList(song)

                        HStack(spacing: 24) {
                            Button {
                                viewModel.switchSong(offset: -1)
                            } label: {
                                Image(systemName: "backward.end.fill")
                            }

                            Text("\(viewModel.currentSongIndex + 1) / \(viewModel.songs.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button {
                                viewModel.switchSong(offset: 1)
                            } label: {
                                Image(systemName: "forward.end.fill")
                            }
                        }
                        .font(.title3)
                        .buttonStyle(.plain)

                        Button("生成歌词图") { viewModel.generateResult() }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.selectedLyrics.isEmpty)
                    }
                    .padding(.horizontal, AppLayout.horizontalPadding)
                }
                .padding(.bottom, 8)
                .frame(maxHeight: .infinity, alignment: .top)
            }

            topBar
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [shareText])
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                viewModel.returnHome()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 24, weight: .medium))
            }

            Spacer()

            Button {
                showShareSheet = true
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 23, weight: .medium))
            }
        }
        .foregroundStyle(.white.opacity(0.94))
        .padding(.horizontal, 22)
        .padding(.top, 12)
        .padding(.bottom, 10)
    }

    private var shareText: String {
        guard let song = viewModel.currentSong else { return "Memory Vinyl" }
        let lyrics = viewModel.selectedLyrics.isEmpty
            ? ""
            : "\n\n" + viewModel.selectedLyrics.joined(separator: "\n")
        return "\(song.songName) · \(song.artist)\(lyrics)"
    }

    private func songHeader(_ song: Song) -> some View {
        VStack(spacing: 6) {
            Text(song.songName)
                .font(.title2.weight(.semibold))
            Text(song.artist)
                .font(.body)
                .foregroundStyle(.secondary)

            Text("轻点歌词选择")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.38))
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }

    private func lyricList(_ song: Song) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 4) {
                ForEach(song.lyricLines, id: \.self) { line in
                    lyricRow(line)
                }
            }
            .padding(.vertical, 8)
        }
        .frame(height: 190)
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
    }

    private func lyricRow(_ line: String) -> some View {
        let selected = viewModel.selectedLyrics.contains(line)
        let selectionLimitReached = viewModel.selectedLyrics.count >= 3 && !selected

        return Button {
            viewModel.toggleLyric(line)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .semibold))
                    .opacity(selected ? 1 : 0)
                    .frame(width: 20)

                Text(line)
                    .font(.system(size: 18, weight: selected ? .semibold : .regular))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .frame(maxWidth: .infinity)

                Color.clear
                    .frame(width: 20, height: 1)
            }
            .foregroundStyle(.white.opacity(selected ? 0.96 : 0.46))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                selected ? Color.white.opacity(0.07) : Color.clear,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .opacity(selectionLimitReached ? 0.42 : 1)
        }
        .buttonStyle(.plain)
        .disabled(selectionLimitReached)
    }
}

struct RecommendView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendPreviewContainer()
    }
}

private struct RecommendPreviewContainer: View {
    @StateObject private var viewModel: AppFlowViewModel

    init() {
        let viewModel = AppFlowViewModel()
        viewModel.step = .recommend
        viewModel.emotionProfile = EmotionProfile(
            category: "城市孤独",
            mainEmotion: "安静",
            tags: ["城市", "夜晚", "怀旧"]
        )
        viewModel.songs = SongLibrary.fallback
        viewModel.selectedLyrics = [SongLibrary.fallback[0].lyricLines[0]]
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.31, green: 0.41, blue: 0.47),
                    Color(red: 0.10, green: 0.20, blue: 0.20)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            switch viewModel.step {
            case .home:
                HomeView(viewModel: viewModel)
            case .reading:
                ReadingView(viewModel: viewModel)
            case .recommend:
                RecommendView(viewModel: viewModel)
            case .result:
                ResultView(viewModel: viewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}
