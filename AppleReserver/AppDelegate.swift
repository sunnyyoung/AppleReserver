//
//  AppDelegate.swift
//  AppleReserver
//
//  Created by Sunnyyoung on 2017/9/19.
//  Copyright © 2017年 Sunnyyoung. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let window = sender.windows.first
        if flag {
            window?.orderFront(sender)
        } else {
            window?.makeKeyAndOrderFront(sender)
        }
        return true
    }

}
