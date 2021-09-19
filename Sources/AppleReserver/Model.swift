//
//  Model.swift
//  
//
//  Created by Sunny Young on 2021/9/18.
//

import Foundation

struct Availability: Codable {
    let partNumber: String
    let available: Bool

    init(key: String, value: [String: [String: Bool]]) {
        self.partNumber = key
        if let availability = value["availability"] {
            self.available = availability["contract"] == true || availability["unlocked"] == true
        } else {
            self.available = false
        }
    }
}

struct Device: Codable {
    let partNumber: String
    let description: String
}

struct Product: Codable {
    let partNumber: String
    let description: String
    let capacity: String
    let price: String
}

struct Store: Codable {
    let enabled: Bool
    let city: String
    let storeNumber: String
    let storeName: String
}
