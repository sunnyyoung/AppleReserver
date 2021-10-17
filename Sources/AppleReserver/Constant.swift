//
//  Constant.swift
//  
//
//  Created by Sunny Young on 2021/9/18.
//

import Foundation

public struct AppleURL {
    static func stores(of region: String, model: String) -> URL {
        return URL(string: "https://reserve-prime.apple.com/\(region)/zh_\(region)/reserve/\(model)/stores.json")!
    }

    static func availability(of region: String, model: String) -> URL {
        return URL(string: "https://reserve-prime.apple.com/\(region)/zh_\(region)/reserve/\(model)/availability.json")!
    }

    static func reserve(of region: String, model: String, store: String, part: String) -> URL {
        return URL(string: "https://reserve-prime.apple.com/\(region)/zh_\(region)/reserve/\(model)/availability?iUP=N&appleCare=N&rv=0&store=\(store)&partNumber=\(part)")!
    }
}
