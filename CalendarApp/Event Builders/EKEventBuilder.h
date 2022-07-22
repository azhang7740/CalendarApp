//
//  EKEventBuilder.h
//  CalendarApp
//
//  Created by Angelina Zhang on 7/19/22.
//

#import <Foundation/Foundation.h>
#import "CalendarApp-Swift.h"
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EKEventBuilder : NSObject

- (Event *)getEventFromEKEvent:(EKEvent *)ekEvent;
- (NSMutableArray<Event *> *)getEventsFromEKEventArray:(NSArray<EKEvent *> *)ekEvents;

@end

NS_ASSUME_NONNULL_END
