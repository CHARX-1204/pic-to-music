import UIKit

enum LyricImageRenderer {
    static func render(baseImage: UIImage, lyrics: [String], footer: String) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = baseImage.scale
        let renderer = UIGraphicsImageRenderer(size: baseImage.size, format: format)

        return renderer.image { ctx in
            baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))

            let drawLines = lyrics + [footer]
            let width = baseImage.size.width
            let height = baseImage.size.height

            let fontSize = max(20, width * 0.038)
            let lineHeight = fontSize * 1.45
            let totalHeight = CGFloat(drawLines.count) * lineHeight

            let startX = width * 0.08
            let startY = max(height * 0.12, height - totalHeight - height * 0.1)

            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .byTruncatingTail

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
                .foregroundColor: UIColor(white: 1, alpha: 0.95),
                .paragraphStyle: paragraph
            ]

            ctx.cgContext.setShadow(offset: CGSize(width: 0, height: 2), blur: 8, color: UIColor.black.withAlphaComponent(0.45).cgColor)

            for (index, line) in drawLines.enumerated() {
                let y = startY + CGFloat(index) * lineHeight
                let rect = CGRect(x: startX, y: y, width: width * 0.84, height: lineHeight + 4)
                line.draw(in: rect, withAttributes: attrs)
            }
        }
    }
}
