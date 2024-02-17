//
//  AllQuakesMap.swift
//  Earthquakes-iOS
//
//  Created by Swiftaholic on 14/02/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import SwiftUI
import MapKit

struct AllQuakesMap: View {
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @EnvironmentObject private var quakesProvider: QuakesProvider
    @State private var allLocationsLoaded: Bool = false
    
    var mapView: some View {
        Map(coordinateRegion: $region, annotationItems: quakesProvider.quakes.filter({ $0.location != nil })) { quake in
            MapMarker(coordinate: quake.location!.toMapCoordinate(), tint: quake.color)
        }
        .onAppear {
            withAnimation {
                region.center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                region.span = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
            }
        }
    }
    
    var body: some View {
        VStack {
            if allLocationsLoaded {
                mapView
                    .ignoresSafeArea(.container)
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                try await quakesProvider.fetchQuakes()
                
                allLocationsLoaded = true
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
}

extension QuakeLocation {
    func toMapCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

#Preview {
    AllQuakesMap()
}
