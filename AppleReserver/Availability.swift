//
//  Availability.swift
//  AppleReserver
//
//  Created by Sunnyyoung on 2017/9/19.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

import Foundation

struct Availability {
    let partNumber: String
    let contract: Bool
    let unlocked: Bool

    init(key: String, value: [String: [String: Bool]]) {
        self.partNumber = key
        self.contract = value["availability"]?["contract"] ?? false
        self.unlocked = value["availability"]?["unlocked"] ?? false
    }
}
