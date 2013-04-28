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
@synthesize outcome = outcome_;
@synthesize payout = payout_;

- (id)init
{
    self = [super init];
    if (self) {
        self.betable = [[Betable alloc] initWithClientID:@"Mi30hdcMejSG143o9V6yJUWUxJHSgUCd" clientSecret:@"JejebquSVZpYOi5l7xX0MiGoyYVuhJs3" redirectURI:@"snakesladders://authorize"];
        self.betPlaced = NO;
    }
    return self;
}

- (void)dealloc
{
    self.accessToken = nil;
    self.betable = nil;
    self.payout = nil;
    self.outcome = nil;
    [super dealloc];
}

- (void)placeBet {
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", @"currency",@"sandbox",@"economy",@"1.00",@"wager", nil];
    [self.betable betForGame:@"q7Y25jgcUTCCxdnJqJs4dV" withData:data onComplete:^(NSDictionary *data) {
        NSLog(@"success");
        self.outcome = [data objectForKey:@"outcome"];
        self.payout = [data objectForKey:@"payout"];
        self.betPlaced = YES;
    } onFailure:^(NSURLResponse *response, NSString *responseBody, NSError *error) {
        NSLog(@"failure");
    }];
}

@end
