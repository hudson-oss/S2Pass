import SwiftUI

struct TicketsView: View {
    let tickets = Ticket.sampleTickets
    var body: some View {
        VStack(alignment: .leading) {
            Text("YOUR TICKETS").font(.largeTitle).bold()
                .padding(.horizontal, 16).padding(.top, 16).padding(.bottom, 8)
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(tickets) { TicketRow(ticket: $0) }
                }.padding(.horizontal, 16).padding(.bottom, 20)
            }
        }
    }
}

struct TicketRow: View {
    let ticket: Ticket
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ticket.event.sportName).font(.headline)
            Text("\(ticket.event.formattedDate) at \(ticket.event.formattedTime)")
                .font(.subheadline).foregroundStyle(.secondary)
            if !ticket.event.opponent.isEmpty {
                Text("\(ticket.event.opponent) VS \(ticket.event.location)")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            HStack { Text("\(ticket.type) x\(ticket.quantity)").bold(); Spacer() }
        }
        .padding(12)
        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}
