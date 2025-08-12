# S2Pass (clean SwiftUI app)

This repo is FoodTruck-free. It uses XcodeGen to generate `S2Pass.xcodeproj` on the GitHub Mac runner.

## Build on GitHub (Appetize-ready)
1. Commit this repo.
2. Actions → **iOS Simulator Build (Appetize)** → Run workflow.
3. Download artifact → **AppetizeBuild.app.zip** → upload to Appetize (iOS → Simulator build).

## Local (optional)
If you have a Mac: `brew install xcodegen && xcodegen generate && open S2Pass.xcodeproj`.
