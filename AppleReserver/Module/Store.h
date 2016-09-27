//
//  Store.h
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property (nonatomic, copy) NSString *storeNumber;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storeCity;
@property (nonatomic, assign) BOOL storeEnabled;
@property (nonatomic, assign) BOOL sellEdition;

@end
