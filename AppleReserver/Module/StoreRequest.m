//
//  StoreRequest.m
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "StoreRequest.h"

@implementation StoreRequest

+ (StoreRequest *)requestSuccess:(void (^)(NSArray<Store *> *))success failure:(void (^)(NSString *))failure {
    StoreRequest *request = [[StoreRequest alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof StoreRequest * _Nonnull request) {
        success?success(request.storeArray):nil;
    } failure:^(__kindof StoreRequest * _Nonnull request) {
        failure?failure(request.error.localizedDescription):nil;
    }];
    return request;
}

- (NSString *)requestUrl {
    return @"https://reserve.cdn-apple.com/CN/zh_CN/reserve/iPhone/stores.json";
}

- (NSArray<Store *> *)storeArray {
    return [Store mj_objectArrayWithKeyValuesArray:self.responseJSONObject[@"stores"]];
}

@end
