//
//  Device.m
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "Device.h"

@implementation Device

+ (NSDictionary *)deviceDictionary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Devices" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *deviceDictionary = [NSMutableDictionary dictionary];
    for (NSDictionary *sku in json[@"skus"]) {
        Device *device = [Device mj_objectWithKeyValues:sku];
        [deviceDictionary setObject:device forKey:sku[@"part_number"]];
    }
    return deviceDictionary;
}

@end
