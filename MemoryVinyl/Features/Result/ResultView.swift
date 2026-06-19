import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: AppFlowViewModel
    @State private var showShareSheet = false
    @State private var showLargeImage = false
    @State private var hasPrinted = false
    @State private var outputProgress: CGFloat = 1
    @State private var largeImageScale: CGFloat = 1
    @State private var settledImageScale: CGFloat = 1
    @Namespace private var imageTransition

    var body: some View {
        VStack(spacing: 10) {
            if let song = viewModel.currentSong {
                TurntableStage(
                    image: viewModel.resultImage,
                    insertedProgress: outputProgress,
                    playing: true,
                    statusText: hasPrinted ? "点击照片查看大图" : "歌词照片正在输出",
                    recordTitle: song.songName,
                    recordArtist: song.artist,
                    onPhotoTap: {
                        guard hasPrinted else { return }
                        withAnimation(.spring(response: 0.48, dampingFraction: 0.86)) {
                            showLargeImage = true
                        }
                    },
                    photoNamespace: imageTransition,
                    photoIsSource: !showLargeImage
                )
                .zIndex(2)
            }

            Text(hasPrinted ? "歌词照片已输出" : "正在打印歌词照片...")
                .font(.footnote)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Button("保存到相册") {
                    guard let image = viewModel.resultImage else { return }
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
                .buttonStyle(.borderedProminent)

                Button("分享") {
                    showShareSheet = true
                }
                .buttonStyle(.bordered)

                Button("重新生成") {
                    viewModel.regenerate()
                }
                .buttonStyle(.bordered)
            }
            .font(.callout)
            .padding(.horizontal, AppLayout.horizontalPadding)
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            hasPrinted = false
            outputProgress = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                withAnimation(.spring(response: 1.15, dampingFraction: 0.82)) {
                    outputProgress = 0.68
                    hasPrinted = true
                }
                Haptics.success()
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = viewModel.resultImage {
                ShareSheet(items: [image])
            }
        }
        .overlay {
            largeImageOverlay
        }
    }

    @ViewBuilder
    private var largeImageOverlay: some View {
        if showLargeImage, let image = viewModel.resultImage {
            GeometryReader { proxy in
                let maximumCardSize = CGSize(
                    width: proxy.size.width - 24,
                    height: proxy.size.height - 32
                )

                ZStack(alignment: .topTrailing) {
                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            closeLargeImage()
                        }

                    PolaroidPhotoCard(image: image, maximumSize: maximumCardSize)
                        .scaleEffect(largeImageScale)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .matchedGeometryEffect(
                            id: "turntable-photo",
                            in: imageTransition,
                            isSource: true
                        )
                        .shadow(color: .black.opacity(0.32), radius: 24, y: 14)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    largeImageScale = min(max(settledImageScale * value, 1), 5)
                                }
                                .onEnded { _ in
                                    settledImageScale = largeImageScale
                                }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                largeImageScale = 1
                                settledImageScale = 1
                            }
                        }

                    Button {
                        closeLargeImage()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                    }
                    .padding(20)
                }
                .ignoresSafeArea()
            }
            .zIndex(20)
        }
    }

    private func closeLargeImage() {
        largeImageScale = 1
        settledImageScale = 1
        withAnimation(.spring(response: 0.42, dampingFraction: 0.88)) {
            showLargeImage = false
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
