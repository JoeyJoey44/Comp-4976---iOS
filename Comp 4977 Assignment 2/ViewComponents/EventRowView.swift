//
//  EventRowView.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-14.
//

import SwiftUI

struct EventRowView: View {
    let event: Event

    var body: some View {
        HStack(spacing: 16) {

            AsyncImage(url: URL(string: event.images.first?.url ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 70, height: 70)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("\(event.venueName) - \(event.displayLocation)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    EventRowView(event: Event(
        id: "test1",
        name: "Test Concert",
        images: [
            EventImage(url: "https://picsum.photos/200", width: 200, height: 200)
        ],
        dates: EventDates(start: EventStart(dateTime: Date())),
        embedded: EventEmbedded(venues: [
            Venue(name: "Rogers Arena", city: VenueCity(name: "Vancouver"), state: VenueState(stateCode: "BC"))
        ])
    ))
    .padding()
    .background(Color.black)
}

