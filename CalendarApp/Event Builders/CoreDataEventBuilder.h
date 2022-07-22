//
//  CoreDataEventBuilder.h
//  CalendarApp
//
//  Created by Angelina Zhang on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "CalendarApp-Swift.h"
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataEventBuilder : NSObject

- (Event *)getEventFromCoreDataEvent:(CoreDataEvent *)coreDataEvent;
- (NSMutableArray<Event *> *)getEventsFromCoreDataEventArray:(NSArray<CoreDataEvent *> *)coreDataEvents;

@end

NS_ASSUME_NONNULL_END
