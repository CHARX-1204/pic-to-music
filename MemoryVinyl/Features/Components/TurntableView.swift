import SwiftUI

enum AppLayout {
    static let turntableTopPadding: CGFloat = 56
    static let turntableScale: CGFloat = 0.64
    static let turntableHeight: CGFloat = 308
    static let horizontalPadding: CGFloat = 20
    static let turntableStageHeight = turntableTopPadding + turntableHeight
}

struct TurntableStage: View {
    let image: UIImage?
    let insertedProgress: CGFloat
    let playing: Bool
    let statusText: String?
    var recordTitle: String? = nil
    var recordArtist: String? = nil
    var onPhotoTap: (() -> Void)? = nil
    var photoNamespace: Namespace.ID? = nil
    var photoIsSource = true

    var body: some View {
        TurntableView(
            image: image,
            insertedProgress: insertedProgress,
            playing: playing,
            statusText: statusText,
            recordTitle: recordTitle,
            recordArtist: recordArtist,
            onPhotoTap: onPhotoTap,
            photoNamespace: photoNamespace,
            photoIsSource: photoIsSource
        )
        .padding(.horizontal, AppLayout.horizontalPadding)
        .padding(.top, AppLayout.turntableTopPadding)
        .frame(height: AppLayout.turntableStageHeight, alignment: .top)
        .frame(maxWidth: .infinity)
    }
}

struct PolaroidPhotoCard: View {
    let image: UIImage?
    let maximumSize: CGSize

    var body: some View {
        let layout = fittedLayout

        RoundedRectangle(cornerRadius: layout.cardSize.width * 0.05)
            .fill(Color.white)
            .frame(width: layout.cardSize.width, height: layout.cardSize.height)
            .overlay(alignment: .top) {
                Group {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        LinearGradient(
                            colors: [.blue.opacity(0.5), .gray.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                }
                .frame(width: layout.imageSize.width, height: layout.imageSize.height)
                .background(Color.black.opacity(0.035))
                .clipShape(RoundedRectangle(cornerRadius: layout.cardSize.width * 0.033))
                .padding(.top, 7)
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Text("Memory 01")
                    Spacer()
                    Text(Date.now.formatted(date: .numeric, time: .omitted))
                }
                .font(.system(size: max(11, layout.cardSize.width * 0.046)))
                .foregroundStyle(.gray)
                .padding(.horizontal, max(10, layout.cardSize.width * 0.042))
                .padding(.bottom, max(10, layout.cardSize.height * 0.031))
            }
    }

    private var fittedLayout: (cardSize: CGSize, imageSize: CGSize) {
        let maximumImageSize = CGSize(
            width: max(1, maximumSize.width - 14),
            height: max(1, maximumSize.height - 50)
        )
        let sourceSize = image?.size ?? maximumImageSize
        let scale = min(
            maximumImageSize.width / max(1, sourceSize.width),
            maximumImageSize.height / max(1, sourceSize.height)
        )
        let imageSize = CGSize(
            width: sourceSize.width * scale,
            height: sourceSize.height * scale
        )
        return (
            CGSize(width: imageSize.width + 14, height: imageSize.height + 50),
            imageSize
        )
    }
}

struct TurntableView: View {
    let image: UIImage?
    let insertedProgress: CGFloat
    let playing: Bool
    let statusText: String?
    var recordTitle: String? = nil
    var recordArtist: String? = nil
    var onPhotoTap: (() -> Void)? = nil
    var photoNamespace: Namespace.ID? = nil
    var photoIsSource = true

    init(
        image: UIImage?,
        insertedProgress: CGFloat,
        playing: Bool,
        statusText: String?
    ) {
        self.image = image
        self.insertedProgress = insertedProgress
        self.playing = playing
        self.statusText = statusText
        self.onPhotoTap = nil
        self.photoNamespace = nil
        self.photoIsSource = true
    }

    init(
        image: UIImage?,
        insertedProgress: CGFloat,
        playing: Bool,
        statusText: String?,
        recordTitle: String?,
        recordArtist: String?
    ) {
        self.image = image
        self.insertedProgress = insertedProgress
        self.playing = playing
        self.statusText = statusText
        self.recordTitle = recordTitle
        self.recordArtist = recordArtist
        self.onPhotoTap = nil
        self.photoNamespace = nil
        self.photoIsSource = true
    }

    init(
        image: UIImage?,
        insertedProgress: CGFloat,
        playing: Bool,
        statusText: String?,
        recordTitle: String?,
        recordArtist: String?,
        onPhotoTap: (() -> Void)?
    ) {
        self.image = image
        self.insertedProgress = insertedProgress
        self.playing = playing
        self.statusText = statusText
        self.recordTitle = recordTitle
        self.recordArtist = recordArtist
        self.onPhotoTap = onPhotoTap
        self.photoNamespace = nil
        self.photoIsSource = true
    }

    init(
        image: UIImage?,
        insertedProgress: CGFloat,
        playing: Bool,
        statusText: String?,
        recordTitle: String?,
        recordArtist: String?,
        onPhotoTap: (() -> Void)?,
        photoNamespace: Namespace.ID?,
        photoIsSource: Bool
    ) {
        self.image = image
        self.insertedProgress = insertedProgress
        self.playing = playing
        self.statusText = statusText
        self.recordTitle = recordTitle
        self.recordArtist = recordArtist
        self.onPhotoTap = onPhotoTap
        self.photoNamespace = photoNamespace
        self.photoIsSource = photoIsSource
    }

    var body: some View {
        ZStack(alignment: .top) {
            photoCard
            machine
                .padding(.top, 120)
        }
        .scaleEffect(AppLayout.turntableScale, anchor: .top)
        .frame(height: AppLayout.turntableHeight, alignment: .top)
    }

    private var photoCard: some View {
        let startY: CGFloat = -420
        let endY: CGFloat = 84
        let currentY = startY + (endY - startY) * insertedProgress

        return PolaroidPhotoCard(
            image: image,
            maximumSize: CGSize(width: 240, height: 320)
        )
            .offset(y: currentY)
            .shadow(color: .black.opacity(0.22), radius: 10, x: 0, y: 8)
            .animation(.easeInOut(duration: 0.16), value: insertedProgress)
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                onPhotoTap?()
            }
            .matchedGeometryIfAvailable(
                id: "turntable-photo",
                namespace: photoNamespace,
                isSource: photoIsSource
            )
            .opacity(photoNamespace != nil && !photoIsSource ? 0 : 1)
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
                    recordCover
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

    private var recordCover: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.11, blue: 0.24),
                            Color(red: 0.30, green: 0.56, blue: 0.66),
                            Color(red: 0.86, green: 0.74, blue: 0.56)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(.white.opacity(0.22), lineWidth: 1)
                .padding(10)

            if let recordTitle {
                VStack(spacing: 3) {
                    Text(recordTitle)
                        .font(.system(size: 13, weight: .bold))
                        .lineLimit(2)
                    if let recordArtist {
                        Text(recordArtist)
                            .font(.system(size: 8, weight: .medium))
                            .lineLimit(1)
                            .opacity(0.76)
                    }
                }
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(22)
            }

            Circle()
                .fill(.black.opacity(0.75))
                .frame(width: 9, height: 9)
        }
        .frame(width: recordTitle == nil ? 78 : 142, height: recordTitle == nil ? 78 : 142)
        .rotationEffect(.degrees(playing ? 360 : 0))
        .animation(playing ? .linear(duration: 3.6).repeatForever(autoreverses: false) : .default, value: playing)
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

private extension View {
    @ViewBuilder
    func matchedGeometryIfAvailable(
        id: String,
        namespace: Namespace.ID?,
        isSource: Bool
    ) -> some View {
        if let namespace {
            matchedGeometryEffect(id: id, in: namespace, isSource: isSource)
        } else {
            self
        }
    }
}
