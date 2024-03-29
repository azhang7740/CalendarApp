//
//  ParseEventBuilder.h
//  Calendar
//
//  Created by Angelina Zhang on 7/7/22.
//

#import <Foundation/Foundation.h>
#import "CalendarApp-Swift.h"
#import "ParseEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParseEventBuilder : NSObject

- (Event *)getEventFromParseEvent:(PFObject *)parseEvent;
- (NSMutableArray<Event *> *)getEventsFromParseEventArray:(NSArray<PFObject *> *)parseEvents;

@end

NS_ASSUME_NONNULL_END
