import SwiftUI

/// Main shell with top menu matching the mockups.
struct ContentView: View {
    enum Tab { case home, events, tickets }

    @State private var selectedTab: Tab = .home
    @State private var selectedEvent: Event? = nil

    var body: some View {
        VStack(spacing: 0) {
            TopMenuView(selectedTab: $selectedTab)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
            Divider()

            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()
                case .events:
                    EventsListView(selectedEvent: $selectedEvent)
                        .overlay(alignment: .trailing) {
                            if let ev = selectedEvent {
                                EventDetailView(event: ev) { selectedEvent = nil }
                                    .transition(.move(edge: .trailing))
                            }
                        }
                case .tickets:
                    TicketsView()
                }
            }
            .background(Color(UIColor.systemGray6))
        }
        .accentColor(Theme.schoolColor)
        .environment(\.colorScheme, .light) // designs are light-mode; remove if you want dark mode too
    }
}

/// Header nav: "Homepage | Events | Your Tickets" with active underline + brand color.
struct TopMenuView: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack(spacing: 20) {
            Button { selectedTab = .home } label: {
                Text("Homepage").font(.headline)
                    .foregroundStyle(selectedTab == .home ? Theme.schoolColor : .primary)
                    .underline(selectedTab == .home, color: Theme.schoolColor)
            }
            Button { selectedTab = .events } label: {
                Text("Events").font(.headline)
                    .foregroundStyle(selectedTab == .events ? Theme.schoolColor : .primary)
                    .underline(selectedTab == .events, color: Theme.schoolColor)
            }
            Button { selectedTab = .tickets } label: {
                Text("Your Tickets").font(.headline)
                    .foregroundStyle(selectedTab == .tickets ? Theme.schoolColor : .primary)
                    .underline(selectedTab == .tickets, color: Theme.schoolColor)
            }
            Spacer()
        }
    }
}
