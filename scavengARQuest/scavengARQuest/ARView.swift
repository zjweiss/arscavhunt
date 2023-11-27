

import SwiftUI

struct ARView: View {
    @ObservedObject var arDelegate = ARDelegate()
    
    var body: some View {
        ZStack {
            ARViewRepresentable(arDelegate: arDelegate)
        }.edgesIgnoringSafeArea(.all)
    }
}
