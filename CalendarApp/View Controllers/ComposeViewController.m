//
//  ComposeViewController.m
//  Calendar
//
//  Created by Angelina Zhang on 7/6/22.
//

#import "ComposeViewController.h"
#import "ComposeScrollView.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet ComposeScrollView *composeView;
@property (nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *createUpdateButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.event) {
        [self setViewEvent];
    } else {
        [self setViewDate];
    }
    
    if ([self.composeView.descriptionTextView.text  isEqual:@""]) {
        self.composeView.descriptionTextView.text = @"Type here...";
        self.composeView.descriptionTextView.textColor = UIColor.lightGrayColor;
    }
    
    self.composeView.descriptionTextView.delegate = self;
    
    self.composeView.errorLabel.text = @"";
}

- (void)setViewDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.hour = 1;
    if (!self.date) {
        self.date = [NSDate date];
    }
    self.composeView.startDatePicker.date = self.date;
    self.composeView.endDatePicker.date = [calendar dateByAddingComponents:dayComponent toDate:self.date options:0];
}

- (void)setViewEvent {
    self.composeView.titleTextField.text = self.event.eventTitle;
    self.composeView.startDatePicker.date = self.event.startDate;
    self.composeView.endDatePicker.date = self.event.endDate;
    
    self.composeView.locationTextField.text = self.event.location;
    self.composeView.descriptionTextView.text = self.event.eventDescription;
    
    [self.createUpdateButton setTitle:@"Update" forState:UIControlStateNormal];
}

- (Event *)createEventFromView {
    if (![self inputIsValid]) {
        return nil;
    }
    Event *newEvent = [[Event alloc] init];
    newEvent.objectUUID = [NSUUID UUID];
    newEvent.createdAt = [NSDate date];
    [self setEventFields:newEvent];
    
    return newEvent;
}

- (Event *)updateEventFromView {
    [self setEventFields:self.event];
    return self.event;
}

- (void)setEventFields:(Event *)newEvent {
    newEvent.eventTitle = self.composeView.titleTextField.text;
    
    newEvent.authorUsername = self.currentUserName;
    newEvent.location = self.composeView.locationTextField.text;
    newEvent.startDate = self.composeView.startDatePicker.date;
    newEvent.endDate = self.composeView.endDatePicker.date;
    newEvent.updatedAt = [NSDate date];
    
    if (self.composeView.descriptionTextView.textColor
        == UIColor.lightGrayColor) {
        newEvent.eventDescription = @"";
    } else {
        newEvent.eventDescription = self.composeView.descriptionTextView.text;
    }
}

- (BOOL)inputIsValid {
    if (self.composeView.titleTextField.text.length == 0) {
        [self displayErrorMessage:@"Title field is empty."];
        return false;
    }
    
    if ([self.composeView.startDatePicker.date compare:
         self.composeView.endDatePicker.date] != NSOrderedAscending) {
        [self displayErrorMessage:@"End date should be after start date."];
        return false;
    }
    
    return true;
}

- (void)displayErrorMessage:(NSString *)message {
    self.composeView.errorLabel.text = message;
}

- (IBAction)onTapCancel:(id)sender {
    [self.delegate didTapCancel];
}

- (IBAction)onTapCreate:(id)sender {
    if ([self.createUpdateButton.titleLabel.text isEqual:@"Create"]){
        Event *newEvent = [self createEventFromView];
        if (newEvent) {
            [self.delegate didTapChangeEvent:newEvent
                           originalStartDate:newEvent.startDate
                             originalEndDate:newEvent.endDate];
        }
    } else {
        NSDate *prevStartDate = self.event.startDate;
        NSDate *prevEndDate = self.event.endDate;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        NSDate *midnightStart = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:prevStartDate options:0];
        NSDate *midnightEnd = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:prevEndDate options:0];
        Event *updatedEvent = [self updateEventFromView];
        [self.delegate didTapChangeEvent:updatedEvent
                       originalStartDate:midnightStart
                         originalEndDate:midnightEnd];
    }
}

- (IBAction)onTapOutside:(id)sender {
    [self.view endEditing:true];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    BOOL isEmptyCaption = self.composeView.descriptionTextView.textColor == UIColor.lightGrayColor;
    if (isEmptyCaption) {
        self.composeView.descriptionTextView.text = nil;
        self.composeView.descriptionTextView.textColor = UIColor.blackColor;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    BOOL isEmptyCaption = [self.composeView.descriptionTextView.text length] == 0;
    if (isEmptyCaption) {
        self.composeView.descriptionTextView.text = @"Type here...";
        self.composeView.descriptionTextView.textColor = UIColor.lightGrayColor;
    }
}

@end
