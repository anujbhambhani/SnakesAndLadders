//
//  GlobalState.h
//  SnakesAndLadders
//
//  Created by Nitin Garg on 27/04/13.
//  Copyright (c) 2013 Pocket Gems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Betable/Betable.h>

@interface GlobalState : NSObject

@property (nonatomic, retain) Betable *betable;
@property (nonatomic, retain) NSString *accessToken;

@end
