import Foundation
import MapKit
import Combine

@MainActor
class MapViewViewModel: ObservableObject {
    struct MapPin: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let title: String?
    }

    @Published var region: MKCoordinateRegion
    @Published var pins: [MapPin]

    init(latitude: Double, longitude: Double, title: String? = nil, spanDelta: CLLocationDegrees = 0.01) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.region = MKCoordinateRegion(center: coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta))
        self.pins = [MapPin(coordinate: coordinate, title: title)]
    }
}
