//
//  AppDelegate.m
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "AppDelegate.h"
#import "Device.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)visibleWindows {
    NSWindow *window = theApplication.windows.firstObject;
    if (visibleWindows) {
        [window orderFront:nil];
    } else {
        [window makeKeyAndOrderFront:nil];
    }
    return YES;
}

@end
