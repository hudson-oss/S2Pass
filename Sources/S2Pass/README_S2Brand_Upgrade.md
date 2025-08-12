
# S2 Brand Upgrade — What to paste

## Files in this download
- `ContentView_S2Brand_v1.swift` — drop-in for `Sources/S2Pass/ContentView.swift` (or your current ContentView file).

## Where to paste
1. In GitHub → open **Sources/S2Pass/ContentView.swift** → **Edit**.
2. Replace all content with the contents of `ContentView_S2Brand_v1.swift`.
3. Commit.

## What’s new (matches your screenshots)
- **Org Picker** (state filter, search, recent) — open from the "pin" button on Home.
- **Home** grid: *Events*, *Merchandise*, *News*, *Your Tickets*, plus **Concessions** & **Shop** buttons and social row.
- **News** list cards.
- **Concessions** flow with steps and QR/Code options.
- **Shop** categories with disclosure rows and "Add to Cart" placeholder.

## Brand
- Primary Orange: **#FF7A00** (override in `S2Brand.ColorPalette.orange` if your hex differs).
- Fonts default to **SF**; swap to **Eurostile Extended / Eurostile / Adelle** by changing `S2Brand.Fonts` to `.custom(...)` after you add the TTFs.
- Corner radius + soft shadows match your screenshots.

## Assets to add later (optional but recommended)
Create these image sets in **Assets.xcassets** using the provided files (vector PDF or PNG):
- `S2_Primary_Logo_Orange` → from **Primary_Logo_Orange (1).svg**
- `S2_Icon_Orange` → from **Icon_Logo_Orange (7).svg**
- `School_EagleValley` → from **CO_eaglevalleyhighschool (2).svg**
- `School_SouthsideCS` → from **NC_southside_CS.svg**

> Note: Xcode projects on CI sometimes prefer **PDF** over raw SVG. If the SVGs don't show, export a 1024px PNG or a single‑scale **PDF** and drop it into each image set.

## Build again
Run your **iOS Simulator Build (Appetize)** workflow. Upload the new artifact to Appetize.
