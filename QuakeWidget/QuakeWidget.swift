//
//  QuakeWidget.swift
//  QuakeWidget
//
//  Created by Swiftaholic on 17/02/2024.
//  Copyright © 2024 Apple. All rights reserved.
//

import WidgetKit
import SwiftUI

struct QuakeProvider: TimelineProvider {
    @StateObject private var quakesProvider: QuakesProvider = QuakesProvider()
    
    func placeholder(in context: Context) -> QuakeEntry {
        QuakeEntry(quake: Quake())
    }

    func getSnapshot(in context: Context, completion: @escaping (QuakeEntry) -> ()) {
        let entry = QuakeEntry(quake: Quake())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuakeEntry>) -> ()) {
        Task {
            do {
                try await quakesProvider.fetchQuakes()
                
                let latestQuake = quakesProvider.quakes[0]
                let quakeEntry = QuakeEntry(quake: latestQuake)
                let timeline = Timeline(entries: [quakeEntry], policy: .atEnd)
                completion(timeline)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct QuakeEntry: TimelineEntry {
    let date: Date = Date()
    let quake: Quake
}

struct QuakeWidgetEntryView : View {
    var entry: QuakeProvider.Entry

    var body: some View {
        VStack {
            QuakeMagnitude(quake: entry.quake)
            Text(entry.quake.place)
                .font(.title3)
                .bold()
        }
        .padding()
    }
}

struct QuakeWidget: Widget {
    let kind: String = "QuakeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuakeProvider()) { entry in
            if #available(iOS 17.0, *) {
                QuakeWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                QuakeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Quake Widget")
        .description("This is a quake widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}

struct QuakeWidget_Previews: PreviewProvider {
    static var previews: some View {
        QuakeWidgetEntryView(entry: QuakeEntry(quake: Quake(magnitude: 0.0)))
            .padding()
            .background(Color.gray) // Placeholder background
            .previewLayout(.sizeThatFits)
    }
}
