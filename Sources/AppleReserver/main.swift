import Foundation
import Repeat
import Alamofire
import PromiseKit
import ArgumentParser

struct Stores: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "List all available stores.")

    @Option (name: .shortAndLong, help: "Region, eg: CN, MO")
    var region: String = "CN"

    @Option(name: .shortAndLong, help: "Model, A: iPhone 13 Pro Series; D: iPhone 13 Series")
    var model: String = "A"

    func run() throws {
        firstly {
            Request.fetchStores(region: region, model: model)
        }.done { stores in
            print(
                stores
                    .sorted(by: { $0.storeNumber < $1.storeNumber })
                    .map { "\($0.enabled ? "🟢" : "🔴")\t\($0.storeNumber)\t\($0.city)\t\($0.storeName)" }
                    .joined(separator: "\n")
            )
        }.catch { error in
            print(error)
        }.finally {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
    }
}

struct Availabilities: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "List all availabilities for the specific store.")

    @Option (name: .shortAndLong, help: "Region, eg: CN, MO")
    var region: String = "CN"

    @Argument (help: "Store Number, eg: R577")
    var storeNumber: String

    @Option(name: .shortAndLong, help: "Model, A: iPhone 13 Pro Series; D: iPhone 13 Series")
    var model: String = "A"

    func run() throws {
        firstly {
            Request.fetchAvailabilities(region: region, model: model, storeNumber: storeNumber)
        }.done { availabilities in
            print(
                availabilities
                    .sorted(by: { $0.partNumber < $1.partNumber })
                    .map { "\($0.available ? "🟢" : "🔴")\t\($0.partNumber)" }
                    .joined(separator: "\n")
            )
        }.catch { error in
            print(error)
        }.finally {
            CFRunLoopStop(CFRunLoopGetCurrent())
        }
    }
}

struct Monitor: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Monitor the availabilities for the specific stores and parts.")
    static var repeater: Repeater?
    static var count: UInt = 0

    @Option(name: .shortAndLong, help: "Refresh interval")
    var interval: UInt8 = 3

    @Option(name: .shortAndLong, help: "Region, eg: CN, MO")
    var region: String = "CN"

    @Option(name: .shortAndLong, help: "Model, A: iPhone 13 Pro Series; D: iPhone 13 Series")
    var model: String = "A"

    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Store numbers, eg: R577 R639")
    var storeNumbers: [String]

    @Option(name: .shortAndLong, parsing: .upToNextOption, help: "Part numbers, eg: MLTE3CH/A")
    var partNumbers: [String]

    func run() throws {
        Monitor.repeater = .every(.seconds(Double(interval))) { _ in
            firstly {
                Request.monitor(region: region, model: model, storeNumbers: storeNumbers, partNumbers: partNumbers)
            }.done { results in
                Monitor.count += 1
                if results.isEmpty {
                    print("\u{1B}[1A\u{1B}[KChecked for \(Monitor.count) times.")
                } else {
                    results.forEach { (store: String, part: String) in
                        let url = AppleURL.reserve(of: region, model: model, store: store, part: part)
                        print("🚨 [\(part)] 马上预约：\(url)")
                    }
                }
            }.catch { error in
                print(error)
            }
        }
        Monitor.repeater?.start()
    }
}

struct AppleReserver: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "applereserver",
        abstract: "Apple 官方预约监控助手",
        subcommands: [
            Stores.self,
            Availabilities.self,
            Monitor.self
        ],
        defaultSubcommand: Self.self
    )
}

AppleReserver.main()
CFRunLoopRun()
