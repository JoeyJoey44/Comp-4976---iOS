//
//  TicketMaster.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-14.
//

import Foundation

struct TicketMasterRoot: Decodable {
    let embedded: EmbeddedEvents?

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedEvents: Decodable {
    let events: [Event]
}

struct Event: Decodable, Identifiable {
    let id: String
    let name: String
    let url: String              // <-- must match JSON
    let info: String?            // <-- optional from JSON
    let images: [EventImage]
    let dates: EventDates?
    let embedded: EventEmbedded?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case info
        case images
        case dates
        case embedded = "_embedded"
    }

    // MARK: Computed properties

    var venueName: String {
        embedded?.venues.first?.name ?? "Unknown Venue"
    }

    var city: String {
        embedded?.venues.first?.city?.name ?? ""
    }

    var state: String {
        embedded?.venues.first?.state?.stateCode ?? ""
    }

    var displayLocation: String {
        "\(city), \(state)"
    }

    var displayDate: Date? {
        dates?.start?.dateTime
    }

    var mainImageURL: String {
        images.first?.url ?? ""
    }

    var venue: Venue? {
        embedded?.venues.first
    }

    var addressLine: String {
        venue?.address?.line1 ?? "Address not available"
    }

    var latitude: Double? {
        if let str = venue?.location?.latitude {
            return Double(str)
        }
        return nil
    }

    var longitude: Double? {
        if let str = venue?.location?.longitude {
            return Double(str)
        }
        return nil
    }

    var eventDescription: String {
        info ?? "No event description available."
    }

    var ticketURL: URL? {
        URL(string: url)
    }
}


struct EventImage: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}

struct EventDates: Decodable {
    let start: EventStart?
}

struct EventStart: Decodable {
    let dateTime: Date?
}

struct EventEmbedded: Decodable {
    let venues: [Venue]
}

struct Venue: Decodable {
    let name: String
    let city: VenueCity?
    let state: VenueState?
    let address: VenueAddress?
    let location: VenueLocation?
}

struct VenueAddress: Decodable {
    let line1: String?
    let line2: String? // sometimes exists, optional
}

struct VenueLocation: Decodable {
    let latitude: String?
    let longitude: String?
}

struct VenueCity: Decodable {
    let name: String
}

struct VenueState: Decodable {
    let stateCode: String?
}

