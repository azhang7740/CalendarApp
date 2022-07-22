//
//  ComposeViewController.h
//  Calendar
//
//  Created by Angelina Zhang on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "CalendarApp-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTapCancel;
- (void)didTapChangeEvent:(Event *)event
        originalStartDate:(NSDate *)startDate
          originalEndDate:(NSDate *)endDate;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic) NSString *currentUserName;
@property (nonatomic) Event *event;
@property (nonatomic) NSDate *date;

@end

NS_ASSUME_NONNULL_END
