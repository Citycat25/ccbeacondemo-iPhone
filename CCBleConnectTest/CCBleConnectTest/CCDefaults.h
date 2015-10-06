//
//  CCDefaults.h
//  CCBleConnectTest
//
//  Created by Yangwoong Kim on 2015. 9. 29..
//  Copyright (c) 2015년 Citycat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDefaults : NSObject

+ (CCDefaults *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;

@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;
@property (nonatomic, copy, readonly) NSNumber *defaultPower;

@end
