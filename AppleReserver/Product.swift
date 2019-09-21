//
//  Product.swift
//  AppleReserver
//
//  Created by Sunnyyoung on 2017/9/19.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

import Foundation

struct Product: Codable {
    let partNumber: String
    let description: String
    let color: String
    let capacity: String
    let screenSize: String
    let price: String
    let installmentPrice: String
    let installmentPeriod: String
    let iUPPrice: String
    let iUPInstallments: String
    let colorSortOrder: String
    let swatchImage: URL
    let image: URL
    let contractEnabled: Bool
    let unlockedEnabled: Bool
    let groupID: String
    let groupName: String
    let subfamilyID: String
    let subfamily: String
}
