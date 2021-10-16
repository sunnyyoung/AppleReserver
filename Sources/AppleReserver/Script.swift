//
//  Script.swift
//
//
//  Created by Sunny Young on 2021/9/19.
//

import Foundation
import PromiseKit

struct Script {
    @discardableResult
    static func execute(command: String) -> Promise<Void> {
        Promise { seal in
            do {
                var error: NSDictionary?
                guard let script = NSAppleScript(source: "do shell script \"\(command)\"") else {
                    throw NSError(domain: "applereserver", code: -1, userInfo: [NSLocalizedDescriptionKey: "Create script failed."])
                }
                script.executeAndReturnError(&error)
                if let error = error {
                    throw NSError(domain: "applereserver", code: -1, userInfo: [NSLocalizedDescriptionKey: "Execute script failed with error \(error)."])
                } else {
                    seal.fulfill(())
                }
            } catch {
                seal.reject(error)
            }
        }
    }
}
