//
//  CCBleFinder.h
//  CCBleConnect
//
//  Created by Yangwoong Kim on 2015. 8. 28..
//  Copyright (c) 2015년 Citycat. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@import CoreLocation;

@protocol CCBleFinderDelegate <NSObject>


@optional
- (void)didstate:(int)code Msg:(NSString *)msg data:(NSData *)data;
- (void)didDiscoverBeacon:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (void)didDiscoverDevice:(NSArray *)list;
@end

@interface CCBleFinder : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign) id <CCBleFinderDelegate> delegate;
- (BOOL)is_CCFinderState;
- (void)initCCFinder;
- (void)StartCCFinder:(NSArray *)rangedRegions;
- (void)StopCCFinder;
- (void)CCBeacon_Connect:(NSString *)strProximityKey;
- (void)CCBeacon_Disconnect;
- (void)CCBeacon_SendData:(NSData *)data;
- (void)CCBeacon_ReqReadData;

@end
