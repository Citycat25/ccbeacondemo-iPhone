//
//  ViewController.m
//  CCBleConnectTest
//
//  Created by Yangwoong Kim on 2015. 8. 27..
//  Copyright (c) 2015년 Citycat. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CCDefaults.h"

@interface ViewController ()
{
    NSMutableDictionary *_beacons;
    NSMutableArray * _rangedRegions;
}

@property (nonatomic, retain) CCBleProcess * ccble;
@property (nonatomic, retain) CCBleFinder * ccFinder;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    // Start ranging when the view appears.
    // [self.ccFinder StartCCFinder:_rangedRegions];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Stop ranging when the view goes away.
    [self.ccFinder StopCCFinder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _beacons = [[NSMutableDictionary alloc] init];
    
    
    
    // Beacon Finder
    self.ccFinder = [[CCBleFinder alloc] init];
    self.ccFinder.delegate = self;
    [self.ccFinder initCCFinder];
    
    _rangedRegions = [NSMutableArray array];
    [[CCDefaults sharedDefaults].supportedProximityUUIDs enumerateObjectsUsingBlock:^(id uuidObj, NSUInteger uuidIdx, BOOL *uuidStop) {
        NSUUID *uuid = (NSUUID *)uuidObj;
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        [_rangedRegions addObject:region];
    }];
    
    
    
    // Virtual Beacon
    self.ccble = [[CCBleProcess alloc] init];
    self.ccble.delegate = self;
}

-(void) dealloc
{
    self.ccble = nil;
    self.ccFinder = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma Beacon Finder
- (IBAction)StartFinder:(id)sender
{
    // Start ranging when the view appears.
    [self.ccFinder StartCCFinder:_rangedRegions];
}





#pragma Finder Delegate
- (void)didDiscoverBeacon:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    // 거리등 계속 된 비콘에 상황을 확인하려면 StopCCFinder 사용 금지
    // [self.ccFinder StopCCFinder];
    
    // List View
    for(CLBeacon *b in beacons)
    {
        NSLog(@"Find Beacon %@, %@, %@", b.proximityUUID.UUIDString, b.major, b.minor);
    }
    
    [_beacons removeAllObjects];
    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityUnknown]];
    if([unknownBeacons count])
        [_beacons setObject:unknownBeacons forKey:[NSNumber numberWithInt:CLProximityUnknown]];
    
    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityImmediate]];
    if([immediateBeacons count])
        [_beacons setObject:immediateBeacons forKey:[NSNumber numberWithInt:CLProximityImmediate]];
    
    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityNear]];
    if([nearBeacons count])
        [_beacons setObject:nearBeacons forKey:[NSNumber numberWithInt:CLProximityNear]];
    
    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", CLProximityFar]];
    if([farBeacons count])
        [_beacons setObject:farBeacons forKey:[NSNumber numberWithInt:CLProximityFar]];
    
    [self.tableview reloadData];

    
}

- (void)didstate:(int)code Msg:(NSString *)msg data:(NSData *)data
{
    NSLog(msg);
    
    switch (code) {
        case 50:
        {
            // Connect
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:@"CCBeacon" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil,nil];
            [alertView setMessage:@"Connected"];
            [alertView show];
            break;
        }
        case 51:
        {
            // Disconnect
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:@"CCBeacon" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            [alertView setMessage:@"Disconnected"];
            [alertView show];
            break;
        }
        case 80:
        {
            // Rev Data
            break;
        }
        case 90:
            // Only Msg
            break;
            
        default:
            break;
    }
}









#pragma Virtual Beacon
- (IBAction)StartBeacon:(id)sender
{
    
    if([self.ccble is_CCBeaconState] == NO)
    {
        [self.ccble initStartCCBeacon: [[NSUUID alloc] initWithUUIDString:@"cc86b3c0-2bd1-413b-bf71-43e83c2f5bb1"]
                                Major:[NSNumber numberWithUnsignedShort:0xB001]
                                Minor:[NSNumber numberWithUnsignedShort:0xFFFF]
                        MeasuredPower:[NSNumber numberWithShort:-59]];
        
        [self.btBeacon setTitle:@"Stop Beacon" forState:UIControlStateNormal];
        
    }
    else
    {
        [self.ccble StopCCBeacon];
        [self.btBeacon setTitle:@"Start Beacon" forState:UIControlStateNormal];
    }
}

#pragma Beacon Delegate
- (NSData *)ccbleprocess_didReqReadData
{
    NSString *mainString = [NSString stringWithFormat:@"Hello DDLLDOLL"];
    
    return [mainString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)ccbleprocess_didRevData:(NSData *)data
{
    
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _beacons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionValues = [_beacons allValues];
    return [[sectionValues objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    NSArray *sectionKeys = [_beacons allKeys];
    
    // The table view will display beacons by proximity.
    NSNumber *sectionKey = [sectionKeys objectAtIndex:section];
    switch([sectionKey integerValue])
    {
        case CLProximityImmediate:
            title = @"Immediate";
            break;
            
        case CLProximityNear:
            title = @"Near";
            break;
            
        case CLProximityFar:
            title = @"Far";
            break;
            
        default:
            title = @"Unknown";
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Display the UUID, major, minor and accuracy for each beacon.
    NSNumber *sectionKey = [[_beacons allKeys] objectAtIndex:indexPath.section];
    CLBeacon *beacon = [[_beacons objectForKey:sectionKey] objectAtIndex:indexPath.row];
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@, Acc: %.2fm", beacon.major, beacon.minor, beacon.accuracy];
    
    return cell;
}



@end
