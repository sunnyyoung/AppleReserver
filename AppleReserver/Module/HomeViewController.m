//
//  HomeViewController.m
//  AppleReserver
//
//  Created by Sunnyyoung on 16/9/19.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "HomeViewController.h"
#import "StoreRequest.h"
#import "AvailabilityRequest.h"
#import "Device.h"

@interface HomeViewController () <NSTableViewDataSource, NSTableViewDelegate>

// TableViews
@property (weak) IBOutlet NSTableView *storeTableView;
@property (weak) IBOutlet NSTableView *availabilityTableView;
// Buttons
@property (weak) IBOutlet NSButton *onlyAvailabilityButton;
@property (weak) IBOutlet NSButton *notificationButton;
@property (weak) IBOutlet NSPopUpButton *timerIntervalButton;
@property (weak) IBOutlet NSButton *fireButton;

// Properties
@property (nonatomic, copy) NSArray<Store *> *storeArray;
@property (nonatomic, copy) NSDictionary *deviceDictionary;
@property (nonatomic, copy) NSDictionary *availabilityDictionary;
@property (nonatomic, strong) NSMutableArray *selectedModelArray;

@property (nonatomic, strong) Store *selectedStore;
@property (nonatomic, strong) NSTimer *pollingTimer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadStoreAndDevice];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == self.storeTableView) {
        return self.storeArray.count;
    } else if (tableView == self.availabilityTableView) {
        return self.availabilityDictionary.count;
    } else {
        return 0;
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == self.storeTableView) {
        return self.storeArray[row].storeName;
    } else if (tableView == self.availabilityTableView) {
        NSString *model = self.availabilityDictionary.allKeys[row];
        Device *device = self.deviceDictionary[model];
        if ([tableColumn.identifier isEqualToString:@"Monitoring"]) {
            return @([self.selectedModelArray containsObject:model]);
        } else if ([tableColumn.identifier isEqualToString:@"Model"]) {
            return self.availabilityDictionary.allKeys[row];
        } else if ([tableColumn.identifier isEqualToString:@"Product"]) {
            return device.productDescription;
        } else if ([tableColumn.identifier isEqualToString:@"Capacity"]) {
            return device.capacity;
        }else if ([tableColumn.identifier isEqualToString:@"Status"]) {
            return [self.availabilityDictionary.allValues[row] isEqualToString:@"NONE"]?@"无货":@"有货";
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *model = self.availabilityDictionary.allKeys[row];
    [object boolValue]?[self.selectedModelArray addObject:model]:[self.selectedModelArray removeObject:model];
}

#pragma mark - Reload method

- (void)loadStoreAndDevice {
    self.deviceDictionary = [Device deviceDictionary];
    __weak typeof(self) weakSelf = self;
    [StoreRequest requestSuccess:^(NSArray<Store *> *storeArray) {
        weakSelf.storeArray = storeArray;
        [weakSelf.storeTableView reloadData];
    } failure:nil];
}

- (void)reloadAvailability {
    __weak typeof(self) weakSelf = self;
    [AvailabilityRequest requestWithType:self.onlyAvailabilityButton.state
                             storeNumber:self.selectedStore.storeNumber
                                 success:^(NSDictionary *availabilityDictionary) {
                                     weakSelf.availabilityDictionary = availabilityDictionary;
                                     [weakSelf.availabilityTableView reloadData];
                                     if (weakSelf.notificationButton.state) {
                                         [weakSelf checkAndMakeNotification];
                                     }
                                 } failure:nil];
}

- (void)checkAndMakeNotification {
    for (NSString *model in self.selectedModelArray) {
        if ([self.availabilityDictionary[model] isEqualToString:@"ALL"]) {
            Device *device = self.deviceDictionary[model];
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.informativeText = [NSString stringWithFormat:@"%@ 有货了！！！", device.productDescription];
            notification.soundName = NSUserNotificationDefaultSoundName;
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }
    }
}

#pragma mark - Event Response

- (IBAction)storeTableViewAction:(NSTableView *)sender {
    self.selectedStore = self.storeArray[sender.selectedRow];
    [self.selectedModelArray removeAllObjects];
    [self reloadAvailability];
}

- (IBAction)reverseAction:(NSTableView *)sender {
    NSString *store = self.selectedStore.storeNumber;
    NSString *model = self.availabilityDictionary.allKeys[sender.selectedRow];
    NSURL *reverseURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://reserve.cdn-apple.com/CN/zh_CN/reserve/iPhone/availability?channel=1&returnURL=&store=%@&partNumber=%@", store, model]];
    [[NSWorkspace sharedWorkspace] openURL:reverseURL];
}

- (IBAction)onlyAvailabilityButtonAction:(NSButton *)sender {
    [self reloadAvailability];
}

- (IBAction)fireButtonAction:(NSButton *)sender {
    NSTimeInterval interval = self.timerIntervalButton.titleOfSelectedItem.integerValue;
    if (self.pollingTimer.isValid) {
        sender.title = @"开始";
        self.storeTableView.enabled = YES;
        self.timerIntervalButton.enabled = YES;
        [self.pollingTimer invalidate];
        self.pollingTimer = nil;
    } else {
        sender.title = @"停止";
        self.storeTableView.enabled = NO;
        self.timerIntervalButton.enabled = NO;
        self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(reloadAvailability) userInfo:nil repeats:YES];
        [self.pollingTimer fire];
    }
}

#pragma mark - Property method

- (NSMutableArray *)selectedModelArray {
    if (_selectedModelArray == nil) {
        _selectedModelArray = [NSMutableArray array];
    }
    return _selectedModelArray;
}

@end
