import Foundation

struct Song: Identifiable, Codable, Hashable {
    let id: UUID
    let songName: String
    let artist: String
    let lyricLines: [String]
    let emotionTags: [String]
    let reason: String

    init(
        id: UUID = UUID(),
        songName: String,
        artist: String,
        lyricLines: [String],
        emotionTags: [String],
        reason: String
    ) {
        self.id = id
        self.songName = songName
        self.artist = artist
        self.lyricLines = lyricLines
        self.emotionTags = emotionTags
        self.reason = reason
    }
}
