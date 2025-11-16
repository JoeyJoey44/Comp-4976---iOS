//
//  HomeViewViewModel.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-14.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class HomeViewViewModel: ObservableObject {
    @Published var selectedDMA: Int = 528   // default Vancouver
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var eventsByDate: [Date: [Event]] = [:]

    let dmaOptions: [(code: Int, name: String)] = [
        (500, "All of Canada"),
        (504, "Burnaby / New Westminster / Surrey"),
        (505, "Calgary"),
        (506, "Edmonton"),
        (508, "Hamilton-Niagara"),
        (510, "London-Sarnia"),
        (518, "Okanagan-Kootenays"),
        (519, "Ottawa"),
        (522, "Montreal"),
        (527, "Toronto"),
        (528, "Vancouver"),
        (529, "Sunshine Coast & Islands"),
        (530, "Winnipeg-Brandon"),
        (531, "Yukon")
    ]

    func fetchEvents() async {
        isLoading = true
        errorMessage = ""

        do {
            let root: TicketMasterRoot = try await NetworkManager.shared.request(
                TicketMasterRoot.self,
                endpoint: "/api/TicketMaster/events?dmaId=\(selectedDMA)",
                method: .get,
                body: nil
            )

            guard let events = root.embedded?.events else {
                errorMessage = "No events found."
                isLoading = false
                return
            }

            let grouped = Dictionary(grouping: events) { event -> Date in
                let date = event.displayDate ?? Date()
                return Calendar.current.startOfDay(for: date)
            }

            eventsByDate = grouped

        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

extension HomeViewViewModel {
    /// Create a lightweight mock view model for previews and tests.
    static func mock() -> HomeViewViewModel {
        let vm = HomeViewViewModel()

        let mockEvent = Event(
            id: "test1",
            name: "The Halluci Nation",
            url: "https://example.com/event/test1",
            info: "Sample event for preview",
            images: [EventImage(url: "https://picsum.photos/300", width: 300, height: 200)],
            dates: EventDates(start: EventStart(dateTime: Date())),
            embedded: EventEmbedded(venues: [
                Venue(name: "Commodore Ballroom",
                      city: VenueCity(name: "Vancouver"),
                      state: VenueState(stateCode: "BC"),
                      address: VenueAddress(line1: "868 Granville St", line2: nil),
                      location: VenueLocation(latitude: "49.2830", longitude: "-123.1187"))
            ])
        )

        let mockEvent2 = Event(
            id: "test2",
            name: "Peach Pit Live",
            url: "https://example.com/event/test2",
            info: "Sample event for preview",
            images: [EventImage(url: "https://picsum.photos/301", width: 300, height: 200)],
            dates: EventDates(start: EventStart(dateTime: Date().addingTimeInterval(86400))),
            embedded: EventEmbedded(venues: [
                Venue(name: "Queen Elizabeth Theatre",
                      city: VenueCity(name: "Vancouver"),
                      state: VenueState(stateCode: "BC"),
                      address: VenueAddress(line1: "630 Hamilton St", line2: nil),
                      location: VenueLocation(latitude: "49.2766", longitude: "-123.1158"))
            ])
        )

        vm.eventsByDate = Dictionary(grouping: [mockEvent, mockEvent2]) {
            Calendar.current.startOfDay(for: $0.displayDate ?? Date())
        }

        return vm
    }
}

