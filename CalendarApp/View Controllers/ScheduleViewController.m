//
//  ScheduleViewController.m
//  CalendarApp
//
//  Created by Angelina Zhang on 7/14/22.
//

#import "ScheduleViewController.h"
#import "DetailsViewController.h"
#import "ComposeViewController.h"

#import "CalendarApp-Swift.h"
#import "AuthenticationHandler.h"
#import "ParseEventHandler.h"
#import "EKEventHandler.h"
#import "CoreDataEventHandler.h"

@interface ScheduleViewController () <EventInteraction, DetailsViewControllerDelegate, ComposeViewControllerDelegate>

@property (nonatomic) DailyCalendarViewController* scheduleView;
@property (nonatomic) AuthenticationHandler *authenticationHandler;
@property (nonatomic) ParseEventHandler *parseHandler;
@property (nonatomic) EKEventHandler *ekEventHandler;
@property (nonatomic) NSMutableDictionary<NSUUID *, Event *> *objectIDToEvents;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scheduleView = [[DailyCalendarViewController alloc] init];
    self.scheduleView.controllerDelegate = self;
    self.parseHandler = [[ParseEventHandler alloc] init];
    self.ekEventHandler = [[EKEventHandler alloc] init];
    [self.ekEventHandler requestAccessToCalendarWithCompletion:^(BOOL success, NSString * _Nullable error) {
        if (error) {
            [self failedRequestWithMessage:error];
        }
    }];
    self.authenticationHandler = [[AuthenticationHandler alloc] init];
    self.objectIDToEvents = [[NSMutableDictionary alloc] init];
    
    [self addChildViewController:self.scheduleView];
    [self.view addSubview:self.scheduleView.view];
    [self.scheduleView didMoveToParentViewController:self];
    self.scheduleView.view.frame = self.view.bounds;
}

- (void)failedRequestWithMessage:(NSString *)errorMessage {
    // TODO: error handling
}

- (void)fetchEventsForDate:(NSDate *)date
                  callback:(void (^)(NSArray<Event *> * _Nullable, NSString * _Nullable))callback {
    [self.parseHandler queryEventsOnDate:date
                              completion:^(BOOL success, NSMutableArray<Event *> * _Nullable events, NSDate * _Nonnull date, NSString * _Nullable error) {
        if (error) {
            callback(nil, error);
        } else {
            for (Event *newEvent in events) {
                self.objectIDToEvents[newEvent.objectUUID] = newEvent;
            }
            callback(events, nil);
        }
    }];
}

- (void)didTapEvent:(NSUUID *)eventID {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Details" bundle:[NSBundle mainBundle]];
    UINavigationController *detailsNavigationController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailsNavigation"];
    DetailsViewController *detailsView = (DetailsViewController *)detailsNavigationController.topViewController;
    detailsView.event = self.objectIDToEvents[eventID];
    detailsView.delegate = self;
    [self presentViewController:detailsNavigationController animated:YES completion:nil];
}

- (void)didLongPressEvent:(NSUUID *)eventID {

}

- (void)didLongPressTimeline:(NSDate *)date {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Compose" bundle:[NSBundle mainBundle]];
    UINavigationController *composeNavigationController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"ComposeNavigation"];
    ComposeViewController *composeView = (ComposeViewController *)composeNavigationController.topViewController;
    composeView.delegate = self;
    composeView.currentUserName = [self.parseHandler getCurrentUsername];
    composeView.date = date;
    [self presentViewController:composeNavigationController animated:YES completion:nil];
}

- (void)didTapClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didDeleteEvent:(Event *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.scheduleView deleteCalendarEvent:event];
}

- (void)didUpdateEvent:(Event *)event
     originalStartDate:(NSDate *)startDate
       originalEndDate:(NSDate *)endDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *midnightStart = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:startDate options:0];
    NSDate *midnightEnd = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:endDate options:0];
    [self.scheduleView updateCalendarEvent:event originalStartDate:midnightStart originalEndDate:midnightEnd];
}

- (void)didTapCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTapLogout:(id)sender {
    [self.authenticationHandler logoutWithCompletion:^(NSString * _Nullable error) {
        if (error) {
            [self failedRequestWithMessage:error];
        }
    }];
}

- (IBAction)onTapAdd:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Compose" bundle:[NSBundle mainBundle]];
    UINavigationController *composeNavigationController = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"ComposeNavigation"];
    ComposeViewController *composeView = (ComposeViewController *)composeNavigationController.topViewController;
    composeView.delegate = self;
    composeView.currentUserName = [self.parseHandler getCurrentUsername];
    [self presentViewController:composeNavigationController animated:YES completion:nil];
}

- (void)didTapChangeEvent:(Event *)event
        originalStartDate:(NSDate *)startDate
          originalEndDate:(NSDate *)endDate {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.parseHandler uploadWithEvent:event completion:^(BOOL success, NSString * _Nullable error) {
        if (error) {
            [self failedRequestWithMessage:error];
        } else {
            self.objectIDToEvents[event.objectUUID] = event;
            [self.scheduleView addEvent:event];
        }
    }];
}

@end
