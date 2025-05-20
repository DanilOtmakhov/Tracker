//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Danil Otmakhov on 20.05.2025.
//

import YandexMobileMetrica

enum AnalyticsEvent: String {
    case open, close, click
}

enum AnalyticsScreen: String {
    case main = "Main"
}

enum AnalyticsItem: String {
    case addTrack = "add_track"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

final class AnalyticsService {

    static func log(event: AnalyticsEvent, screen: AnalyticsScreen, item: AnalyticsItem? = nil) {
        var parameters: [AnyHashable: Any] = [
            "event": event.rawValue,
            "screen": screen.rawValue
        ]
        
        if let item {
            parameters["item"] = item.rawValue
        }

        YMMYandexMetrica.reportEvent("user_action", parameters: parameters, onFailure: { error in
            print("AppMetrica error: \(error.localizedDescription)")
        })
    }
    
}



