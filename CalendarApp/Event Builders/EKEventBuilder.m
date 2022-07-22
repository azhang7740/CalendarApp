//
//  EKEventBuilder.m
//  CalendarApp
//
//  Created by Angelina Zhang on 7/19/22.
//

#import "EKEventBuilder.h"

@implementation EKEventBuilder

- (Event *)getEventFromEKEvent:(EKEvent *)ekEvent {
    Event *canonicalEvent = [[Event alloc] init];
    if (!ekEvent.eventIdentifier ||
        !ekEvent.lastModifiedDate ||
        !ekEvent.creationDate) {
        return nil;
    }
    
    canonicalEvent.ekEventID = ekEvent.eventIdentifier;
    canonicalEvent.updatedAt = ekEvent.lastModifiedDate;
    canonicalEvent.createdAt = ekEvent.creationDate;
    
    if (!ekEvent.title ||
        ekEvent.title.length == 0) {
        return nil;
    }
    canonicalEvent.eventTitle = ekEvent.title;
    
    if (!ekEvent.organizer ||
        !ekEvent.organizer.name ||
        ekEvent.organizer.name.length == 0) {
        canonicalEvent.authorUsername = @"";
    } else {
        canonicalEvent.authorUsername = ekEvent.organizer.name;
    }
    
    if (!ekEvent.notes ||
        ekEvent.notes.length == 0) {
        canonicalEvent.eventDescription = @"";
    } else {
        canonicalEvent.eventDescription = ekEvent.notes;
    }
    
    if (!ekEvent.location ||
        ekEvent.location.length == 0) {
        canonicalEvent.location = @"";
    } else {
        canonicalEvent.location = ekEvent.location;
    }
    
    if (!ekEvent.startDate ||
        !ekEvent.endDate ||
        [ekEvent.startDate compare:ekEvent.endDate] != NSOrderedAscending) {
        return nil;
    }
    canonicalEvent.startDate = ekEvent.startDate;
    canonicalEvent.endDate = ekEvent.endDate;
    canonicalEvent.isAllDay = ekEvent.isAllDay;
    canonicalEvent.objectUUID = [[NSUUID alloc] init];
    canonicalEvent.color = [[UIColor alloc] initWithCGColor:ekEvent.calendar.CGColor];
    
    return canonicalEvent;
}

- (NSMutableArray<Event *> *)getEventsFromEKEventArray:(NSArray<EKEvent *> *)ekEvents {
    NSMutableArray<Event *> *canonicalEvents = [[NSMutableArray alloc] init];
    for (EKEvent *event in ekEvents) {
        [canonicalEvents addObject:[self getEventFromEKEvent:event]];
    }
    return canonicalEvents;
}

@end
