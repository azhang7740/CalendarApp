//
//  CoreDataEventBuilder.m
//  CalendarApp
//
//  Created by Angelina Zhang on 7/21/22.
//

#import "CoreDataEventBuilder.h"

@implementation CoreDataEventBuilder

- (Event *)getEventFromCoreDataEvent:(CoreDataEvent *)coreDataEvent {
    Event *canonicalEvent = [[Event alloc] init];
    if (!coreDataEvent.createdAt ||
        !coreDataEvent.updatedAt) {
        return nil;
    }
    canonicalEvent.parseObjectId = coreDataEvent.parseID;
    canonicalEvent.authorUsername = coreDataEvent.authorUsername;
    canonicalEvent.createdAt = coreDataEvent.createdAt;
    canonicalEvent.updatedAt = coreDataEvent.updatedAt;
    
    if (!coreDataEvent.objectUUID ||
        [coreDataEvent.objectUUID isEqual:[NSNull null]] ||
        ![coreDataEvent.objectUUID isKindOfClass:NSUUID.class]) {
        return nil;
    }
    canonicalEvent.objectUUID = coreDataEvent.objectUUID;
    
    if (!coreDataEvent.eventTitle ||
        [coreDataEvent.eventTitle isEqual:[NSNull null]] ||
        coreDataEvent.eventTitle.length == 0) {
        return nil;
    }
    canonicalEvent.eventTitle = coreDataEvent.eventTitle;
    canonicalEvent.eventDescription = coreDataEvent.eventDescription;
    canonicalEvent.location = coreDataEvent.location;
    
    if (!coreDataEvent.startDate ||
        !coreDataEvent.endDate ||
        [coreDataEvent.startDate compare:coreDataEvent.endDate] != NSOrderedAscending) {
        return nil;
    }
    canonicalEvent.startDate = coreDataEvent.startDate;
    canonicalEvent.endDate = coreDataEvent.endDate;
    return canonicalEvent;
}

- (NSMutableArray<Event *> *)getEventsFromCoreDataEventArray:(NSArray<CoreDataEvent *> *)coreDataEvents {
    NSMutableArray<Event *> *canonicalEvents = [[NSMutableArray alloc] init];
    for (CoreDataEvent *event in coreDataEvents) {
        [canonicalEvents addObject:[self getEventFromCoreDataEvent:event]];
    }
    return canonicalEvents;
}

@end
