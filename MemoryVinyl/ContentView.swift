import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppFlowViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.31, green: 0.41, blue: 0.47), Color(red: 0.10, green: 0.2, blue: 0.2)], startPoint: .top, endPoint: .bottom)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
