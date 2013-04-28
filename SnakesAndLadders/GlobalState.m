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

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text) {
        if ([textField superview].tag == 2) {
            [(UIAlertView *)[textField superview] dismissWithClickedButtonIndex:0 animated:YES];
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", @"currency",@"sandbox",@"economy",textField.text,@"wager", nil];
            [self.betable betForGame:@"q7Y25jgcUTCCxdnJqJs4dV" withData:data onComplete:^(NSDictionary *data) {
                NSLog(@"success");
                self.outcome = [data objectForKey:@"outcome"];
                self.payout = [data objectForKey:@"payout"];
                self.betPlaced = YES;
            } onFailure:^(NSURLResponse *response, NSString *responseBody, NSError *error) {
                NSLog(@"failure");
            }];            
        }
    }
}

- (void)placeBet {
    UIAlertView *betAmountAlert = [[UIAlertView alloc] initWithTitle:@"Place Bet" message:@"Enter bet amount" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    betAmountAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    betAmountAlert.tag = 2;
    [betAmountAlert textFieldAtIndex:0].delegate = self;
    [betAmountAlert show];
    [betAmountAlert release];
    }

@end
