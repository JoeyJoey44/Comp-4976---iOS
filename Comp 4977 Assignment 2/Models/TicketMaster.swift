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
    let images: [EventImage]
    let dates: EventDates?
    let embedded: EventEmbedded?

    enum CodingKeys: String, CodingKey {
        case id, name, images, dates
        case embedded = "_embedded"
    }

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
}

struct VenueCity: Decodable {
    let name: String
}

struct VenueState: Decodable {
    let stateCode: String?
}

