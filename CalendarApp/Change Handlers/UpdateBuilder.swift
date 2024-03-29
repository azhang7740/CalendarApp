//
//  ChangeBuilder.swift
//  CalendarApp
//
//  Created by Angelina Zhang on 7/29/22.
//

import Foundation
import CoreData

@objc protocol CreateRevisionDelegate {
    func createUpdateRevision(changeField: ChangeField) -> Revision
}

@objcMembers
class UpdateBuilder : NSObject {
    private var oldEvent: Event
    private var newEvent: Event
    private var delegate: CreateRevisionDelegate
    
    public required init(firstEvent: Event,
                         updatedEvent: Event,
                         inputDelegate: CreateRevisionDelegate) {
        oldEvent = firstEvent
        newEvent = updatedEvent
        delegate = inputDelegate
    }
    
    public func checkFields() {
        for changeField in ChangeField.allCases {
            switch (changeField) {
            case .None:
                break
            case .Title:
                checkTitleChange()
                break
            case .Description:
                checkDescriptionChange()
                break
            case .Location:
                checkLocationChange()
                break
            case .StartDate:
                checkStartDateChange()
                break
            case .EndDate:
                checkEndDateChange()
                break
            case .isAllDay:
                checkIsAllDayChange()
                break
            }
        }
    }
    
    private func checkIsAllDayChange() {
        if oldEvent.isAllDay != newEvent.isAllDay {
            let revision = delegate.createUpdateRevision(changeField: .isAllDay)
            revision.changeField = .isAllDay
            revision.updatedField = newEvent.isAllDay ? "1" : "0"
        }
    }
    
    private func checkTitleChange() {
        if oldEvent.eventTitle != newEvent.eventTitle {
            let revision = delegate.createUpdateRevision(changeField: .Title)
            revision.changeField = .Title
            revision.updatedField = newEvent.eventTitle
        }
    }
    
    private func checkDescriptionChange() {
        if oldEvent.eventDescription != newEvent.eventDescription {
            let revision = delegate.createUpdateRevision(changeField: .Description)
            revision.changeField = .Description
            revision.updatedField = newEvent.eventDescription
        }
    }
    
    private func checkLocationChange() {
        if oldEvent.location != newEvent.location {
            let revision = delegate.createUpdateRevision(changeField: .Location)
            revision.changeField = .Location
            revision.updatedField = newEvent.location
        }
    }
    
    private func checkStartDateChange() {
        if oldEvent.startDate != newEvent.startDate {
            let revision = delegate.createUpdateRevision(changeField: .StartDate)
            revision.changeField = .StartDate
            let formatter = ISO8601DateFormatter()
            revision.updatedField = formatter.string(from: newEvent.startDate)
        }
    }
    
    private func checkEndDateChange() {
        if oldEvent.endDate != newEvent.endDate {
            let revision = delegate.createUpdateRevision(changeField: .EndDate)
            revision.changeField = .EndDate
            let formatter = ISO8601DateFormatter()
            revision.updatedField = formatter.string(from: newEvent.endDate)
        }
    }
}
