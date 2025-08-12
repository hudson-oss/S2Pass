import Foundation

/// Configure streaming logo links here. Make sure each Google Drive file is shared to "Anyone with the link".
struct BrandConfig {
    static let primaryLogoShareURL = "https://drive.google.com/file/d/1Vqjka2eKt3Ha0YNeBEXWh-7vACX6RpRn/view?usp=drive_link"
    static let altLogoShareURL1    = "https://drive.google.com/file/d/1rQiFP98nbFN1JxkkogYYcpr2rOs9K_cB/view?usp=drive_link"
    static let altLogoShareURL2    = "https://drive.google.com/file/d/1Tg9PNiNZHZdqhtsgrngwPVDCLrYFlH1L/view?usp=drive_link"
    static let altLogoShareURL3    = "https://drive.google.com/file/d/1llUTMpIi7N-khF_KhP7ILHoZ4E1OwE1e/view?usp=drive_link"

    static var primaryLogoURL: URL? { driveDirectURL(from: primaryLogoShareURL) }
    static var altLogoURL1: URL? { driveDirectURL(from: altLogoShareURL1) }
    static var altLogoURL2: URL? { driveDirectURL(from: altLogoShareURL2) }
    static var altLogoURL3: URL? { driveDirectURL(from: altLogoShareURL3) }
}
