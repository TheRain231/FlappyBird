//
//  FlappyWidgetBundle.swift
//  FlappyWidget
//
//  Created by Андрей Степанов on 11.09.2024.
//

import WidgetKit
import SwiftUI

@main
struct FlappyWidgetBundle: WidgetBundle {
    var body: some Widget {
        FlappyWidget()
        FlappyWidgetLiveActivity()
    }
}
