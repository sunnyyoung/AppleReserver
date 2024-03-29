//
//  Request.swift
//  
//
//  Created by Sunny Young on 2021/9/18.
//

import Foundation
import Alamofire
import PromiseKit

struct Request {
    static func fetchStores(region: String, model: String) -> Promise<[Store]> {
        Promise { seal in
            AF.request(AppleURL.stores(of: region, model: model)).responseJSON { (response) in
                do {
                    if let error = response.error {
                        seal.reject(error)
                    } else {
                        let values = (response.value as? [String: Any])?["stores"]
                        let data = try JSONSerialization.data(withJSONObject: values ?? Data(), options: [])
                        let stores = try JSONDecoder().decode([Store].self, from: data)
                        seal.fulfill(stores)
                    }
                } catch {
                    seal.reject(error)
                }
            }
        }
    }

    static func fetchAvailabilities(region: String, model: String, storeNumber: String) -> Promise<[Availability]> {
        Promise { seal in
            AF.request(AppleURL.availability(of: region, model: model)).responseJSON { (response) in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    let stores = ((response.value as? [String: Any])?["stores"] as? [String: Any]) ?? [:]
                    let values = stores[storeNumber] as? [String: [String: [String: Bool]]] ?? [:]
                    let availabilities = values.compactMap({ Availability(key: $0.key, value: $0.value) })
                    seal.fulfill(availabilities)
                }
            }
        }
    }

    static func monitor(region: String, model: String, storeNumbers: [String], partNumbers: [String]) -> Promise<[(String, String)]> {
        Promise { seal in
            AF.request(AppleURL.availability(of: region, model: model)).responseJSON { (response) in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    var results: [(String, String)] = []
                    let stores = ((response.value as? [String: Any])?["stores"] as? [String: Any]) ?? [:]
                    for store in stores.filter({ storeNumbers.contains($0.key) }) {
                        guard let parts = store.value as? [String: [String: [String: Bool]]] else {
                            continue
                        }
                        for part in parts.filter({ partNumbers.contains($0.key) }) {
                            guard Availability(key: part.key, value: part.value).available else {
                                continue
                            }
                            results.append((store.key, part.key))
                        }
                    }
                    seal.fulfill(results)
                }
            }
        }
    }
}
