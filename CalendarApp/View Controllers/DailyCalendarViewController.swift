//
//  ScheduleViewController.swift
//  CalendarApp
//
//  Created by Angelina Zhang on 7/14/22.
//

import Foundation
import CalendarKit

@objc
public protocol EventInteraction {
    func didTapEvent(_ eventID: UUID)
    func didLongPressEvent(_ eventID: UUID)
    func didLongPressTimeline(_ date: Date)
    func fetchEventsForDate(_ date: Date, callback: @escaping(_ events:[CalendarApp.Event]?, _ errorMessage: String?) -> Void)
}

@objcMembers
class DailyCalendarViewController : DayViewController {
    
    var controllerDelegate: EventInteraction?
    private let calendarEventHandler = CalendarEventHandler()
    private var fetchedDates = Set<Date>()
    
    func updateCalendarEvent(_ event: CalendarApp.Event, originalStartDate originalStart: Date, originalEndDate originalEnd: Date) {
        calendarEventHandler.updateEvent(event, originalStart, originalEnd)
        reloadData()
    }
    
    func deleteCalendarEvent(_ event: CalendarApp.Event) {
        calendarEventHandler.deleteEvent(event)
        reloadData()
    }
    
    func failedRequest(_ errorMessage: String) {
        // TODO: Error handling
    }
    
    func addEvent(_ eventModel: CalendarApp.Event) {
        calendarEventHandler.addNewEvent(eventModel)
        reloadData()
    }
    
    func fetchCalendarEventsForDate(_ date: Date) {
        controllerDelegate?.fetchEventsForDate(date, callback: { [self] events, errorMessage in
            if let newEvents = events {
                calendarEventHandler.addEventsFromArray(newEvents, date)
                DispatchQueue.main.async { [self] in
                    reloadData()
                }
            } else if let fetchErrorMessage = errorMessage {
                DispatchQueue.main.async { [self] in
                    failedRequest(fetchErrorMessage)
                }
            } else {
                DispatchQueue.main.async { [self] in
                    failedRequest("Something went wrong.")
                }
            }
        })
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let calendarKitEvents = calendarEventHandler.getEventsForDate(date)
        if (!fetchedDates.contains(date)) {
            fetchedDates.insert(date)
            fetchCalendarEventsForDate(date)
        }
        return calendarKitEvents
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? CalendarApp.Event else {
          return
        }
        controllerDelegate?.didTapEvent(descriptor.objectUUID)
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? CalendarApp.Event else {
          return
        }
        controllerDelegate?.didLongPressEvent(descriptor.objectUUID)
    }
    
    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        controllerDelegate?.didLongPressTimeline(date)
    }
}
