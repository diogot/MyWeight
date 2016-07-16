//
//  Bla.m
//  MyWeight
//
//  Created by Diogo Tridapalli on 7/15/16.
//  Copyright © 2016 Diogo Tridapalli. All rights reserved.
//

#import "Bla.h"

typedef void(^MyBlock)(void);

@interface Bla ()

@property (nonatomic) MyBlock block;

@end

@implementation Bla

- (instancetype)init
{
    self = [super init];
    if (self) {

        NSData *data = [NSData new];
        uint *ptr = (uint *)data.bytes;

        uint theme = 0;
        uint version = *ptr++;
        if (version == 1) {
            theme = *ptr++;
        }

    }
    return self;
}


@end
