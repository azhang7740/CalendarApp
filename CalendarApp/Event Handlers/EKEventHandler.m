//
//  EKEventHandler.m
//  CalendarApp
//
//  Created by Angelina Zhang on 7/19/22.
//

#import "EKEventHandler.h"
#import <Eventkit/EventKit.h>

@interface EKEventHandler ()

@property (nonatomic) EKEventStore *eventStore;

@end

@implementation EKEventHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

- (void)requestAccessToCalendarWithCompletion:(void (^ _Nonnull)(BOOL success, NSString * _Nullable error))completion {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (error) {
            completion(granted, @"Something went wrong.");
        } else {
            if (granted) {
                [self subscribeToNotifications];
            }
            completion(granted, nil);
        }
    }];
}

- (void)subscribeToNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(remoteEventsDidChange:)
                                               name:EKEventStoreChangedNotification
                                             object:self.eventStore];
}

- (void)deleteRemoteObjectWithEvent:(nonnull Event *)event
                         completion:(void (^ _Nonnull)(NSString * _Nullable))completion {
    
}

- (void)queryUserEventsOnDate:(nonnull NSDate *)date
                   completion:(void (^ _Nonnull)(NSMutableArray<Event *> * _Nullable, NSDate * _Nonnull, NSString * _Nullable))completion {
    
}

- (void)updateRemoteObjectWithEvent:(nonnull Event *)event
                         completion:(void (^ _Nonnull)(NSString * _Nullable))completion {
    
}

- (void)uploadWithEvent:(nonnull Event *)newEvent
             completion:(void (^ _Nonnull)(Event * _Nonnull, NSDate * _Nonnull, NSString * _Nullable))completion {
    
}

@end
