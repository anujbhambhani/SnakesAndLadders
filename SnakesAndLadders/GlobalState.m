//
//  GlobalState.m
//  SnakesAndLadders
//
//  Created by Nitin Garg on 27/04/13.
//  Copyright (c) 2013 Pocket Gems. All rights reserved.
//

#import "GlobalState.h"

@implementation GlobalState

@synthesize betable = betable_;
@synthesize accessToken = accessToken_;

- (id)init
{
    self = [super init];
    if (self) {
        self.betable = [[Betable alloc] initWithClientID:@"Mi30hdcMejSG143o9V6yJUWUxJHSgUCd" clientSecret:@"JejebquSVZpYOi5l7xX0MiGoyYVuhJs3" redirectURI:@"snakesladders://authorize"];
    }
    return self;
}

- (void)dealloc
{
    self.accessToken = nil;
    self.betable = nil;
    [super dealloc];
}
@end
