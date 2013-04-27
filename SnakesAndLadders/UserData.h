//
//  UserData.h
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/12/12.
//  Copyright (c) 2012 Pocket Gems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property BOOL isUsingGravatar;
@property (retain, nonatomic) NSData *image;
@property int coins;
@property int bestScore;
@property int launchCount;
@property (retain, nonatomic) NSString *name;

@end
