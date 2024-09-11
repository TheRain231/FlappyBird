//
//  AppIntent.swift
//  FlappyWidget
//
//  Created by Андрей Степанов on 11.09.2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Score Option", default: "maxScore")
    var scoreOption: String
}
