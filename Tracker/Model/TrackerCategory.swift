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
            title: "Важное",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Доктор",
                    emoji: "👨🏿‍⚕️",
                    color: .color13,
                    schedule: nil
                )
            ]
        ),
        TrackerCategory(
            title: "Привычки",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Пить воду",
                    emoji: "💧",
                    color: .color1,
                    schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday/*, .sunday*/]
                ),
                Tracker(
                    id: UUID(),
                    title: "Чтение 30 мин",
                    emoji: "📖",
                    color: .color11,
                    schedule: [.monday, .tuesday, .thursday, .saturday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Ранний подъем",
                    emoji: "⏰",
                    color: .color15,
                    schedule: [.monday, .tuesday, .wednesday, .thursday, .friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Зарядка",
                    emoji: "🤸‍♀️",
                    color: .color7,
                    schedule: [.monday, .wednesday, .friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Медитация",
                    emoji: "🧘‍♀️",
                    color: .color5,
                    schedule: [.sunday, .monday, .wednesday, .friday]
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
                    color: .color9,
                    schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Тренировка",
                    emoji: "🏋️‍♂️",
                    color: .color3,
                    schedule: [.monday, .wednesday, .friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Велосипед",
                    emoji: "🚴‍♂️",
                    color: .color2,
                    schedule: [.tuesday, .thursday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Плавание",
                    emoji: "🏊‍♀️",
                    color: .color6,
                    schedule: [.monday, .wednesday, .friday]
                )
            ]
        ),
        TrackerCategory(
            title: "Работа",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Написать отчет",
                    emoji: "📝",
                    color: .color8,
                    schedule: [.monday, .wednesday, .friday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Ответить на письма",
                    emoji: "📧",
                    color: .color4,
                    schedule: [.monday, .tuesday, .thursday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Разработка новой фичи",
                    emoji: "💻",
                    color: .color10,
                    schedule: [.tuesday, .thursday, .saturday]
                )
            ]
        ),
        TrackerCategory(
            title: "Личное",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Сходить в магазин",
                    emoji: "🛒",
                    color: .color12,
                    schedule: [.saturday, .sunday]
                ),
                Tracker(
                    id: UUID(),
                    title: "Планирование недели",
                    emoji: "📅",
                    color: .color16,
                    schedule: [.sunday]
                )
            ]
        )
    ]

}
