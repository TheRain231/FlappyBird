//
//  FlappyWidgetLiveActivity.swift
//  FlappyWidget
//
//  Created by Андрей Степанов on 11.09.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FlappyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct FlappyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlappyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension FlappyWidgetAttributes {
    fileprivate static var preview: FlappyWidgetAttributes {
        FlappyWidgetAttributes(name: "World")
    }
}

extension FlappyWidgetAttributes.ContentState {
    fileprivate static var smiley: FlappyWidgetAttributes.ContentState {
        FlappyWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: FlappyWidgetAttributes.ContentState {
         FlappyWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: FlappyWidgetAttributes.preview) {
   FlappyWidgetLiveActivity()
} contentStates: {
    FlappyWidgetAttributes.ContentState.smiley
    FlappyWidgetAttributes.ContentState.starEyes
}

#Preview("Dynamic Island", as: .dynamicIsland(.compact), using: FlappyWidgetAttributes.preview){
    FlappyWidgetLiveActivity()
} contentStates: {
    FlappyWidgetAttributes.ContentState.smiley
    FlappyWidgetAttributes.ContentState.starEyes
}
