//
//  StoreRequest.h
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import <MJExtension/MJExtension.h>
#import "Store.h"

@interface StoreRequest : YTKRequest

+ (StoreRequest *)requestSuccess:(void (^)(NSArray<Store *> *storeArray))success failure:(void (^)(NSString *message))failure;

- (NSArray<Store *> *)storeArray;

@end
