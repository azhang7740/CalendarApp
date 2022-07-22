//
//  DetailsViewController.h
//  Calendar
//
//  Created by Angelina Zhang on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "ParseEventHandler.h"
#import "CalendarApp-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DetailsViewControllerDelegate

- (void)didTapClose;
- (void)didDeleteEvent:(Event *)event;
- (void)didUpdateEvent:(Event *)event
     originalStartDate:(NSDate *)startDate
       originalEndDate:(NSDate *)endDate;

@end

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) id<DetailsViewControllerDelegate> delegate;
@property (nonatomic) Event *event;

@end

NS_ASSUME_NONNULL_END
