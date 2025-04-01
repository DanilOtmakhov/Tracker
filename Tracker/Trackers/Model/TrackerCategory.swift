//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Danil Otmakhov on 31.03.2025.
//

import Foundation

struct TrackerCategory {
    
    let title: String
    let trackers: [Tracker]
    
    static let mockData: [TrackerCategory] = [
        TrackerCategory(
            title: "Привычки",
            trackers: [
                Tracker(
                id: UUID(),
                title: "Пить воду",
                emoji: "💧",
                color: .color1
                ),
                Tracker(
                    id: UUID(),
                    title: "Чтение 30 мин",
                    emoji: "📖",
                    color: .color11
                ),
                Tracker(
                    id: UUID(),
                    title: "Ранний подъем",
                    emoji: "⏰",
                    color: .color15
                )
            ]
        ),
        TrackerCategory(
            title: "Спорт",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "10 000 шагов",
                    emoji: "🚶‍♂️",
                    color: .color9
                ),
                Tracker(
                    id: UUID(),
                    title: "Тренировка",
                    emoji: "🏋️‍♂️",
                    color: .color3
                )
            ]
        )
    ]
    
}
