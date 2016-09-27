//
//  AvailabilityRequest.h
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

typedef NS_ENUM(NSUInteger, AvailabilityRequestType) {
    AvailabilityRequestTypeAll = 0,
    AvailabilityRequestTypeAvailable
};

@interface AvailabilityRequest : YTKRequest

+ (AvailabilityRequest *)requestWithType:(AvailabilityRequestType)type
                             storeNumber:(NSString *)storeNumber
                                 success:(void (^)(NSDictionary *availabilityDictionary))success
                                 failure:(void (^)(NSString *message))failure;

@end
