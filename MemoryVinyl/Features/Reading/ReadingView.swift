import SwiftUI

struct ReadingView: View {
    @ObservedObject var viewModel: AppFlowViewModel

    var body: some View {
        VStack(spacing: 10) {
            TurntableView(
                image: viewModel.selectedImage,
                insertedProgress: viewModel.insertedProgress,
                playing: true,
                statusText: viewModel.readingText
            )
            Text("请稍候，系统正在匹配音乐记忆...")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
    }
}
