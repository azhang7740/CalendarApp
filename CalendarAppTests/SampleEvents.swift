//
//  SampleEvents.swift
//  CalendarAppTests
//
//  Created by Angelina Zhang on 7/20/22.
//

import Foundation
@testable import CalendarApp

enum SampleEvents {
    static let valid = Event()
    private static let oneHour = TimeInterval(3600)
    private static let oneDay = TimeInterval(86400)
    
    static func makeEvent(on date: Date) -> Event {
        let event = Event()
        event.startDate = date
        event.endDate = date.advanced(by: oneHour)
        return event
    }
    
    static func makeEvent(on date: Date,
                          withDays days: Double,
                          withHours hours: Double) -> Event {
        let event = Event()
        event.startDate = date
        event.endDate = date.advanced(by: (Double(days) * oneDay + Double(hours) * oneHour))
        return event
    }
}
