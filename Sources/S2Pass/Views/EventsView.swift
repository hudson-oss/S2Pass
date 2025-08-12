import SwiftUI

struct EventsListView: View {
    @Binding var selectedEvent: Event?
    let events = Event.sampleEvents

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("SELECT AN EVENT TO PURCHASE TICKETS").font(.title3).bold()
                Spacer()
                Button("FILTER"){}.bold().foregroundStyle(Theme.schoolColor)
            }.padding([.horizontal, .top], 16)

            Text("EVENTS").font(.largeTitle).bold().padding(.horizontal, 16).padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(events) { ev in
                        EventRow(event: ev).onTapGesture { selectedEvent = ev }
                    }
                }
                .padding(.horizontal, 16).padding(.bottom, 20)
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack { Text(event.sportName).font(.headline); Spacer();
                Text(event.ticketsOnSale ? "AVAILABLE" : "NOT AVAILABLE").font(.subheadline).bold()
                    .foregroundStyle(event.ticketsOnSale ? Theme.schoolColor : .red)
            }
            if !event.opponent.isEmpty {
                HStack(spacing: 6) {
                    Text(event.isHomeGame ? "HOME" : "AWAY").font(.caption).bold().foregroundStyle(.secondary)
                    Text("VS").font(.caption).foregroundStyle(.secondary)
                    Text(event.isHomeGame ? event.opponent : event.location).font(.caption).foregroundStyle(.secondary)
                    Text("|")
                    Text(event.reservedSeatingAvailable ? "Reserved Seating" : "No Reserved Seating")
                        .font(.caption).foregroundStyle(event.reservedSeatingAvailable ? Theme.schoolColor : .secondary)
                }
            }
            Text("\(event.formattedDate) – \(event.formattedTime)").font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
}
