import SwiftUI

struct HomeView: View {
    let tickets = Ticket.sampleTickets
    let news = NewsItem.sampleNews

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // BRAND HEADER WITH STREAMED LOGO
                HStack(spacing: 12) {
                    RemoteImage(url: BrandConfig.primaryLogoURL)
                        .frame(width: 120, height: 40)
                        .clipped()
                    Spacer()
                }
                .padding(.horizontal, 16)

                // MY TICKETS
                if let next = tickets.first {
                    Text("MY TICKETS:").font(.title3).bold().padding(.horizontal, 16)
                    MyTicketCard(ticket: next).padding(.horizontal, 16)
                    // Non-nav placeholder; hook into your tab switch if desired
                    Button("VIEW ALL") {}
                        .font(.subheadline).bold().foregroundStyle(Theme.schoolColor)
                        .padding(.horizontal, 16)
                }

                // SHOP
                Text("SHOP:").font(.title3).bold().padding(.horizontal, 16)
                HStack { Text("STUDENT FEES"); Spacer(); Button("GO TO"){} .foregroundStyle(Theme.schoolColor).bold() }
                    .padding(.horizontal, 16)

                // CONCESSIONS
                Text("CONCESSIONS:").font(.title3).bold().padding(.horizontal, 16)
                HStack { Text("Buy at counter with code"); Spacer(); Button("OPEN"){} .foregroundStyle(Theme.schoolColor).bold() }
                    .padding(.horizontal, 16)

                // NEWS
                Text("NEWS:").font(.title3).bold().padding(.horizontal, 16)
                if let first = news.first { NewsSnippetView(news: first).padding(.horizontal, 16) }
                if news.count > 1 {
                    Button("VIEW ALL"){}.foregroundStyle(Theme.schoolColor).bold().padding(.horizontal, 16)
                }
            }
            .padding(.top, 16)
        }
    }
}

struct MyTicketCard: View {
    let ticket: Ticket
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ticket.event.sportName).font(.headline)
            Text("\(ticket.event.formattedDate)  \(ticket.event.formattedTime)")
                .font(.subheadline).foregroundStyle(.secondary)
            if !ticket.event.opponent.isEmpty {
                Text("\(ticket.event.location) VS \(ticket.event.opponent)")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            HStack {
                Text("\(ticket.type) x \(ticket.quantity)").font(.subheadline).bold()
                    .padding(.vertical,4).padding(.horizontal,8)
                    .background(Theme.schoolColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Spacer()
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

struct NewsSnippetView: View {
    let news: NewsItem
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(news.title).font(.headline)
            Text(news.excerpt).font(.subheadline).foregroundStyle(.secondary).lineLimit(3)
            Text(news.formattedDate).font(.caption).foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}
