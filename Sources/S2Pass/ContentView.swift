// Paste this over Sources/S2Pass/ContentView.swift
// Fixes build errors:
// 1) Remove Hashable from School/EventItem/Ticket (Color/Theme aren’t Hashable)
// 2) Rename NewsCard.body -> blurb (avoid redeclaration of 'body')
// 3) Use .navigationBarTitleDisplayMode(.inline) (works on iOS 16+)

import SwiftUI

// MARK: - Theme
struct SchoolTheme: Equatable {
    var primary: Color
    var onPrimary: Color
    var background: Color
    var surface: Color
    var onSurface: Color
    var accent: Color

    static let bradford = SchoolTheme(
        primary: Color(hex: 0xFF7A00), // Orange
        onPrimary: .white,
        background: Color(hex: 0xF2F2F7), // neutral bg (no UIKit)
        surface: .white,                  // card surface
        onSurface: .primary,
        accent: Color(hex: 0x1F2937)
    )
}

// MARK: - Models
struct School: Identifiable {
    let id = UUID()
    let name: String
    let logoName: String? // SF Symbol or asset name
    let theme: SchoolTheme
}

enum VenueSide: String, CaseIterable { case home = "HOME", away = "AWAY" }

enum Availability: String { case available = "AVAILABLE", notAvailable = "NOT AVAILABLE" }

struct EventItem: Identifiable {
    let id = UUID()
    let sport: String // e.g., "BOYS BASEBALL (JV/V)"
    let date: Date
    let side: VenueSide
    let availability: Availability
    let host: School
    let opponent: School
    let locationAddress: String
    let hasReservedSeating: Bool
}

struct Ticket: Identifiable {
    let id = UUID()
    let event: EventItem
    let section: String?
    let row: String?
    let seat: String?
    let type: String // e.g., "GA"
    let quantity: Int
}

// MARK: - Sample Data
struct SampleData {
    static let bradford = School(name: "BRADFORD HS", logoName: "graduationcap.fill", theme: .bradford)
    static let solidRock = School(name: "SOLID ROCK HS", logoName: "shield.lefthalf.filled", theme: .bradford)

    static var events: [EventItem] {
        let baseDate = DateComponents(calendar: .current, year: 2025, month: 6, day: 30, hour: 20).date ?? .now
        return [
            EventItem(sport: "BOYS BASEBALL (JV/V)", date: baseDate, side: .home, availability: .available, host: bradford, opponent: solidRock, locationAddress: "123 S2 PASS LANE", hasReservedSeating: true),
            EventItem(sport: "BOYS BASEBALL (JV/V)", date: baseDate, side: .away, availability: .available, host: bradford, opponent: solidRock, locationAddress: "123 S2 PASS LANE", hasReservedSeating: false),
            EventItem(sport: "BOYS BASEBALL (JV/V)", date: baseDate, side: .home, availability: .available, host: bradford, opponent: solidRock, locationAddress: "123 S2 PASS LANE", hasReservedSeating: true),
            EventItem(sport: "BOYS BASEBALL (JV/V)", date: baseDate, side: .home, availability: .available, host: bradford, opponent: solidRock, locationAddress: "123 S2 PASS LANE", hasReservedSeating: false)
        ]
    }

    static var tickets: [Ticket] { [Ticket(event: events[0], section: nil, row: nil, seat: nil, type: "GA", quantity: 1)] }
}

// MARK: - Root & Tabs (entry view)
struct RootView: View {
    @State private var selectedTab: Int = 0
    @State private var theme: SchoolTheme = .bradford

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeView(theme: theme) }
                .tabItem { Label("Homepage", systemImage: "house.fill") }
                .tag(0)

            NavigationStack { EventsView(theme: theme) }
                .tabItem { Label("Events", systemImage: "calendar") }
                .tag(1)

            NavigationStack { TicketsView(theme: theme) }
                .tabItem { Label("Your Tickets", systemImage: "ticket.fill") }
                .tag(2)
        }
        .tint(theme.primary)
    }
}

// MARK: - Home
struct HomeView: View {
    let theme: SchoolTheme

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Header(title: "BRADFORD HS", theme: theme)

                // Featured Events
                SectionHeader(title: "EVENTS", actionTitle: "VIEW ALL")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SampleData.events) { event in
                            NavigationLink { EventDetailView(event: event, theme: theme) } label: {
                                EventCard(event: event, theme: theme)
                            }
                        }
                    }.padding(.horizontal)
                }

                // My Tickets
                SectionHeader(title: "MY TICKETS:", actionTitle: "VIEW ALL")
                VStack(spacing: 12) {
                    ForEach(SampleData.tickets) { ticket in
                        TicketRow(ticket: ticket, theme: theme)
                    }
                }.padding(.horizontal)

                // Shop / Concessions Quick Links
                SectionHeader(title: "SHOP:", actionTitle: "GO TO")
                QuickLinkRow(items: [
                    QuickLinkItem(title: "STUDENT FEES", icon: "creditcard"),
                    QuickLinkItem(title: "CONCESSIONS", icon: "cart.fill")
                ], theme: theme)
                .padding(.horizontal)

                // News
                SectionHeader(title: "NEWS:", actionTitle: "VIEW ALL")
                NewsCard(title: "SAMPLE NEWS TITLE",
                         blurb: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.",
                         theme: theme)
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(theme.background.ignoresSafeArea())
        }
        .navigationTitle("Homepage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Events
struct EventsView: View {
    let theme: SchoolTheme
    @State private var side: VenueSide? = nil
    @State private var showFilter = false

    var filtered: [EventItem] { side == nil ? SampleData.events : SampleData.events.filter { $0.side == side } }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SELECT AN EVENT TO PURCHASE TICKETS")
                    .font(.footnote).foregroundStyle(.secondary)
                Spacer()
                Button { showFilter.toggle() } label: {
                    Label("FILTER", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.subheadline.bold())
                        .padding(8)
                        .background(theme.surface)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            List {
                ForEach(filtered) { event in
                    NavigationLink { EventDetailView(event: event, theme: theme) } label: {
                        EventListRow(event: event, theme: theme)
                    }
                }
            }
            .listStyle(.plain)
        }
        .sheet(isPresented: $showFilter) {
            FilterSheet(selected: $side, theme: theme)
                .presentationDetents([.medium])
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Event Detail
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
                    .accessibilityElement(children: .combine)

                    VenuePillRow(side: event.side, theme: theme)

                    VSRow(host: event.host, opponent: event.opponent)

                    Divider()

                    InfoGrid(event: event)

                    if event.hasReservedSeating {
                        Label("RESERVED SEATING AVAILABLE", systemImage: "square.grid.3x3")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(theme.primary)
                    }

                    Button { /* purchase flow */ } label: {
                        Text("PURCHASE TICKETS")
                            .font(.headline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(theme.onPrimary)
                            .background(theme.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.06)))
                .padding(.horizontal)
            }
            .padding(.vertical)
            .background(theme.background.ignoresSafeArea())
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Tickets
struct TicketsView: View {
    let theme: SchoolTheme

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

// MARK: - Components
struct Header: View {
    let title: String
    let theme: SchoolTheme

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "graduationcap.fill")
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 28))
                .foregroundStyle(theme.primary)
            Text(title)
                .font(.title2.bold())
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}

struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title).font(.headline)
            Spacer()
            if let actionTitle {
                Button(actionTitle) { action?() }
                    .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal)
    }
}

struct EventCard: View {
    let event: EventItem
    let theme: SchoolTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                AvailabilityTag(availability: event.availability, theme: theme)
                Spacer()
                DateBadge(date: event.date)
            }
            .padding(.bottom, 2)

            Text(event.sport)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)

            VenuePillRow(side: event.side, theme: theme)

            VSRow(host: event.host, opponent: event.opponent)
        }
        .padding(12)
        .frame(width: 300)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08)))
    }
}

struct EventListRow: View {
    let event: EventItem
    let theme: SchoolTheme

    var body: some View {
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

struct AvailabilityTag: View {
    let availability: Availability
    let theme: SchoolTheme

    var body: some View {
        Text(availability.rawValue)
            .font(.caption2.weight(.heavy))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((availability == .available ? theme.primary : .gray.opacity(0.3)))
            .clipShape(Capsule())
            .foregroundStyle(theme.onPrimary)
    }
}

struct DateBadge: View {
    let date: Date

    var body: some View {
        VStack(spacing: 2) {
            Text(date.formatted(.dateTime.month(.abbreviated)))
                .font(.caption.weight(.bold))
            Text(date.formatted(.dateTime.day()))
                .font(.title3.weight(.heavy))
            Text(date.formatted(.dateTime.weekday(.wide)))
                .font(.caption2)
                .lineLimit(1)
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.08)))
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
            .background(isActive ? theme.primary : Color.clear)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isActive ? Color.clear : Color.black.opacity(0.1)))
            .foregroundStyle(isActive ? theme.onPrimary : .secondary)
    }
}

struct VSRow: View {
    let host: School
    let opponent: School

    var body: some View {
        HStack(spacing: 8) {
            SchoolChip(school: host)
            Text("VS")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            SchoolChip(school: opponent)
            Spacer()
        }
    }
}

struct SchoolChip: View {
    let school: School

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: school.logoName ?? "building.2.fill")
            Text(school.name)
                .lineLimit(1)
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
            Text(ticket.event.sport)
                .font(.subheadline.weight(.semibold))
            Text(ticket.event.date, style: .date)
                .font(.footnote)
                .foregroundStyle(.secondary)
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

struct QuickLinkItem: Identifiable { let id = UUID(); let title: String; let icon: String }

struct QuickLinkRow: View {
    let items: [QuickLinkItem]
    let theme: SchoolTheme

    var body: some View {
        HStack(spacing: 12) {
            ForEach(items) { item in
                Button { /* hook */ } label: {
                    HStack(spacing: 8) {
                        Image(systemName: item.icon)
                        Text(item.title)
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .foregroundStyle(theme.onPrimary)
                    .background(theme.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
    }
}

struct NewsCard: View {
    let title: String
    let blurb: String
    let theme: SchoolTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            Text(blurb).font(.subheadline).foregroundStyle(.secondary)
            HStack { Spacer(); Button("VIEW ALL") {} }
        }
        .padding()
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.08)))
    }
}

struct SponsorBanner: View {
    let theme: SchoolTheme

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.primary.opacity(0.1))
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("OUR BANNER SPONSOR?").font(.caption2).foregroundStyle(.secondary)
                    Text("SPONSOR").font(.title3.weight(.heavy))
                }
                Spacer()
                Image(systemName: "star.circle.fill").font(.system(size: 36))
            }
            .padding()
        }
        .frame(height: 80)
        .padding(.horizontal)
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

struct FilterSheet: View {
    @Binding var selected: VenueSide?
    let theme: SchoolTheme

    var body: some View {
        NavigationStack {
            List {
                Section("Venue") {
                    Picker("Venue", selection: $selected) {
                        Text("Any").tag(nil as VenueSide?)
                        ForEach(VenueSide.allCases, id: \.self) { side in
                            Text(side.rawValue).tag(Optional(side))
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Filter")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Clear") { selected = nil } }
                ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } }
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
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
