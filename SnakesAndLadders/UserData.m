//
//  UserData.m
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/12/12.
//  Copyright (c) 2012 Pocket Gems. All rights reserved.
//

#import "UserData.h"

@implementation UserData

@synthesize launchCount = launchCount_;
@synthesize isUsingGravatar = isUsingGravatar_;
@synthesize image = image_;
@synthesize coins = coins_;
@synthesize bestScore = bestScore_;
@synthesize name = name_;

- (id) init {
    if (self = [super init]) {
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        launchCount_ = [userData integerForKey:@"launchCount"];
        if (!launchCount_) {
            [userData setBool:NO forKey:@"isUsingGravatar"];
            [userData setInteger:10 forKey:@"coins"];
            [userData setInteger:0 forKey:@"bestScore"];
            [userData setObject:[[NSString alloc] initWithString:@"Player"] forKey:@"name"];
            [userData synchronize];
        }
        isUsingGravatar_ = [userData boolForKey:@"isUsingGravatar"];
        coins_ = [userData integerForKey:@"coins"];
        bestScore_ = [userData integerForKey:@"bestScore"];
        image_ = [[NSData alloc] initWithData:(NSData *) [userData objectForKey:@"image"]];
        name_ = [[NSString alloc] initWithString:(NSString *) [userData objectForKey:@"name"]];
    }
    return self;
}

- (void) dealloc {
    [image_ release];
    image_ = nil;
    [name_ release];
    name_ = nil;
    [super dealloc];
}

@end
