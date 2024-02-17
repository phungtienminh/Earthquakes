//
//  QuakeDetailView.swift
//  Earthquakes-iOS
//
//  Created by Swiftaholic on 11/02/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI

struct QuakeDetailView: View {
    @State var isFullFraction: Bool = false
    @EnvironmentObject private var quakesProvider: QuakesProvider
    @State private var location: QuakeLocation? = nil
    
    var quake: Quake
    
    var body: some View {
        VStack {
            if let location = self.location {
                QuakeDetailMapView(location: location, tintColor: quake.color)
                    .ignoresSafeArea(.container)
            }
            
            QuakeMagnitude(quake: quake)
            Text(quake.place)
                .font(.title3)
                .bold()
                .onTapGesture {
                    isFullFraction.toggle()
                }
            Text("\(quake.time.formatted())")
                .foregroundStyle(Color.secondary)
            
            if let location = self.location {
                Text("Latitude: \(!isFullFraction ? location.latitude.formatted(.number.precision(.fractionLength(3))) : String(location.latitude))")
                
                Text("Longitude: \(!isFullFraction ? location.longitude.formatted(.number.precision(.fractionLength(3))) : String(location.longitude))")
            }
            
            NavigationLink(destination: AllQuakesMap()) {
                Text("See all quakes")
                    .foregroundColor(.blue)
            }
        }
        .task {
            if self.location == nil {
                if let location = quake.location {
                    self.location = location
                } else {
                    self.location = try? await quakesProvider.location(for: quake)
                }
            }
        }
    }
}

#Preview {
    QuakeDetailView(quake: Quake.preview)
}
