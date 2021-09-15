//
//  Store.swift
//  AppleReserver
//
//  Created by Sunnyyoung on 2017/9/19.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

import Foundation

struct Store: Codable {
    let storeNumber: String?
    let storeName: String?
    let city: String?
    let latitude: String?
    let longitude: String?
    let enabled: Bool
}
