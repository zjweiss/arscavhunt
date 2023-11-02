import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let locationDetails: LocationDetailsStore?
    
    var body: some View {
        Map(position: $cameraPosition) {
            if let locationDetails {
                if let geodata = locationDetails.geodata {
                    Marker(locationDetails.name ?? "ERROR TITLE", systemImage: "mappin",
                           coordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon))
                    .tint(.red)
                }
            }
            UserAnnotation() // shows user location
        }
        .mapStyle(.hybrid(elevation: .realistic))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
    }
}
