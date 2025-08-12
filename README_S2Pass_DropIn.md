# S2Pass Drop‑In Pack (Streaming Logos)

This pack contains SwiftUI files that mirror the S2Pass mockups and stream logos from Google Drive.

## How to use
1. Download the zip (below), extract it.
2. In your repo, create (or open) `Sources/S2Pass/` and `Sources/S2Pass/Views/`.
3. Upload all files in the same folder structure via GitHub web UI.
4. Commit and run your existing **iOS Simulator Build** workflow.

## Streaming logos
- Open `Sources/S2Pass/BrandConfig.swift` and replace the four `...ShareURL` strings if needed.
- Ensure the Drive files are shared to **Anyone with the link**.
- The home header uses `RemoteImage(url: BrandConfig.primaryLogoURL)`. Add more uses wherever you want logos.

## Will this work with my current `ios-simulator-build.yml`?
**Yes**, as long as:
- The workflow builds `-project S2Pass.xcodeproj` and `-scheme S2Pass` (or whatever your actual scheme name is).
- Destination is a simulator (e.g., `generic/platform=iOS Simulator`). No specific device name is required.
- Code signing is disabled for simulator builds: `CODE_SIGNING_ALLOWED=NO`.
- If you use XcodeGen, ensure your project includes the `Sources/S2Pass` folder.

If your current workflow uses a different scheme or project file, either:
- rename the scheme to **S2Pass**, or
- edit the workflow to match your scheme name.

## Optional: example workflow
We included `.github/workflows/ios-simulator-build_example.yml` as a reference that builds the `S2Pass` scheme. Copy from it as needed.

## Appetize
After the Action finishes, download `AppetizeBuild.app.zip` artifact and upload it to Appetize.
