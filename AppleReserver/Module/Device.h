//
//  Device.h
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface Device : NSObject

@property (nonatomic, copy) NSString *productDescription;
@property (nonatomic, copy) NSString *capacity;
@property (nonatomic, copy) NSString *productDisplayPrice;

+ (NSDictionary *)deviceDictionary;

@end
