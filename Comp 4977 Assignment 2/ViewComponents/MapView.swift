import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewViewModel

    init(latitude: Double, longitude: Double, title: String? = nil) {
        _viewModel = StateObject(wrappedValue: MapViewViewModel(latitude: latitude, longitude: longitude, title: title))
    }

    var body: some View {
        Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.pins) { pin in
            MapMarker(coordinate: pin.coordinate, tint: .red)
        }
        .frame(height: 250)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    MapView(latitude: 49.03023500, longitude: -122.28706200, title: "Rogers Forum")
}
