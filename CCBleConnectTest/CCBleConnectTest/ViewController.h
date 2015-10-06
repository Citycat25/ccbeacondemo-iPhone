//
//  ViewController.h
//  CCBleConnectTest
//
//  Created by Yangwoong Kim on 2015. 8. 27..
//  Copyright (c) 2015년 Citycat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCBleConnect/CCBleConnect.h>

@interface ViewController : UIViewController <CCBleProcessDelegate, CCBleFinderDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView * tableview;
@property (weak, nonatomic) IBOutlet UIButton * btBeacon;
@property (weak, nonatomic) IBOutlet UIButton * btFinder;


- (IBAction)StartBeacon:(id)sender;
- (IBAction)StartFinder:(id)sender;

@end

