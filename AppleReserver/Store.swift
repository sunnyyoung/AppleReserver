//
//  Store.swift
//  AppleReserver
//
//  Created by Sunnyyoung on 2017/9/19.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

import Foundation
import Alamofire

struct Store {
    let storeNumber: String?
    let storeName: String?
    let city: String?
    let latitude: String?
    let longitude: String?
    let enabled: Bool

    init(json: [String: Any]) {
        self.storeNumber = json["storeNumber"] as? String
        self.storeName = json["storeName"] as? String
        self.city = json["city"] as? String
        self.latitude = json["latitude"] as? String
        self.longitude = json["longitude"] as? String
        self.enabled = json["enabled"] as? Bool ?? false
    }
}
