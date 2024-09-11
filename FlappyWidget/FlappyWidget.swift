//
//  FlappyWidget.swift
//  FlappyWidget
//
//  Created by Андрей Степанов on 11.09.2024.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct FlappyWidgetEntryView : View {
    var entry: Provider.Entry
    @AppStorage("maxScore", store: .init(suiteName: "group.TheRain.FlappyBird")) var maxScore = 0
    @AppStorage("attempts", store: .init(suiteName: "group.TheRain.FlappyBird")) var attempts = 0

    var body: some View {
        VStack {
            Image("yellowbird-midflap")
                .onAppear{
                    print(maxScore)
                }
            StrokeText(text: String(maxScore), width: 2, color: .black)
                .font(.custom("04b19", size: 40))
                .foregroundStyle(.white)
        }
    }
}

struct FlappyWidget: Widget {
    let kind: String = "FlappyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            FlappyWidgetEntryView(entry: entry)
                .containerBackground(.blue, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.scoreOption = "maxScore"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.scoreOption = "attempts"
        return intent
    }
}

#Preview(as: .systemSmall) {
    FlappyWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
