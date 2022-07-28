//
//  EventSyncHandler.h
//  CalendarApp
//
//  Created by Angelina Zhang on 7/22/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Event;

@interface EventSyncHandler : NSObject

- (void)didChangeEvent:(Event * _Nullable)oldEvent
          updatedEvent:(Event * _Nullable)newEvent;

@end

NS_ASSUME_NONNULL_END
