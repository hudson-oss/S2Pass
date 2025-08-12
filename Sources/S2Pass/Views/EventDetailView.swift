import SwiftUI

struct EventDetailView: View {
    let event: Event
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            // Sponsor / banner (replace with AsyncImage/asset as needed)
            ZStack(alignment: .bottomLeading) {
                Color.black.opacity(0.15)
                VStack(alignment: .leading, spacing: 2) {
                    Text("OUR BANNER SPONSOR?").font(.headline).foregroundStyle(.white)
                    Text("123 S2 PASS LANE").font(.subheadline).foregroundStyle(.white)
                    Text("SPONSOR").font(.subheadline).foregroundStyle(.white)
                }.padding(8)
            }.frame(height: 120)

            Button { onClose() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left"); Text("Events")
                }
            }.tint(Theme.schoolColor).padding([.leading, .top], 16)

            Text(event.sportName).font(.title2).bold().padding(.horizontal, 16)
            Text("\(event.formattedTime)\n\(event.formattedDate)")
                .font(.headline).padding(.horizontal, 16).padding(.vertical, 4)

            if !event.opponent.isEmpty {
                HStack {
                    VStack { Text(event.isHomeGame ? "HOME" : "AWAY").font(.caption).bold().foregroundStyle(.secondary); Text(event.location).font(.body).bold() }
                    Spacer(); Text("VS").font(.headline).bold(); Spacer()
                    VStack { Text(event.isHomeGame ? "AWAY" : "HOME").font(.caption).bold().foregroundStyle(.secondary); Text(event.opponent).font(.body).bold() }
                }.padding(.horizontal, 16).padding(.vertical, 6)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("DATE/TIME").font(.caption).foregroundStyle(.secondary)
                Text("\(event.formattedDate) \(event.formattedTime)")
                Text("LOCATION").font(.caption).foregroundStyle(.secondary)
                Text(event.location.isEmpty ? "N/A" : event.location)
            }.padding(.horizontal, 16).padding(.vertical, 6)

            Text(event.reservedSeatingAvailable ? "RESERVED SEATING AVAILABLE" : "NO RESERVED SEATING")
                .font(.subheadline).bold().foregroundStyle(event.reservedSeatingAvailable ? Theme.schoolColor : .secondary)
                .padding(.horizontal, 16).padding(.top, 4)

            HStack { Spacer()
                Button("PURCHASE TICKETS") {}
                    .font(.headline).bold()
                    .padding(.vertical, 14).padding(.horizontal, 20)
                    .background(Theme.schoolColor).foregroundStyle(Theme.textColor(on: Theme.schoolColor))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer() }
                .padding(.horizontal, 16).padding(.vertical, 16)

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
    }
}
