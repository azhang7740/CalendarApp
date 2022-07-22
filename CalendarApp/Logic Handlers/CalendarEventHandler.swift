//
//  CalendarEventHandler.swift
//  CalendarApp
//
//  Created by Angelina Zhang on 7/18/22.
//

import Foundation
import CalendarKit

class CalendarEventHandler {
    private var dateToCalendarKitEvents = [Date: [CalendarApp.Event]]()
    private var calendar = Calendar(identifier: .gregorian)
    private var fetchedDates = Set<Date>()
    
    init() {
        calendar.timeZone = TimeZone.current
    }
    
    func getEventsForDate(_ date: Date) -> [CalendarApp.Event] {
        let midnight = calendar.startOfDay(for: date)
        return dateToCalendarKitEvents[midnight] ?? []
    }
    
    func addNewEvent(_ event:CalendarApp.Event) {
        var midnight = calendar.startOfDay(for: event.startDate)
        let endMidnight = calendar.startOfDay(for: event.endDate)
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        while (midnight <= endMidnight) {
            if var calendarEvents = dateToCalendarKitEvents[midnight]  {
                if (fetchedDates.contains(midnight)) {
                    calendarEvents.append(event)
                    dateToCalendarKitEvents[midnight] = calendarEvents
                }
            }
            guard let nextMidnight = calendar.date(byAdding: .day, value: 1, to: midnight) else {
                return
            }
            midnight = nextMidnight
        }
    }
    
    private func addEvent(_ event: CalendarApp.Event) {
        var midnight = calendar.startOfDay(for: event.startDate)
        let endMidnight = calendar.startOfDay(for: event.endDate)
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        while (midnight <= endMidnight) {
            if var calendarEvents = dateToCalendarKitEvents[midnight]  {
                if (!fetchedDates.contains(midnight)) {
                    calendarEvents.append(event)
                    dateToCalendarKitEvents[midnight] = calendarEvents
                }
            }
            guard let nextMidnight = calendar.date(byAdding: .day, value: 1, to: midnight) else {
                return
            }
            midnight = nextMidnight
        }
    }
    
    func addEventsFromArray(_ events:[CalendarApp.Event], _ date: Date) {
        let midnight = calendar.startOfDay(for: date)
        let calendarEvents = dateToCalendarKitEvents[midnight] ?? []
        dateToCalendarKitEvents[midnight] = calendarEvents
        events.forEach { addEvent($0) }
        fetchedDates.insert(midnight)
    }
    
    func deleteEvent(_ event: CalendarApp.Event) {
        let startMidnight = calendar.startOfDay(for: event.startDate)
        let endMidnight = calendar.startOfDay(for: event.endDate)
        deleteEventWithDates(event, startMidnight, endMidnight)
    }
    
    private func deleteEventWithDates(_ event: CalendarApp.Event,
                                      _ startDate: Date,
                                      _ endDate: Date) {
        var startMidnight = calendar.startOfDay(for: startDate)
        var dateComponents = DateComponents()
        dateComponents.day = 1
        while (startMidnight <= endDate) {
            if var calendarKitEvents = dateToCalendarKitEvents[startMidnight], let eventIndex = getEventIndex(event.objectUUID, calendarKitEvents) {
                calendarKitEvents.remove(at: eventIndex)
                dateToCalendarKitEvents[startMidnight] = calendarKitEvents
            }
            guard let nextMidnight = calendar.date(byAdding: .day, value: 1, to: startMidnight) else {
                return
            }
            startMidnight = nextMidnight
        }
    }
    
    func updateEvent(_ event: CalendarApp.Event, _ originalStart: Date, _ originalEnd: Date) {
        let originalMidnight = calendar.startOfDay(for: originalStart)
        let originalEndMidnight = calendar.startOfDay(for: originalEnd)
        deleteEventWithDates(event, originalMidnight, originalEndMidnight)
        addNewEvent(event)
    }
    
    private func getEventIndex(_ eventID: UUID, _ calendarEvents: [CalendarApp.Event]) -> Int? {
        calendarEvents.enumerated().first { element in
            element.element.objectUUID == eventID
        }?.offset
    }
}
