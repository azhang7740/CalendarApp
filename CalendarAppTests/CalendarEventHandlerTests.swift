//
//  CalendarEventHandlerTests.swift
//  CalendarAppTests
//
//  Created by Angelina Zhang on 7/20/22.
//

import XCTest
@testable import CalendarApp

class CalendarEventHandlerTests: XCTestCase {
    var handler: CalendarEventHandler!
    var earlyEvent: Event!
    var laterEvent: Event!
    var currentEvent: Event!
    let yesterday = Date().advanced(by: TimeInterval(-86400))
    let tomorrow = Date().advanced(by: TimeInterval(86400))
    
    override func setUp() {
        super.setUp()
        
        handler = CalendarEventHandler()
        
        earlyEvent = SampleEvents.makeEvent(on: yesterday)
        laterEvent = SampleEvents.makeEvent(on: tomorrow)
        currentEvent = SampleEvents.makeEvent(on: Date())
    }
    
    override func tearDown() {
        handler = nil
        earlyEvent = nil
        laterEvent = nil
        currentEvent = nil
    }
    
    func testAddEventsFromArray() {
        handler.addEventsFromArray([currentEvent], Date())
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
    }
    
    func testGetEventsForFutureDateWithEvents() {
        let event = SampleEvents.makeEvent(on: tomorrow)
        handler.addEventsFromArray([event], tomorrow)
        
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [event])
    }
    
    func testGetEventsForFutureDateWithEmptyEvents() {
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
    }
    
    func testGetEventsForPastDate() {
        let event = SampleEvents.makeEvent(on: yesterday)
        handler.addEventsFromArray([event], yesterday)

        XCTAssertEqual(handler.getEventsForDate(yesterday), [event])
    }
    
    func testGetEventsForPastDateWithEmptyEvents() {
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
    }
    
    func testGetEventsForCurrentDate() {
        let event = SampleEvents.makeEvent(on: Date())
        handler.addEventsFromArray([event], Date())

        XCTAssertEqual(handler.getEventsForDate(Date()), [event])
    }
    
    func testGetEventsForDateWithEmptyEvents() {
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
    }
    
    func testGetEventsWithMultipleDates() {
        handler.addEventsFromArray([earlyEvent], yesterday)
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
        
        handler.addEventsFromArray([laterEvent], tomorrow)

        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [laterEvent])
    }
    
    func testGetEventThatStartsOnPreviousDay() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addNewEvent(longEvent)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
        
        handler.addEventsFromArray([longEvent], Date())
        XCTAssertEqual(handler.getEventsForDate(Date()), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
    }
    
    func testAddEventSpanningMultipleDays() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addEventsFromArray([currentEvent], Date())
        handler.addEventsFromArray([earlyEvent], yesterday)
        handler.addEventsFromArray([], tomorrow)
        handler.addNewEvent(longEvent)
        
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent, longEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent, longEvent])
    }
    
    func testAddNewEventToNewDate() {
        handler.addEventsFromArray([currentEvent], Date())
        handler.addNewEvent(earlyEvent)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
    }
    
    func testAddNewEventToExistingDate() {
        let secondEarlyEvent = SampleEvents.makeEvent(on: yesterday)
        let thirdEarlyEvent = SampleEvents.makeEvent(on: yesterday)
        handler.addEventsFromArray([earlyEvent, secondEarlyEvent], yesterday)
        handler.addNewEvent(thirdEarlyEvent)
        
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent, secondEarlyEvent, thirdEarlyEvent])
    }
    
    func testDeleteNonExistingEvent() {
        let event = Event()
        handler.addEventsFromArray([], yesterday)
        handler.addEventsFromArray([currentEvent], Date())
        handler.deleteEvent(event)
        handler.deleteEvent(earlyEvent)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
    }
    
    func testDeleteExistingEvent() {
        handler.addEventsFromArray([currentEvent], Date())
        handler.deleteEvent(currentEvent)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
    }
    
    func testDeleteEventTwice() {
        handler.addEventsFromArray([currentEvent], Date())
        handler.deleteEvent(currentEvent)
        
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
        
        handler.deleteEvent(currentEvent)
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
    }
    
    func testDeleteEventSpanningMultipleDays() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addEventsFromArray([], yesterday)
        handler.addEventsFromArray([], Date())
        handler.addEventsFromArray([], tomorrow)
        
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
        
        handler.addNewEvent(longEvent)
        XCTAssertEqual(handler.getEventsForDate(yesterday), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(Date()), [longEvent])
        
        handler.deleteEvent(longEvent)
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
    }
    
    func testDeleteLongEventWithUnfetchedDates() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addEventsFromArray([], Date())
        handler.addEventsFromArray([], tomorrow)
        handler.addNewEvent(longEvent)
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(Date()), [longEvent])
        
        handler.deleteEvent(longEvent)
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
    }
    
    func testDeleteMultipleEvents() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addEventsFromArray([currentEvent, longEvent], Date())
        handler.addEventsFromArray([earlyEvent, longEvent], yesterday)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent, longEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent, longEvent])
        
        handler.deleteEvent(currentEvent)
        XCTAssertEqual(handler.getEventsForDate(Date()), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent, longEvent])
        
        handler.deleteEvent(longEvent)
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent])
    }
    
    func testAddEventAfterDelete() {
        let event = Event()
        handler.addEventsFromArray([currentEvent, event], Date())
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent, event])
        handler.deleteEvent(currentEvent)
        XCTAssertEqual(handler.getEventsForDate(Date()), [event])

        handler.addNewEvent(currentEvent)
        XCTAssertEqual(handler.getEventsForDate(Date()), [event, currentEvent])
    }
    
    func testUpdateEvent() {
        handler.addEventsFromArray([currentEvent], Date())
        let originalStart = currentEvent.startDate
        let originalEnd = currentEvent.endDate
        
        currentEvent.eventTitle = "hi"
        handler.updateEvent(currentEvent, originalStart, originalEnd)
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
    }
    
    func testUpdateNonexistentEvent() {
        handler.addEventsFromArray([], Date())
        let originalStart = currentEvent.startDate
        let originalEnd = currentEvent.endDate
        
        handler.updateEvent(currentEvent, originalStart, originalEnd)
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
    }
    
    func testUpdateEventToNewDate() {
        handler.addEventsFromArray([currentEvent], Date())
        handler.addEventsFromArray([], tomorrow)
        let originalStart = currentEvent.startDate
        let originalEnd = currentEvent.endDate
        
        currentEvent.startDate = currentEvent.startDate.advanced(by: TimeInterval(86400))
        currentEvent.endDate = currentEvent.endDate.advanced(by: TimeInterval(86400))
        handler.updateEvent(currentEvent, originalStart, originalEnd)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [currentEvent])
    }
    
    func testUpdateEventToNonexistingDate() {
        handler.addEventsFromArray([currentEvent], Date())
        let originalStart = currentEvent.startDate
        let originalEnd = currentEvent.endDate
        
        currentEvent.startDate = currentEvent.startDate.advanced(by: TimeInterval(86400))
        currentEvent.endDate = currentEvent.endDate.advanced(by: TimeInterval(86400))
        handler.updateEvent(currentEvent, originalStart, originalEnd)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
    }
    
    func testUpdateEventToMultipleDayEvent() {
        handler.addEventsFromArray([currentEvent], Date())
        handler.addEventsFromArray([], tomorrow)
        let originalStart = currentEvent.startDate
        let originalEnd = currentEvent.endDate
        
        currentEvent.endDate = currentEvent.endDate.advanced(by: TimeInterval(86400))
        handler.updateEvent(currentEvent, originalStart, originalEnd)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [currentEvent])
        
        handler.addEventsFromArray([], yesterday)
        currentEvent.startDate = currentEvent.startDate.advanced(by: TimeInterval(-86400))
        handler.updateEvent(currentEvent, originalStart, currentEvent.endDate)
        
        XCTAssertEqual(handler.getEventsForDate(yesterday), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [currentEvent])
    }
    
    func testUpdateEventFromMultipleDayEvent() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addEventsFromArray([longEvent], Date())
        handler.addEventsFromArray([longEvent], tomorrow)
        handler.addEventsFromArray([longEvent], yesterday)
        
        let originalStart = longEvent.startDate
        let originalEnd = longEvent.endDate
        
        longEvent.startDate = Date()
        longEvent.endDate = Date().advanced(by: 3600)
        handler.updateEvent(longEvent, originalStart, originalEnd)
        
        XCTAssertEqual(handler.getEventsForDate(Date()), [longEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [])
    }
    
    func testUpdateMultipleEvents() {
        let longEvent = SampleEvents.makeEvent(on: yesterday, withDays: 2, withHours: 3)
        handler.addEventsFromArray([longEvent, currentEvent], Date())
        handler.addEventsFromArray([longEvent, laterEvent], tomorrow)
        handler.addEventsFromArray([longEvent, earlyEvent], yesterday)
        
        let longOriginalStart = longEvent.startDate
        let longOriginalEnd = longEvent.endDate
        longEvent.startDate = tomorrow
        longEvent.endDate = tomorrow.advanced(by: TimeInterval(3600))
        handler.updateEvent(longEvent, longOriginalStart, longOriginalEnd)
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [laterEvent, longEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [earlyEvent])
        
        let earlyOriginalStart = earlyEvent.startDate
        let earlyOriginalEnd = earlyEvent.endDate
        earlyEvent.startDate = tomorrow
        earlyEvent.endDate = tomorrow.advanced(by: TimeInterval(3600))
        handler.updateEvent(earlyEvent, earlyOriginalStart, earlyOriginalEnd)
        XCTAssertEqual(handler.getEventsForDate(Date()), [currentEvent])
        XCTAssertEqual(handler.getEventsForDate(tomorrow), [laterEvent, longEvent, earlyEvent])
        XCTAssertEqual(handler.getEventsForDate(yesterday), [])
    }
}
