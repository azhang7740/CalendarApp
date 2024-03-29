//
//  ParseChange.m
//  CalendarApp
//
//  Created by Angelina Zhang on 7/27/22.
//

#import "ParseChange.h"

@implementation ParseChange

@dynamic objectId;
@dynamic objectUUID;
@dynamic updatedAt;
@dynamic createdAt;

@dynamic timestamp;
@dynamic changeType;
@dynamic changeField;
@dynamic updatedField;

+ (nonnull NSString *)parseClassName {
    return @"RemoteChange";
}

@end
