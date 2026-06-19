import SwiftUI

struct TurntableView: View {
    let image: UIImage?
    let insertedProgress: CGFloat
    let playing: Bool
    let statusText: String?

    var body: some View {
        ZStack(alignment: .top) {
            photoCard
            machine
                .padding(.top, 120)
        }
    }

    private var photoCard: some View {
        let startY: CGFloat = -420
        let endY: CGFloat = 84
        let currentY = startY + (endY - startY) * insertedProgress

        return RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.95))
            .frame(width: 240, height: 320)
            .overlay {
                Group {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        LinearGradient(colors: [.blue.opacity(0.5), .gray.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    }
                }
                .frame(width: 226, height: 270)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .offset(y: -12)
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Text("Memory 01")
                    Spacer()
                    Text(Date.now.formatted(date: .numeric, time: .omitted))
                }
                .font(.system(size: 11))
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .offset(y: currentY)
            .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 8)
            .animation(.easeInOut(duration: 0.16), value: insertedProgress)
    }

    private var machine: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(
                LinearGradient(colors: [Color.white, Color(white: 0.90), Color(white: 0.84)], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(height: 360)
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [.black.opacity(0.25), .clear], startPoint: .top, endPoint: .bottom))
                    .frame(height: 16)
                    .padding(.horizontal, 24)
            }
            .overlay {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color(white: 0.95), Color(white: 0.78)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 250, height: 250)
                    Circle()
                        .fill(.black)
                        .frame(width: 214, height: 214)
                        .overlay {
                            Circle().stroke(.white.opacity(0.12), lineWidth: 1)
                        }
                        .rotationEffect(.degrees(playing ? 360 : 0))
                        .animation(playing ? .linear(duration: 3.6).repeatForever(autoreverses: false) : .default, value: playing)
                    Circle().fill(.white).frame(width: 78, height: 78)
                }
                .offset(y: 10)
            }
            .overlay(alignment: .topTrailing) {
                tonearm
            }
            .overlay(alignment: .bottom) {
                if let statusText {
                    Text(statusText)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 16)
                }
            }
            .shadow(color: .black.opacity(0.2), radius: 14, x: 0, y: 10)
    }

    private var tonearm: some View {
        ZStack {
            Circle().fill(.gray.opacity(0.45)).frame(width: 44, height: 44)
            Capsule()
                .fill(LinearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom))
                .frame(width: 150, height: 8)
                .rotationEffect(.degrees(playing ? 28 : 38), anchor: .trailing)
                .offset(x: -58, y: 58)
                .animation(.easeInOut(duration: 0.35), value: playing)
        }
        .padding(.top, 32)
        .padding(.trailing, 18)
    }
}
