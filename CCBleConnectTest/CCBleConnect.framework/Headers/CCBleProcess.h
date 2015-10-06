//
//  CCBleProcess.h
//  CCBleConnect
//
//  Created by Yangwoong Kim on 2015. 8. 27..
//  Copyright (c) 2015년 Citycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCBleProcessDelegate <NSObject>

@optional
- (NSData *)ccbleprocess_didReqReadData;
- (void)ccbleprocess_didRevData:(NSData *)data;
@end


@interface CCBleProcess : NSObject


@property (nonatomic, assign) id <CCBleProcessDelegate> delegate;

- (void)initStartCCBeacon:(NSUUID *)uuid Major:(NSNumber*)major Minor:(NSNumber*)minor MeasuredPower:(NSNumber*)MEpower;
- (BOOL)StopCCBeacon;
- (BOOL)is_CCBeaconState;

@end
