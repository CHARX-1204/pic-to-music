import PhotosUI
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppFlowViewModel
    @State private var pickedItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 12) {
            Text("Memory Vinyl")
                .font(.title2.weight(.semibold))
            Text("把一张照片变成一首歌")
                .foregroundStyle(.secondary)

            TurntableView(
                image: viewModel.selectedImage,
                insertedProgress: 0,
                playing: false,
                statusText: "上传照片，唱片机会读取你的情绪记忆"
            )

            PhotosPicker(selection: $pickedItem, matching: .images) {
                Text("选择照片")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.cyan.opacity(0.9))
                    )
            }
            .onChange(of: pickedItem) { _, newValue in
                guard let newValue else { return }
                Task {
                    if let data = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        viewModel.handlePickedImage(image)
                    }
                }
            }
        }
        .padding(20)
    }
}
