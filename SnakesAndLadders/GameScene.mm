//
//  GameScene.m
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/11/12.
//  Copyright (c) 2012 Pocket Gems. All rights reserved.
//

#import "GameScene.h"
#import "HelloWorldLayer.h"

@implementation GameScene

@synthesize layer = layer_;

+ (CCScene *) scene {
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init {
    if (self = [super init]) {
        self.layer = [GameLayer node];
        [self addChild:layer_];
    }
    return self;
}

- (void) dealloc {
    [layer_ release];
    layer_ = nil;
    [super dealloc];
}

@end

@implementation GameLayer

@synthesize isPlayersTurn = isPlayersTurn_;
@synthesize diceSprite = diceSprite_;
@synthesize rollValue = rollValue_;
@synthesize diceMenu = diceMenu_;
@synthesize userPic = userPic_;
@synthesize phonePic = phonePic_;
@synthesize phonePos = phonePos_;
@synthesize playerPos = playerPos_;
@synthesize diceMenuItem = diceMenuItem_;
@synthesize notifyLabel = notifyLabel_;
@synthesize isDieRolling = isDieRolling_;
@synthesize snakes = snakes_;
@synthesize ladders = ladders_;
@synthesize playerPawn = playerPawn_;
@synthesize phonePawn = phonePawn_;

- (id) init {
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *board = [CCSprite spriteWithFile:@"board1.png" rect:CGRectMake(0, 0, 290, 290)];
        board.position = ccp(winSize.width/2, winSize.height - (winSize.width/2 - board.contentSize.width/2) - board.contentSize.height/2);
        [self addChild:board];
        
        CCMenuItemImage *closeButton = [CCMenuItemImage itemWithNormalImage:@"close.png" selectedImage:@"closeSel.png" target:self selector:@selector(showCloseConfirmation)];
        CCMenu *closeMenu = [CCMenu menuWithItems:closeButton, nil];
        closeMenu.position = ccp(winSize.width - closeButton.contentSize.width/2, winSize.height - closeButton.contentSize.height/2);
        [self addChild:closeMenu];
        
        CCSprite *userPic;
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        if ([userData boolForKey:@"isUsingGravatar"]) {
            NSData *userImageData = [userData dataForKey:@"image"];
            UIImage *userImage = [[UIImage alloc] initWithData:userImageData];
            userPic = [CCSprite spriteWithCGImage:userImage.CGImage key:@"user-picture"];
            userPic.position = ccp(userPic.contentSize.width/2 + 30, userPic.contentSize.height/2 + 50);
            [self addChild:userPic];
        } else {
            userPic = [CCSprite spriteWithFile:@"pic-default-70.png" rect:CGRectMake(0, 0, 52, 70)];
            userPic.position = ccp(userPic.contentSize.width/2 + 30, userPic.contentSize.height/2 + 50);
            [self addChild:userPic];
        }
        userPic_ = userPic;
        
        CCSprite *phonePic = [CCSprite spriteWithFile:@"phone-70.png" rect:CGRectMake(0, 0, 38, 70)];
        phonePic.position = ccp(winSize.width - phonePic.contentSize.width/2 - 30, userPic.position.y);
        [self addChild:phonePic];
        phonePic_ = phonePic;
        
        CCSprite *dice = [CCSprite spriteWithFile:@"dice-60.png" rect:CGRectMake(0, 0, 66, 60)];
        CCMenuItemSprite *diceItem = [CCMenuItemSprite itemWithNormalSprite:dice selectedSprite:nil target:self selector:@selector(playerTurnRoll)];
        CCMenu *diceMenu = [CCMenu menuWithItems:diceItem, nil];
        diceMenu.position = ccp((userPic.position.x + phonePic.position.x)/2, userPic.position.y);
        [self addChild:diceMenu];
        diceSprite_ = dice;
        diceMenuItem_ = diceItem;
        diceMenu_ = diceMenu;
        rollValue_ = 1;
        isPlayersTurn_ = YES;
        phonePos_ = 0;
        playerPos_ = 0;
        isDieRolling_ = NO;
        [self initSnakes];
        [self initLadders];
        
        CCLabelTTF *notifyLabel = [CCLabelTTF labelWithString:@"Your Turn!" fontName:@"Chalkduster" fontSize:18];
        notifyLabel.color = ccc3(0, 153, 255);
        notifyLabel.position = ccp(board.position.x, board.position.y - board.contentSize.height/2 - notifyLabel.contentSize.height/2-10);
        [self addChild:notifyLabel];
        notifyLabel_ = notifyLabel;
        
        CCSprite *plPawn = [CCSprite spriteWithFile:@"blue.png" rect:CGRectMake(0, 0, 15, 15)];
        CCSprite *phPawn = [CCSprite spriteWithFile:@"green.png" rect:CGRectMake(0, 0, 15, 15)];
        [board addChild:plPawn];
        [board addChild:phPawn];
        plPawn.position = ccp(9, 9);
        phPawn.position = ccp(20, 20);
        playerPawn_ = plPawn;
        phonePawn_ = phPawn;
        
        NSLog(@"Game started");
    }
    return self;
}

- (void) initSnakes {
    self.snakes = [NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:21], [[NSNumber alloc] initWithInt:22],
                   [[NSNumber alloc] initWithInt:11], [[NSNumber alloc] initWithInt:31], 
                   [[NSNumber alloc] initWithInt:12], [[NSNumber alloc] initWithInt:36],
                   [[NSNumber alloc] initWithInt:17], [[NSNumber alloc] initWithInt:43],
                   [[NSNumber alloc] initWithInt:46], [[NSNumber alloc] initWithInt:58],
                   [[NSNumber alloc] initWithInt:41], [[NSNumber alloc] initWithInt:79],
                   [[NSNumber alloc] initWithInt:49], [[NSNumber alloc] initWithInt:91],
                   [[NSNumber alloc] initWithInt:10], [[NSNumber alloc] initWithInt:99],
                   nil];
}

- (void) initLadders {
    self.ladders = [NSDictionary dictionaryWithObjectsAndKeys:[[NSNumber alloc] initWithInt:15], [[NSNumber alloc] initWithInt:6],
                    [[NSNumber alloc] initWithInt:29], [[NSNumber alloc] initWithInt:11],
                    [[NSNumber alloc] initWithInt:43], [[NSNumber alloc] initWithInt:20],
                    [[NSNumber alloc] initWithInt:59], [[NSNumber alloc] initWithInt:41],
                    [[NSNumber alloc] initWithInt:75], [[NSNumber alloc] initWithInt:45],
                    [[NSNumber alloc] initWithInt:73], [[NSNumber alloc] initWithInt:50],
                    [[NSNumber alloc] initWithInt:93], [[NSNumber alloc] initWithInt:54],
                    [[NSNumber alloc] initWithInt:97], [[NSNumber alloc] initWithInt:62],
                    nil];
}

- (void) dealloc {
    [diceMenu_ release];
    [diceMenuItem_ release];
    [diceSprite_ release];
    [notifyLabel_ release];
    [userPic_ release];
    [phonePic_ release];
    diceMenuItem_ = nil;
    diceMenu_ = nil;
    diceSprite_ = nil;
    notifyLabel_ = nil;
    userPic_ = nil;
    phonePic_ = nil;
    [super dealloc];
}

- (void) updatePhonePos {
    int x = phonePos_ - 1;
    int row, col;
    row = (x /10 + 1)*29 - 20;
    if (row%2) {
        col = (x%10 + 1)*29 - 20;
    } else {
        col = [phonePawn_ parent].contentSize.width - (x%10)*29 - 20;
    }
    [phonePawn_ runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(col, row)]];
    phonePawn_.position = ccp(col, row);
}

- (void) updatePlayerPos {
    int x = playerPos_ - 1;
    int row, col;
    row = (x /10 + 1)*29 - 20;
    if (row%2) {
        col = (x%10 + 1)*29 - 20;
    } else {
        col = [playerPawn_ parent].contentSize.width - (x%10)*29 - 20;
    }
    [playerPawn_ runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(col, row)]];
    playerPawn_.position = ccp(col+12, row+12);
}

- (void) playerTurnRoll {
    [diceMenu_ setEnabled:NO];
    [self diceRoll];
}

- (void) phoneTurnRoll {
    [self runAction:[CCSequence actions:[[CCDelayTime alloc] initWithDuration:3],[CCCallFuncN actionWithTarget:self selector:@selector(diceRoll)],nil]];
}

- (void) playerTurnLogic {
    if (rollValue_ == 6) {
        [notifyLabel_ setString:@"6! Roll Again"];
        playerPos_ += rollValue_;
        [self updatePlayerPos];
        [diceMenu_ setEnabled:YES];
        isPlayersTurn_ = YES;
    } else {
        [notifyLabel_ setString:@"My Turn!"];
        playerPos_ += rollValue_;
        NSNumber *ladderEnd = [[NSNumber alloc] initWithInt:playerPos_];
        NSLog(@"%d", [(NSNumber *)[ladders_ objectForKey:ladderEnd] intValue]);
        if ([ladders_ objectForKey:ladderEnd]) {
            [notifyLabel_ setString:@"Wow! Ladder"];
            NSLog(@"Hit a ladder");
            playerPos_ = [ladders_[ladderEnd] intValue];
        }
        NSNumber *snakeEnd = [[NSNumber alloc] initWithInt:playerPos_];
        NSLog(@"%d", [ladderEnd intValue]);
        if ([snakes_ objectForKey:snakeEnd]) {
            [notifyLabel_ setString:@"Snake's belly stinks!"];
            NSLog(@"Hit a snake");
            playerPos_ = [snakeEnd intValue];
        }
        [self updatePlayerPos];
        [self phoneTurnRoll];
        isPlayersTurn_ = NO;
    }
}

- (void) phoneTurnLogic {
    if (rollValue_ == 6) {
        [notifyLabel_ setString:@"6! Rolling Again"];
        phonePos_ += rollValue_;
        [self updatePhonePos];
        [self phoneTurnRoll];
        isPlayersTurn_ = NO;
    } else {
        [notifyLabel_ setString:@"Your Turn!"];
        phonePos_ += rollValue_;
        NSNumber *ladderEnd = [[NSNumber alloc] initWithInt:phonePos_];
        NSLog(@"%d", [(NSNumber *)[ladders_ objectForKey:ladderEnd] intValue]);
        if ([ladders_ objectForKey:ladderEnd]) {
            [notifyLabel_ setString:@"Wow! Ladder"];
            NSLog(@"Hit a ladder");
            phonePos_ = [ladders_[ladderEnd] intValue];
        }
        NSNumber *snakeEnd = [[NSNumber alloc] initWithInt:phonePos_];
        NSLog(@"%d", [ladderEnd intValue]);
        if ([snakes_ objectForKey:snakeEnd]) {
            [notifyLabel_ setString:@"Snake's belly stinks!"];
            NSLog(@"Hit a snake");
            phonePos_ = [snakeEnd intValue];
        }
        [self updatePhonePos];
        [diceMenu_ setEnabled:YES];
        isPlayersTurn_ = YES;
    }
}

- (void) diceRoll {
    NSLog(@"Player position: %d, Phone position: %d", playerPos_, phonePos_);
    CCSprite *downArrow = [CCSprite spriteWithFile:@"arrow_down.png" rect:CGRectMake(0, 0, 24, 24)];
    downArrow.position = ccp((userPic_.position.x + phonePic_.position.x)/2, userPic_.position.y + diceSprite_.contentSize.height/2 + downArrow.contentSize.height/2);
    [self addChild:downArrow];
    int rValue = arc4random()%6 + 1;
    NSLog(@"rollValue: %d", rValue);
    int numOfRotations = arc4random() % 20 + 20;
    float delay1 = numOfRotations*0.15;
    float delay2 = (numOfRotations/8)*0.1;
    int angle = (rValue - 1) * 60 - (rollValue_ - 1)*60;
    [diceMenuItem_ runAction:[CCSequence actions:[[CCRotateBy alloc] initWithDuration:delay1 angle:numOfRotations*360 - angle], nil]];
    SEL logicMethod;
    if (isPlayersTurn_) {
        logicMethod = @selector(playerTurnLogic);
    } else {
        logicMethod = @selector(phoneTurnLogic);
    }
    [downArrow runAction:[CCSequence actions:[[CCDelayTime alloc] initWithDuration:delay1 + delay2 + 1],[CCCallFuncN actionWithTarget:downArrow selector:@selector(removeFromParentAndCleanup:)], [CCCallFuncN actionWithTarget:self selector:logicMethod], nil]];
    rollValue_ = rValue;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    if (buttonIndex) {
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    }
}

- (void) showCloseConfirmation {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to quit and go to main menu?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

@end
