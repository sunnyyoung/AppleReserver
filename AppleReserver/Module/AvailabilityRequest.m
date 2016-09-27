//
//  AvailabilityRequest.m
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "AvailabilityRequest.h"

@interface AvailabilityRequest ()

@property (nonatomic, assign) AvailabilityRequestType type;
@property (nonatomic, copy) NSString *storeNumber;

@end

@implementation AvailabilityRequest

- (instancetype)initWithType:(AvailabilityRequestType)type storeNumber:(NSString *)storeNumber {
    self = [super init];
    if (self) {
        self.type = type;
        self.storeNumber = storeNumber;
    }
    return self;
}

+ (AvailabilityRequest *)requestWithType:(AvailabilityRequestType)type storeNumber:(NSString *)storeNumber success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    AvailabilityRequest *request = [[AvailabilityRequest alloc] initWithType:type storeNumber:storeNumber];
    [request startWithCompletionBlockWithSuccess:^(__kindof AvailabilityRequest * _Nonnull request) {
        success?success(request.availabilityDictionary):nil;
    } failure:^(__kindof AvailabilityRequest * _Nonnull request) {
        failure?failure(request.error.localizedDescription):nil;
    }];
    return request;
}

- (NSString *)requestUrl {
    return @"https://reserve.cdn-apple.com/CN/zh_CN/reserve/iPhone/availability.json";
}

- (NSDictionary *)availabilityDictionary {
    NSMutableDictionary *allDictionary = [NSMutableDictionary dictionaryWithDictionary:self.responseJSONObject[self.storeNumber]];
    [allDictionary removeObjectForKey:@"timeSlot"];
    if (self.type == AvailabilityRequestTypeAvailable) {
        NSMutableDictionary *availabilityDictionary = [NSMutableDictionary dictionary];
        for (NSString *key in allDictionary.allKeys) {
            NSString *value = allDictionary[key];
            if ([value isKindOfClass:[NSString class]]) {
                if ([value isEqualToString:@"ALL"]) {
                    [availabilityDictionary setObject:value forKey:key];
                }
            }
        }
        return availabilityDictionary;
    } else {
        return allDictionary;
    }
}

@end
