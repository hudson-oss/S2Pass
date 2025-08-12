import SwiftUI

/// Convert a Google Drive "file/d/<ID>/view" link to a direct-download URL usable by AsyncImage.
public func driveDirectURL(from shareURL: String) -> URL? {
    // Expect formats like: https://drive.google.com/file/d/<ID>/view?usp=...
    guard let idRange = shareURL.range(of: "/file/d/") else { return URL(string: shareURL) }
    let after = shareURL[idRange.upperBound...]
    guard let end = after.firstIndex(of: "/") else { return nil }
    let id = after[..<end]
    return URL(string: "https://drive.google.com/uc?export=download&id=\(id)")
}

/// Simple remote image with placeholder and error fallback.
public struct RemoteImage: View {
    let url: URL?
    public init(url: URL?) { self.url = url }
    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let img):
                img.resizable().scaledToFit()
            case .failure(_):
                Image(systemName: "photo").resizable().scaledToFit().foregroundStyle(.secondary)
            @unknown default:
                Color.clear
            }
        }
    }
}
