//
//  ParseEventHandler.m
//  Calendar
//
//  Created by Angelina Zhang on 7/7/22.
//

#import "ParseEventHandler.h"
#import "ParseEventBuilder.h"

@implementation ParseEventHandler

- (NSString *)getCurrentUsername {
    return [PFUser currentUser].username;
}

- (void)uploadWithEvent:(Event *)newEvent
             completion:(RemoteEventChangeCompletion)completion {
    ParseEvent *newParseEvent = [[ParseEvent alloc] init];
    newParseEvent.objectUUID = [newEvent.objectUUID UUIDString];
    newParseEvent.eventTitle = newEvent.eventTitle;
    newParseEvent.author = [PFUser currentUser];
    
    newParseEvent.eventDescription = newEvent.eventDescription;
    newParseEvent.location = newEvent.location;
    newParseEvent.startDate = newEvent.startDate;
    newParseEvent.endDate = newEvent.endDate;
    
    [newParseEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            newEvent.parseObjectId = newParseEvent.objectId;
            completion(true, nil);
        } else {
            completion(true, @"Failed to upload to Parse.");
        }
    }];
}

- (void)queryEventsOnDate:(NSDate *)date
                   completion:(EventQueryCompletion)completion {
    PFUser *currentUser = [PFUser currentUser];
    ParseEventBuilder *builder = [[ParseEventBuilder alloc] init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *midnight = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSDate *nextDate = [calendar dateByAddingComponents:dayComponent toDate:midnight options:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(startDate >= %@ AND startDate <= %@) OR (startDate < %@ AND endDate > %@)", midnight, nextDate, midnight, midnight];
    PFQuery *query = [PFQuery queryWithClassName:@"Event" predicate:predicate];
    query.limit = 20;

    [query orderByAscending:@"startDate"];
    [query includeKey:@"author"];
    [query includeKey:@"createdAt"];
    [query includeKey:@"updatedAt"];
    [query whereKey:@"author" equalTo:currentUser];

    [query findObjectsInBackgroundWithBlock:^(NSArray<ParseEvent *> *parseEvents, NSError *error) {
        if (parseEvents) {
            NSMutableArray<Event *> *queriedEvents = [builder getEventsFromParseEventArray:parseEvents];
            completion(true, queriedEvents, midnight, nil);
        } else {
            completion(false, nil, nil, @"Failed to query posts.");
        }
    }];
}

- (void)updateEvent:(Event *)event
                        completion:(RemoteEventChangeCompletion)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:event.parseObjectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            completion(false, @"Could not find the event.");
        } else {
            object[@"eventTitle"] = event.eventTitle;
            object[@"eventDescription"] = event.eventDescription;
            object[@"location"] = event.location;
            object[@"startDate"] = event.startDate;
            object[@"endDate"] = event.endDate;
            event.updatedAt = [NSDate date];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!succeeded) {
                    completion(false, @"Could not upload to Parse successfully.");
                } else {
                    completion(true, nil);
                }
            }];
        }
    }];
}

- (void)deleteEvent:(Event *)event
                        completion:(RemoteEventChangeCompletion)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:event.parseObjectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            completion(false, @"Could not find the event.");
        } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!succeeded) {
                    completion(false, @"Could not delete from Parse successfully.");
                } else {
                    completion(true, nil);
                }
            }];
        }
    }];
}

@end
