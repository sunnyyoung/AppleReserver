//
//  MainViewController.swift
//  AppleReserver
//
//  Created by Sunnyyoung on 2017/9/19.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

import Cocoa
import Alamofire

class MainViewController: NSViewController {
    @IBOutlet weak var storeTableView: NSTableView!
    @IBOutlet weak var availabilityTableView: NSTableView!
    @IBOutlet weak var notificationButton: NSButton!
    @IBOutlet weak var timerIntervalButton: NSPopUpButton!
    @IBOutlet weak var fireButton: NSButton!
    @IBOutlet weak var indicator: NSProgressIndicator!

    fileprivate var products: [Product]?
    fileprivate var stores: [Store]?
    fileprivate var availabilities: [Availability]? {
        didSet {
            guard let availabilities = self.availabilities, self.notificationButton.state == NSOnState else {
                return
            }
            for selectedPartNumber in self.selectedPartNumbers {
                guard let availability = availabilities.first(where: { $0.partNumber == selectedPartNumber }),
                    availability.contract || availability.unlocked else {
                    return
                }
                let notification = NSUserNotification()
                notification.informativeText = "\(availability.partNumber) 有货啦！！！"
                notification.soundName = NSUserNotificationDefaultSoundName
                NSUserNotificationCenter.default.deliver(notification)
            }
        }
    }

    fileprivate var selectedStore: Store?
    fileprivate var selectedPartNumbers: Set<String> = []

    fileprivate var pollingTimer: Timer?
    fileprivate var reserveURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadProducts()
        self.loadStores()
    }

    // MARK: Load method
    func loadProducts() {
        guard let fileURL = Bundle.main.url(forResource: "Products", withExtension: "json") else {
            return
        }
        do {
            let fileData = try Data.init(contentsOf: fileURL)
            guard let json = try JSONSerialization.jsonObject(with: fileData, options: .mutableContainers) as? [String: Any] else {
                return
            }
            self.products = (json["products"] as? [[String: Any]])?.flatMap({ Product(json: $0) })
        } catch {
            NSAlert(error: error).runModal()
        }
    }

    func loadStores() {
        Alamofire.request(AppleURL.stores).responseJSON { (response) in
            if let error = response.error {
                NSAlert(error: error).runModal()
            } else {
                guard let json = response.value as? [String: Any],
                    let stores = (json["stores"] as? [[String: Any]])?.map({ Store(json: $0) }) else {
                    return
                }
                self.stores = stores
                self.storeTableView.reloadData()
            }
        }
    }

    func reloadAvailability() {
        Alamofire.request(AppleURL.availability).responseJSON { (response) in
            if let error = response.error {
                NSAlert(error: error).runModal()
            } else {
                guard let storeNumber = self.selectedStore?.storeNumber,
                    let json = response.value as? [String: Any],
                    let stores = json["stores"] as? [String: Any],
                    let availabilities = (stores[storeNumber] as? [String: [String: [String: Bool]]])?.map({ Availability(key: $0.key, value: $0.value) }) else {
                    return
                }
                self.availabilities = availabilities
                self.availabilityTableView.reloadData()
            }
        }
    }

    // MARK: Event method
    @IBAction func fireAction(_ sender: NSButton) {
        let interval = Double(self.timerIntervalButton.titleOfSelectedItem ?? "3") ?? 3.0
        if self.pollingTimer?.isValid == true {
            sender.title = "开始"
            self.storeTableView.isEnabled = true
            self.timerIntervalButton.isEnabled = true
            self.indicator.stopAnimation(sender)
            self.pollingTimer = {
                self.pollingTimer?.invalidate()
                return nil
            }()
        } else {
            sender.title = "停止"
            self.storeTableView.isEnabled = false
            self.timerIntervalButton.isEnabled = false
            self.indicator.startAnimation(sender)
            self.pollingTimer = {
                let timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(reloadAvailability), userInfo: nil, repeats: true)
                timer.fire()
                return timer
            }()
        }
    }

    @IBAction func reserveAction(_ sender: NSTableView) {
        guard let url = self.reserveURL, sender.selectedRow >= 0 else {
            return
        }
        NSWorkspace.shared().open(url)
    }
}

extension MainViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.storeTableView {
            return self.stores?.count ?? 0
        } else if tableView == self.availabilityTableView {
            return self.availabilities?.count ?? 0
        } else {
            return 0
        }
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableView == self.storeTableView {
            return self.stores?[row].storeName
        } else if tableView == self.availabilityTableView {
            guard let identifier = tableColumn?.identifier,
                let availability = self.availabilities?[row],
                let product = self.products?.first(where: { $0.partNumber == availability.partNumber }) else {
                return nil
            }
            switch identifier {
            case "Monitoring":
                return self.selectedPartNumbers.contains(availability.partNumber)
            case "PartNumber":
                return availability.partNumber
            case "Description":
                return product.description
            case "Capacity":
                return product.capacity
            case "Status":
                return (availability.contract || availability.unlocked) ? "有货" : "无货"
            default:
                return nil
            }
        } else {
            return nil
        }
    }

    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        guard let partNumber = self.availabilities?[row].partNumber, let selected = object as? Bool else {
            return
        }
        if selected {
            self.selectedPartNumbers.insert(partNumber)
        } else {
            self.selectedPartNumbers.remove(partNumber)
        }
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView, tableView.selectedRow >= 0 else {
            return
        }
        if tableView == self.storeTableView {
            self.selectedStore = self.stores?[tableView.selectedRow]
            self.selectedPartNumbers.removeAll()
            self.availabilityTableView.deselectAll(nil)
            self.reloadAvailability()
        } else if tableView == self.availabilityTableView {
            guard let storeNumber = self.selectedStore?.storeNumber,
                let partNumber = self.availabilities?[tableView.selectedRow].partNumber else {
                return
            }
            self.reserveURL = URL(string: "https://reserve-prime.apple.com/CN/zh_CN/reserve/iPhone/availability?channel=1&returnURL=&store=\(storeNumber)&partNumber=\(partNumber)")
        }
    }
}
