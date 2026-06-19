import Foundation
import PhotosUI
import SwiftUI
import UIKit

@MainActor
final class AppFlowViewModel: ObservableObject {
    enum Step {
        case home
        case reading
        case recommend
        case result
    }

    @Published var step: Step = .home
    @Published var selectedImage: UIImage?
    @Published var insertedProgress: CGFloat = 0
    @Published var readingText: String = "正在读取照片氛围"
    @Published var emotionProfile: EmotionProfile?
    @Published var songs: [Song] = []
    @Published var currentSongIndex: Int = 0
    @Published var selectedLyrics: [String] = []
    @Published var resultImage: UIImage?

    private let readingTexts = ["正在读取照片氛围", "正在识别画面情绪", "正在匹配音乐记忆"]

    var currentSong: Song? {
        guard songs.indices.contains(currentSongIndex) else { return nil }
        return songs[currentSongIndex]
    }

    func handlePickedImage(_ image: UIImage) {
        selectedImage = image
        insertedProgress = 0
        step = .reading

        Task {
            await runInsertAndReading()
        }
    }

    func toggleLyric(_ line: String) {
        if let idx = selectedLyrics.firstIndex(of: line) {
            selectedLyrics.remove(at: idx)
            return
        }
        guard selectedLyrics.count < 3 else { return }
        selectedLyrics.append(line)
    }

    func switchSong(offset: Int) {
        guard !songs.isEmpty else { return }
        currentSongIndex = (currentSongIndex + offset + songs.count) % songs.count
        selectedLyrics = []
    }

    func generateResult() {
        guard let image = selectedImage, let song = currentSong, !selectedLyrics.isEmpty else { return }
        let footer = "\(song.songName) · \(song.artist)"
        resultImage = LyricImageRenderer.render(baseImage: image, lyrics: selectedLyrics, footer: footer)
        step = .result
    }

    func regenerate() {
        step = .recommend
    }

    func returnHome() {
        step = .home
        selectedImage = nil
        insertedProgress = 0
        readingText = readingTexts[0]
        emotionProfile = nil
        songs = []
        currentSongIndex = 0
        selectedLyrics = []
        resultImage = nil
    }

    private func runInsertAndReading() async {
        let duration: CGFloat = 3.8
        let tick: UInt64 = 80_000_000
        let count = Int((Double(duration) * 1_000_000_000) / Double(tick))

        for i in 0...count {
            insertedProgress = CGFloat(i) / CGFloat(max(1, count))
            if i == 1 { Haptics.light() }
            if i == count / 2 { Haptics.soft() }
            if i == count { Haptics.success() }
            if i % max(1, count / readingTexts.count) == 0 {
                let index = min(readingTexts.count - 1, i * readingTexts.count / max(1, count))
                readingText = readingTexts[index]
            }
            try? await Task.sleep(nanoseconds: tick)
        }

        guard let image = selectedImage else { return }
        emotionProfile = EmotionAnalyzer.analyze(image)
        songs = SongLibrary.byCategory[emotionProfile?.category ?? "城市孤独"] ?? SongLibrary.fallback
        currentSongIndex = 0
        selectedLyrics = []
        step = .recommend
    }
}

enum Haptics {
    static func light() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

enum SongLibrary {
    static let byCategory: [String: [Song]] = [
        "蓝色夜晚": [
            Song(songName: "因为爱情", artist: "陈奕迅 / 王菲", lyricLines: ["虽然会经常忘了", "我依然爱着你", "因为爱情", "不会轻易悲伤", "所以一切都是幸福的模样"], emotionTags: ["安静", "怀旧", "浪漫"], reason: "冷色与灯光并存，适合柔和回忆感歌曲。"),
            Song(songName: "富士山下", artist: "陈奕迅", lyricLines: ["谁都只得那双手", "靠拥抱亦难任你拥有", "要拥有必先懂失去怎接受", "你还嫌不够", "灯火沿着回忆慢慢亮起"], emotionTags: ["克制", "夜色", "流动"], reason: "透视和留白明显，适合叙事慢歌。"),
            Song(songName: "后来", artist: "刘若英", lyricLines: ["后来 我总算学会了如何去爱", "可惜你早已远去", "消失在人海", "有些人 一旦错过就不在", "那段青春仍在心里回响"], emotionTags: ["遗憾", "回望"], reason: "画面有旧胶片观感，适合怀旧抒情。")
        ],
        "暖色黄昏": [
            Song(songName: "小半", artist: "陈粒", lyricLines: ["我的爱意有些任性", "你是我穷极一生都做不完的梦", "我在等 风也在等", "晚霞把思念留在天边", "一句晚安藏着好多心事"], emotionTags: ["黄昏", "温柔"], reason: "暖色低饱和适合细碎情绪表达。"),
            Song(songName: "稻香", artist: "周杰伦", lyricLines: ["还记得你说家是唯一的城堡", "随着稻香河流继续奔跑", "乡间的歌谣永远的依靠", "风吹过田野也吹散烦恼", "回家的路一直都在脚下"], emotionTags: ["治愈", "轻松"], reason: "氛围偏治愈，适合抬升幸福感。"),
            Song(songName: "平凡之路", artist: "朴树", lyricLines: ["我曾经跨过山和大海", "也穿过人山人海", "我曾经失落失望失掉所有方向", "脚下的路仍向远方延伸", "平凡的日子也值得珍藏"], emotionTags: ["旅途", "成长"], reason: "日落叙事天然匹配旅途感歌词。")
        ]
    ]

    static let fallback: [Song] = [
        Song(songName: "夜空中最亮的星", artist: "逃跑计划", lyricLines: ["夜空中最亮的星", "请照亮我前行", "我祈祷拥有一颗透明的心灵", "微光穿过城市安静的夜", "抬起头就能看见希望"], emotionTags: ["城市", "夜晚", "希望"], reason: "默认情绪分组，保持稳定推荐体验。"),
        Song(songName: "慢慢喜欢你", artist: "莫文蔚", lyricLines: ["书里总爱写到喜出望外的傍晚", "我想我会开始想念你", "可是我刚刚才遇见了你", "日子在陪伴里慢慢变甜", "每次相遇都值得好好纪念"], emotionTags: ["柔软", "浪漫"], reason: "中性画面适合轻抒情。"),
        Song(songName: "成都", artist: "赵雷", lyricLines: ["和我在成都的街头走一走", "直到所有的灯都熄灭了也不停留", "你会挽着我的衣袖", "街边的灯映着温柔晚风", "旧巷深处还留着故事"], emotionTags: ["街景", "生活感"], reason: "人文和街景通用场景匹配。")
    ]
}
