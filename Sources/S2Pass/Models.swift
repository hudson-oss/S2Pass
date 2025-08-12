import Foundation

struct Event: Identifiable {
    let id = UUID()
    let sportName: String
    let date: Date
    let location: String
    let opponent: String
    let isHomeGame: Bool
    let ticketsOnSale: Bool
    let reservedSeatingAvailable: Bool

    var formattedDate: String {
        let df = DateFormatter(); df.dateFormat = "EEEE, MMM d"; return df.string(from: date)
    }
    var formattedTime: String {
        let df = DateFormatter(); df.dateFormat = "h:mm a"; return df.string(from: date) + " [EST]"
    }

    static let sampleEvents: [Event] = {
        var cal = Calendar.current; cal.timeZone = TimeZone(abbreviation: "EST") ?? .current
        let base = DateComponents(calendar: cal, year: 2025, month: 6, day: 30, hour: 20).date!
        return [
            Event(sportName: "Boys Baseball (JV/V)", date: base, location: "Bradford HS", opponent: "Solid Rock HS", isHomeGame: true, ticketsOnSale: true, reservedSeatingAvailable: true),
            Event(sportName: "Girls Soccer (Varsity)", date: cal.date(byAdding: .day, value: 3, to: base)!, location: "Our Stadium", opponent: "Eastside HS", isHomeGame: true, ticketsOnSale: true, reservedSeatingAvailable: false),
            Event(sportName: "Prom", date: cal.date(byAdding: .day, value: 7, to: base)!, location: "Auditorium", opponent: "", isHomeGame: true, ticketsOnSale: true, reservedSeatingAvailable: false)
        ]
    }()
}

struct Ticket: Identifiable {
    let id = UUID()
    let event: Event
    let quantity: Int
    let type: String
    static let sampleTickets: [Ticket] = [ Ticket(event: Event.sampleEvents[0], quantity: 1, type: "GA") ]
}

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let excerpt: String
    let date: Date
    var formattedDate: String {
        let df = DateFormatter(); df.dateFormat = "EEEE, MMM d h:mm a [z]"; return df.string(from: date)
    }
    static let sampleNews: [NewsItem] = [
        NewsItem(title: "Football Wins State!", excerpt: "Bradford HS captured the 7A Guam Title after an undefeated season.", date: Date()),
        NewsItem(title: "Teacher of the Year!", excerpt: "Mr. Johnson honored for his outstanding work with students and staff.", date: Date().addingTimeInterval(-86400))
    ]
}
