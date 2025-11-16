//
//  EventDetailView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-15.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    let event: Event

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: Event Image
                AsyncImage(url: URL(string: event.mainImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .frame(height: 260)
                        .clipped()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .frame(height: 260)
                }
                .scaledToFill()
                .frame(height: 260)
                .clipped()

                // MARK: Title
                Text(event.name)
                    .font(.largeTitle.bold())
                    .padding(.horizontal)

                // MARK: Venue + City
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.venueName)
                        .font(.headline)

                    Text(event.displayLocation)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(event.addressLine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                // MARK: Date + Time
                if let date = event.displayDate {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Date & Time")
                            .font(.headline)

                        Text(date.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                }

                Divider().padding(.horizontal)

                // MARK: Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("About the Event")
                        .font(.headline)

                    Text(event.eventDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)

                // MARK: Buy Tickets Button
                if let url = event.ticketURL {
                    Link(destination: url) {
                        Text("Buy Tickets")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }

                // MARK: Map (if lat/long available)
                if let lat = event.latitude, let lon = event.longitude {
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.headline)
                            .padding(.horizontal)

                        // Use a dedicated MapView component
                        MapView(latitude: lat, longitude: lon, title: event.venueName)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    // Construct a realistic sample event using fields from the provided Ticketmaster JSON
    let iso = ISO8601DateFormatter()
    let sampleDate = iso.date(from: "2025-11-22T02:00:00Z") ?? Date()

    let sampleEvent = Event(
        id: "1778vxG6uA7LMrN",
        name: "CoComelon: Sing-A-Long LIVE!",
        url: "https://www.ticketmaster.ca/cocomelon-singalong-live-abbotsford-british-columbia-11-21-2025/event/110062D1447F77A3",
        info: "CoComelon: Sing-A-Long LIVE is the perfect way to make memories you'll cherish for years to come! Join Ms. Appleberry, JJ, Cody, Nina and Cece for a lively Melon Patch musical adventure in this exciting touring production...",
        images: [EventImage(url: "https://s1.ticketm.net/dam/a/04b/8c88cec6-5b2d-4e29-aef5-6d704931604b_EVENT_DETAIL_PAGE_16_9.jpg", width: 205, height: 115)],
        dates: EventDates(start: EventStart(dateTime: sampleDate)),
        embedded: EventEmbedded(
            venues: [
                Venue(
                    name: "Rogers Forum",
                    city: VenueCity(name: "Abbotsford"),
                    state: VenueState(stateCode: "BC"),
                    address: VenueAddress(line1: "33800 King Rd", line2: nil),
                    location: VenueLocation(latitude: "49.03023500", longitude: "-122.28706200")
                )
            ]
        )
    )

    return NavigationView {
        EventDetailView(event: sampleEvent)
    }
}

