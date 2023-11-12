import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let locationDetails: Location
    
    var body: some View {
        let lat  = Double(locationDetails.latitude) ?? 0
        let lon  = Double(locationDetails.longitude) ?? 0

        Map(position: $cameraPosition) {
                    Marker(locationDetails.name, systemImage: "mappin",
                           coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    .tint(.red)
            
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
