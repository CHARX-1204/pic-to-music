import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: AppFlowViewModel
    @State private var showShareSheet = false

    var body: some View {
        VStack(spacing: 14) {
            if let song = viewModel.currentSong {
                Text(song.songName)
                    .font(.title2.weight(.semibold))
                Text(song.artist)
                    .foregroundStyle(.secondary)
            }

            Group {
                if let image = viewModel.resultImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.1))
                        .overlay(Text("暂无生成图").foregroundStyle(.secondary))
                }
            }
            .frame(maxHeight: 460)
            .clipShape(RoundedRectangle(cornerRadius: 16))

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
            }

            Button("重新生成") {
                viewModel.regenerate()
            }
            .buttonStyle(.bordered)
        }
        .padding(20)
        .sheet(isPresented: $showShareSheet) {
            if let image = viewModel.resultImage {
                ShareSheet(items: [image])
            }
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
