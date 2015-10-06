//
//  CCDefaults.m
//  CCBleConnectTest
//
//  Created by Yangwoong Kim on 2015. 9. 29..
//  Copyright (c) 2015년 Citycat. All rights reserved.
//

#import "CCDefaults.h"

@implementation CCDefaults


- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"cc86b3c0-2bd1-413b-bf71-43e83c2f5bb1"],
                                     [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"],
                                     [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"]];
        _defaultPower = @-59;
    }
    
    return self;
}

+ (CCDefaults *)sharedDefaults
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSUUID *)defaultProximityUUID
{
    return [_supportedProximityUUIDs objectAtIndex:0];
}


@end
