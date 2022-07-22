//
//  EventHandler.h
//  CalendarApp
//
//  Created by Angelina Zhang on 7/19/22.
//

#import <Foundation/Foundation.h>
#import "CalendarApp-Swift.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^EventQueryCompletion)(BOOL success, NSMutableArray<Event *> * _Nullable, NSDate * _Nullable, NSString * _Nullable);
typedef void (^RemoteEventChangeCompletion)(BOOL success, NSString * _Nullable);

@protocol EventHandler <NSObject>

- (void)queryEventsOnDate:(NSDate *)date
               completion:(EventQueryCompletion)completion;
- (void)uploadWithEvent:(Event *)newEvent
             completion:(RemoteEventChangeCompletion)completion;
- (void)updateEvent:(Event *)event
         completion:(RemoteEventChangeCompletion)completion;
- (void)deleteEvent:(Event *)event
         completion:(RemoteEventChangeCompletion)completion;

@end

@protocol RemoteEventUpdates <NSObject>

- (void)remoteEventsDidChange;

@end

NS_ASSUME_NONNULL_END
