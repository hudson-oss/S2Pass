import SwiftUI

// MARK: - S2 Brand (colors + fonts)
struct S2Brand {
    struct ColorPalette {
        // Primary brand orange (from logo/screens); adjust if guidelines specify a different hex.
        static let orange = Color(hex: 0xFF7A00)
        static let onOrange = Color.white
        static let bg = Color(hex: 0xF7F7FA)
        static let card = Color.white
        static let text = Color.primary
        static let subtle = Color.black.opacity(0.06)
    }

    struct Fonts {
        // Frontify lists Eurostile Extended / Eurostile / Adelle.
        // Use system fonts by default; switch to .custom(...) after you add TTFs.
        static func title(_ size: CGFloat = 28) -> Font { .system(size: size, weight: .heavy, design: .rounded) }
        static func heading(_ size: CGFloat = 20) -> Font { .system(size: size, weight: .semibold, design: .rounded) }
        static func body(_ size: CGFloat = 16, _ weight: Font.Weight = .regular) -> Font { .system(size: size, weight: weight, design: .default) }
        static func label(_ size: CGFloat = 13, _ weight: Font.Weight = .semibold) -> Font { .system(size: size, weight: weight, design: .rounded) }
        static func caption(_ size: CGFloat = 12) -> Font { .system(size: size, weight: .regular, design: .rounded) }
    }

    enum Asset: String {
        case brandPrimary = "S2_Primary_Logo_Orange"
        case brandIcon    = "S2_Icon_Orange"
        case eagleValley  = "School_EagleValley"
        case southsideCS  = "School_SouthsideCS"
    }
}

// MARK: - Models
struct Organization: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let state: String
    let logoAsset: String?
    let shortCode: String
}

struct SchoolTheme: Equatable {
    var primary: Color = S2Brand.ColorPalette.orange
    var onPrimary: Color = S2Brand.ColorPalette.onOrange
    var background: Color = S2Brand.ColorPalette.bg
    var surface: Color = S2Brand.ColorPalette.card
    var onSurface: Color = S2Brand.ColorPalette.text
    var accent: Color = Color(hex: 0x111827)
}

enum VenueSide: String, CaseIterable { case home = "HOME", away = "AWAY" }
enum Availability: String { case available = "AVAILABLE", notAvailable = "NOT AVAILABLE" }

struct EventItem: Identifiable, Hashable {
    let id = UUID()
    let sport: String
    let date: Date
    let side: VenueSide
    let availability: Availability
    let host: Organization
    let opponent: Organization
    let locationAddress: String
    let hasReservedSeating: Bool
}

struct Ticket: Identifiable, Hashable {
    let id = UUID()
    let event: EventItem
    let type: String
    let quantity: Int
}

struct NewsPost: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let body: String
    let date: Date
}

struct ShopCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var items: [ShopItem]
}

struct ShopItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let blurb: String
    let price: Decimal
    let inventory: Int
}

// MARK: - Sample Data
enum SampleData {
    static let orgs: [Organization] = [
        Organization(name: "Springwood HS", state: "Guam", logoAsset: S2Brand.Asset.eagleValley.rawValue, shortCode: "SPW"),
        Organization(name: "Hughes HS", state: "Guam", logoAsset: S2Brand.Asset.southsideCS.rawValue, shortCode: "HGH"),
        Organization(name: "Eagle Valley HS", state: "Colorado", logoAsset: S2Brand.Asset.eagleValley.rawValue, shortCode: "EVH")
    ]

    static var events: [EventItem] {
        let host = orgs[0], opp = orgs[1]
        let base = DateComponents(calendar: .current, year: 2025, month: 9, day: 10, hour: 19).date ?? .now
        return [
            EventItem(sport: "BOYS FOOTBALL (V)", date: base, side: .home, availability: .available, host: host, opponent: opp, locationAddress: "123 S2 PASS LANE", hasReservedSeating: true),
            EventItem(sport: "GIRLS VOLLEYBALL (JV)", date: base.addingTimeInterval(86400*3), side: .away, availability: .available, host: opp, opponent: host, locationAddress: "48 Ridge Ct.", hasReservedSeating: false),
            EventItem(sport: "BOYS SOCCER (V)", date: base.addingTimeInterval(86400*7), side: .home, availability: .available, host: host, opponent: opp, locationAddress: "123 S2 PASS LANE", hasReservedSeating: true)
        ]
    }

    static let tickets: [Ticket] = [
        Ticket(event: events[0], type: "GA", quantity: 1)
    ]

    static let news: [NewsPost] = [
        .init(title: "Football Wins State!", body: "Springwood HS completes an undefeated season to capture the 7A Guam Title!", date: Date()),
        .init(title: "Teacher of the Year!", body: "Mr. Johnson honored for his incredible work with our students and school community.", date: Date()),
        .init(title: "Finals", body: "Good luck on finals next week—study sessions in the library all week.", date: Date())
    ]

    static let shop: [ShopCategory] = [
        .init(name: "Archery", items: [
            .init(name: "Archery Sale", blurb: "test c", price: 20, inventory: 4)
        ]),
        .init(name: "Football", items: [
            .init(name: "Football Spring Training", blurb: "Preseason training pass", price: 35, inventory: 10)
        ])
    ]
}

// MARK: - Root App Shell
struct RootView: View {
    @State private var selectedOrg: Organization? = SampleData.orgs.first
    @State private var theme: SchoolTheme = .init()
    @State private var showOrgPicker: Bool = false
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView(theme: theme, org: selectedOrg, onPickOrg: { showOrgPicker = true })
            }
            .tabItem { Label("Homepage", systemImage: "house.fill") }
            .tag(0)

            NavigationStack { EventsView(theme: theme, org: selectedOrg) }
                .tabItem { Label("Events", systemImage: "calendar") }
                .tag(1)

            NavigationStack { TicketsView(theme: theme, org: selectedOrg) }
                .tabItem { Label("Your Tickets", systemImage: "ticket.fill") }
                .tag(2)
        }
        .tint(theme.primary)
        .sheet(isPresented: $showOrgPicker) {
            OrgPickerView(
                orgs: SampleData.orgs,
                stateOptions: Array(Set(SampleData.orgs.map{$0.state})).sorted(),
                recent: Array(SampleData.orgs.prefix(2)),
                onChoose: { sel in selectedOrg = sel; showOrgPicker = false }
            )
        }
    }
}

// MARK: - Org Picker (screenshot 1)
struct OrgPickerView: View {
    let orgs: [Organization]
    let stateOptions: [String]
    let recent: [Organization]
    var onChoose: (Organization) -> Void

    @State private var search: String = ""
    @State private var chosenState: String = ""

    var filtered: [Organization] {
        orgs.filter { org in
            (chosenState.isEmpty || org.state == chosenState) &&
            (search.isEmpty || org.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(S2Brand.Asset.brandPrimary.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 52)
                    .padding(.top, 12)

                Text("Find Your School or Organization")
                    .font(S2Brand.Fonts.heading(18))
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 6) {
                    Text("State").font(.headline).foregroundStyle(.primary)
                    Picker("State", selection: $chosenState) {
                        Text("All").tag("")
                        ForEach(stateOptions, id: \.self) { s in Text(s).tag(s) }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)

                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search schools and organizations", text: $search)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                    if !search.isEmpty {
                        Button { search = "" } label: { Image(systemName: "xmark.circle.fill") }
                    }
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Recent Selections").font(.headline).underline()
                    ForEach(recent) { org in
                        Button(action: { onChoose(org) }) {
                            Text(org.name).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)

                List {
                    ForEach(filtered) { org in
                        Button {
                            onChoose(org)
                        } label: {
                            HStack(spacing: 12) {
                                if let logo = org.logoAsset {
                                    Image(logo).resizable().scaledToFit().frame(width: 28, height: 28)
                                } else {
                                    Image(systemName: "building.2.fill").foregroundStyle(.secondary)
                                }
                                Text(org.name)
                                Spacer()
                                Text(org.state).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .padding(.bottom)
            .background(S2Brand.ColorPalette.bg.ignoresSafeArea())
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { /* parent dismisses sheet */ }.disabled(true)
                }
            }
        }
    }
}

// MARK: - Home (screenshot 2)
struct HomeView: View {
    let theme: SchoolTheme
    let org: Organization?
    var onPickOrg: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                HStack(spacing: 12) {
                    Button(action: onPickOrg) { Image(systemName: "mappin.circle") }
                    Spacer()
                    Text(org?.name ?? "Select Organization").font(S2Brand.Fonts.heading(20))
                    Spacer()
                    Image(systemName: "gearshape")
                }
                .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    NavCard(title: "Events", icon: "calendar", destination: AnyView(EventsView(theme: theme, org: org)))
                    NavCard(title: "Merchandise", icon: "tshirt.fill", destination: AnyView(ShopView(theme: theme)))
                    NavCard(title: "News", icon: "newspaper.fill", destination: AnyView(NewsListView(theme: theme)))
                    NavCard(title: "Your Tickets", icon: "qrcode.viewfinder", destination: AnyView(TicketsView(theme: theme, org: org)))
                }
                .padding(.horizontal)

                NavigationLink(destination: ConcessionsView(theme: theme)) {
                    Text("Concessions")
                        .font(S2Brand.Fonts.heading(18))
                        .padding(.vertical, 12).frame(maxWidth: .infinity)
                        .background(theme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                NavigationLink(destination: ShopView(theme: theme)) {
                    Text("Shop")
                        .font(S2Brand.Fonts.heading(18))
                        .padding(.vertical, 12).frame(maxWidth: .infinity)
                        .background(theme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                HStack(spacing: 12) {
                    ForEach(["facebook","instagram","bird","xmark","safari"], id: \.self) { name in
                        RoundedRectangle(cornerRadius: 10).fill(theme.surface)
                            .frame(width: 44, height: 44)
                            .overlay(Image(systemName: name == "bird" ? "bird" : (name == "xmark" ? "xmark" : name)).font(.title3))
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.vertical)
            .background(theme.background.ignoresSafeArea())
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NavCard: View {
    let title: String
    let icon: String
    let destination: AnyView

    var body: some View {
        NavigationLink {
            destination
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 42, weight: .regular))
                Text(title).font(.headline)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 18)
            .background(S2Brand.ColorPalette.card)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Events
struct EventsView: View {
    let theme: SchoolTheme
    let org: Organization?

    var body: some View {
        List {
            ForEach(SampleData.events) { event in
                NavigationLink { EventDetailView(event: event, theme: theme) } label: {
                    HStack(alignment: .top, spacing: 12) {
                        DateBadge(date: event.date)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(event.sport).font(.subheadline.weight(.semibold))
                                Spacer()
                                AvailabilityTag(availability: event.availability, theme: theme)
                            }
                            VenuePillRow(side: event.side, theme: theme)
                            VSRow(host: event.host, opponent: event.opponent)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EventDetailView: View {
    let event: EventItem
    let theme: SchoolTheme

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SponsorBanner(theme: theme)

                VStack(alignment: .leading, spacing: 8) {
                    Text(event.sport).font(.title3.bold())
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                        Text(event.date.formatted(date: .abbreviated, time: .shortened))
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    VenuePillRow(side: event.side, theme: theme)
                    VSRow(host: event.host, opponent: event.opponent)

                    Divider()

                    InfoGrid(event: event)

                    if event.hasReservedSeating {
                        Label("RESERVED SEATING AVAILABLE", systemImage: "square.grid.3x3")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(S2Brand.ColorPalette.orange)
                    }

                    Button {
                        // purchase flow
                    } label: {
                        Text("PURCHASE TICKETS")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(S2Brand.ColorPalette.onOrange)
                            .background(S2Brand.ColorPalette.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(S2Brand.ColorPalette.subtle))
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(S2Brand.ColorPalette.bg.ignoresSafeArea())
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Event Details")
    }
}

// MARK: - Tickets
struct TicketsView: View {
    let theme: SchoolTheme
    let org: Organization?

    var body: some View {
        List {
            Section("Active") {
                ForEach(SampleData.tickets) { ticket in
                    TicketRow(ticket: ticket, theme: theme)
                }
            }
        }
        .navigationTitle("Your Tickets")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - News
struct NewsListView: View {
    let theme: SchoolTheme
    var body: some View {
        List {
            ForEach(SampleData.news) { post in
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.title).font(.headline)
                    Text(post.body).font(.subheadline).foregroundStyle(.secondary)
                }
                .padding()
                .background(theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle("News")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Concessions
struct ConcessionsView: View {
    let theme: SchoolTheme
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                StepRow(step: 1, title: "Order From Concessions Counter", detail: "Head to the concessions counter and place your order. A code will be provided to complete your purchase.", theme: theme)
                StepRow(step: 2, title: "Enter Payment Code", detail: nil, theme: theme) {
                    HStack(spacing: 12) {
                        Button { /* code entry */ } label: {
                            Label("Code Entry", systemImage: "text.cursor")
                                .padding().frame(maxWidth: .infinity)
                                .background(theme.surface).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        Button { /* scan */ } label: {
                            Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                                .padding().frame(maxWidth: .infinity)
                                .background(theme.surface).clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                StepRow(step: 3, title: "Payment Complete", detail: nil, theme: theme, isError: true)
            }
            .padding()
        }
        .navigationTitle("Concessions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StepRow<Content: View>: View {
    let step: Int
    let title: String
    var detail: String?
    let theme: SchoolTheme
    var isError: Bool = false
    @ViewBuilder var trailing: Content

    init(step: Int, title: String, detail: String?, theme: SchoolTheme, isError: Bool = false, @ViewBuilder trailing: () -> Content = { EmptyView() }) {
        self.step = step; self.title = title; self.detail = detail; self.theme = theme; self.isError = isError; self.trailing = trailing()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Circle().fill(isError ? Color.red : S2Brand.ColorPalette.orange)
                    .frame(width: 20, height: 20)
                    .overlay(Text("\(step)").font(.caption2.weight(.bold)).foregroundStyle(.white))
                Text(title).font(.headline)
            }
            if let detail {
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
            trailing
        }
        .padding()
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

// MARK: - Shop
struct ShopView: View {
    let theme: SchoolTheme
    @State private var search: String = ""

    var filtered: [ShopCategory] {
        if search.isEmpty { return SampleData.shop }
        return SampleData.shop.map { cat in
            .init(name: cat.name, items: cat.items.filter { $0.name.localizedCaseInsensitiveContains(search) || $0.blurb.localizedCaseInsensitiveContains(search) })
        }.filter { !$0.items.isEmpty }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for items", text: $search)
                if !search.isEmpty { Button { search = "" } label: { Image(systemName: "xmark.circle.fill") } }
                Spacer()
                Image(systemName: "bag.badge.plus")
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)

            List {
                ForEach(filtered) { cat in
                    Section(header: HStack {
                        Image(systemName: cat.name.lowercased().contains("archery") ? "scope" : "football")
                        Text(cat.name).font(.headline)
                    }) {
                        ForEach(cat.items) { item in
                            DisclosureGroup {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.blurb).font(.subheadline)
                                    HStack {
                                        Text("Price: $\(NSDecimalNumber(decimal: item.price))")
                                        Spacer()
                                        Button("Add to Cart") { /* hook */ }.buttonStyle(.borderedProminent)
                                    }.font(.caption)
                                }
                                .padding(.top, 4)
                            } label: {
                                HStack {
                                    Text(item.name).font(.subheadline.weight(.semibold))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Shop")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Reusables
struct AvailabilityTag: View {
    let availability: Availability
    let theme: SchoolTheme
    var body: some View {
        Text(availability.rawValue)
            .font(.caption2.weight(.heavy))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((availability == .available ? S2Brand.ColorPalette.orange : .gray.opacity(0.3)))
            .clipShape(Capsule())
            .foregroundStyle(S2Brand.ColorPalette.onOrange)
    }
}

struct DateBadge: View {
    let date: Date
    var body: some View {
        VStack(spacing: 2) {
            Text(date.formatted(.dateTime.month(.abbreviated))).font(.caption.weight(.bold))
            Text(date.formatted(.dateTime.day())).font(.title3.weight(.heavy))
            Text(date.formatted(.dateTime.weekday(.wide))).font(.caption2).lineLimit(1)
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(S2Brand.ColorPalette.subtle))
    }
}

struct VenuePillRow: View {
    let side: VenueSide
    let theme: SchoolTheme
    var body: some View {
        HStack(spacing: 8) {
            VenuePill(label: VenueSide.home.rawValue, isActive: side == .home, theme: theme)
            VenuePill(label: VenueSide.away.rawValue, isActive: side == .away, theme: theme)
            Spacer()
        }
    }
}

struct VenuePill: View {
    let label: String
    let isActive: Bool
    let theme: SchoolTheme
    var body: some View {
        Text(label)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(isActive ? S2Brand.ColorPalette.orange : Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isActive ? Color.clear : Color.black.opacity(0.1)))
            .foregroundStyle(isActive ? S2Brand.ColorPalette.onOrange : .secondary)
    }
}

struct VSRow: View {
    let host: Organization
    let opponent: Organization
    var body: some View {
        HStack(spacing: 8) {
            SchoolChip(name: host.name, logo: host.logoAsset)
            Text("VS").font(.caption.weight(.heavy)).foregroundStyle(.secondary).padding(.horizontal, 4)
            SchoolChip(name: opponent.name, logo: opponent.logoAsset)
            Spacer()
        }
    }
}

struct SchoolChip: View {
    let name: String
    let logo: String?
    var body: some View {
        HStack(spacing: 6) {
            if let logo { Image(logo).resizable().scaledToFit().frame(width: 16, height: 16) }
            Text(name).lineLimit(1)
        }
        .font(.caption.weight(.semibold))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black.opacity(0.1)))
    }
}

struct TicketRow: View {
    let ticket: Ticket
    let theme: SchoolTheme
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ticket.event.sport).font(.subheadline.weight(.semibold))
            Text(ticket.event.date, style: .date).font(.footnote).foregroundStyle(.secondary)
            HStack {
                Text("\(ticket.type) x \(ticket.quantity)")
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.black.opacity(0.1)))
                Spacer()
                Text("\(ticket.event.host.name) VS \(ticket.event.opponent.name)")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08)))
    }
}

struct SponsorBanner: View {
    let theme: SchoolTheme
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(S2Brand.ColorPalette.orange.opacity(0.1))
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("OUR BANNER SPONSOR?").font(.caption2).foregroundStyle(.secondary)
                    Text("SPONSOR").font(.title3.weight(.heavy))
                }
                Spacer()
                Image(systemName: "star.circle.fill").font(.system(size: 36))
            }.padding()
        }
        .frame(height: 80).padding(.horizontal)
    }
}

struct InfoGrid: View {
    let event: EventItem
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GridRowView(label: "DATE/TIME", value: event.date.formatted(date: .abbreviated, time: .shortened))
            GridRowView(label: "LOCATION", value: event.locationAddress)
            GridRowView(label: "DETAILS", value: "–")
        }
    }
}

struct GridRowView: View {
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .top) {
            Text(label).font(.caption.weight(.semibold)).frame(width: 90, alignment: .leading)
            Text(value).font(.subheadline)
            Spacer()
        }
    }
}

// MARK: - Utilities
extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
