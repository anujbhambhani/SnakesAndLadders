//
//  GameScene.m
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/11/12.
//  Copyright (c) 2012 Pocket Gems. All rights reserved.
//

#import "GameScene.h"
#import "HelloWorldLayer.h"

#define FINAL_POSITION 65


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
//    [layer_ release];
//    layer_ = nil;
    [super dealloc];
}

@end

@interface GameLayer()
@property (nonatomic, retain) CCSprite *board;
@property (nonatomic, assign) int positionOfLadderToTake;

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
@synthesize emitter = emitter_;
@synthesize positionOfLadderToTake = positionOfLadderToTake_;

- (void)gameOver {
    [self.notifyLabel setString:@""];
    
    CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"You Won XYZ" fontName:@"Chalkduster" fontSize:18];
    winLabel.color = ccc3(0, 153, 255);
    winLabel.position = ccp(self.board.position.x, 280);
    [self.board addChild:winLabel];
    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"transparent.png"];
    [self.userPic setTexture:tex];
    [self.phonePic setTexture:tex];
    [self.diceSprite setTexture:tex];
    [self.playerPawn setTexture:tex];
    [self.phonePawn setTexture:tex];
    [self.board setTexture:tex];
    self.emitter = [[CCParticleExplosion alloc] init];
    self.emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"bitcoin_gold.png"];
    self.emitter.position = ccp(160,100);
    [self addChild:self.emitter z:1000];
    self.emitter1 = [[CCParticleFireworks alloc] init];
    self.emitter1.texture = [[CCTextureCache sharedTextureCache] addImage:@"bitcoin_gold.png"];
    self.emitter1.position = ccp(160,50);
    self.emitter1.startColorVar = (ccColor4F) {0.0f, 0.0f, 0.0f, 0.0f};
	self.emitter1.endColor = (ccColor4F) {255.0, 1.0, 1.0, 0.0f};
    self.emitter.startColorVar = (ccColor4F) {0.0f, 1.0f, 1.0f, 0.0f};
	self.emitter.endColor = (ccColor4F) {0.0, 1.0, 1.0, 0.0f};
    self.emitter1.angleVar = 20;
    self.emitter1.posVar = ccp(0,50);
	self.emitter1.scale = 1.2;
    [self addChild:self.emitter1 z:1000];
}

- (id) init {
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.board = [CCSprite spriteWithFile:@"board1.png" rect:CGRectMake(0, 0, 290, 290)];
        self.board.position = ccp(winSize.width/2, winSize.height - (winSize.width/2 - self.board.contentSize.width/2) - self.board.contentSize.height/2);
        [self addChild:self.board];
        
        CCMenuItemImage *closeButton = [CCMenuItemImage itemWithNormalImage:@"close.png" selectedImage:@"closeSel.png" target:self selector:@selector(showCloseConfirmation)];
        CCMenu *closeMenu = [CCMenu menuWithItems:closeButton, nil];
        closeMenu.position = ccp(winSize.width - closeButton.contentSize.width/2, winSize.height - closeButton.contentSize.height/2);
        [self addChild:closeMenu];
        
        
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        if ([userData boolForKey:@"isUsingGravatar"]) {
            NSData *userImageData = [userData dataForKey:@"image"];
            UIImage *userImage = [[UIImage alloc] initWithData:userImageData];
            self.userPic = [CCSprite spriteWithCGImage:userImage.CGImage key:@"user-picture"];
            self.userPic.position = ccp(self.userPic.contentSize.width/2 + 30, self.userPic.contentSize.height/2 + 50);
            [self addChild:self.userPic];
        } else {
            self.userPic = [CCSprite spriteWithFile:@"pic-default-70.png" rect:CGRectMake(0, 0, 52, 70)];
            self.userPic.position = ccp(self.userPic.contentSize.width/2 + 30, self.userPic.contentSize.height/2 + 50);
            [self addChild:self.userPic];
        }
        userPic_ = self.userPic;
        
        self.phonePic = [CCSprite spriteWithFile:@"phone-70.png" rect:CGRectMake(0, 0, 38, 70)];
        self.phonePic.position = ccp(winSize.width - self.phonePic.contentSize.width/2 - 30, self.userPic.position.y);
        [self addChild:self.phonePic];
        phonePic_ = self.phonePic;
        
        CCSprite *dice = [CCSprite spriteWithFile:@"dice-60.png" rect:CGRectMake(0, 0, 66, 60)];
        CCMenuItemSprite *diceItem = [CCMenuItemSprite itemWithNormalSprite:dice selectedSprite:nil target:self selector:@selector(playerTurnRoll)];
        CCMenu *diceMenu = [CCMenu menuWithItems:diceItem, nil];
        diceMenu.position = ccp((self.userPic.position.x + self.phonePic.position.x)/2, self.userPic.position.y);
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
        notifyLabel.position = ccp(self.board.position.x, self.board.position.y - self.board.contentSize.height/2 - notifyLabel.contentSize.height/2-10);
        [self addChild:notifyLabel];
        notifyLabel_ = notifyLabel;
        
        CCSprite *plPawn = [CCSprite spriteWithFile:@"blue.png" rect:CGRectMake(0, 0, 15, 15)];
        CCSprite *phPawn = [CCSprite spriteWithFile:@"green.png" rect:CGRectMake(0, 0, 15, 15)];
        [self.board addChild:plPawn];
        [self.board addChild:phPawn];
        plPawn.position = ccp(9, 9);
        phPawn.position = ccp(20, 20);
        playerPawn_ = plPawn;
        phonePawn_ = phPawn;
        
        NSLog(@"Game started");
        self.turnsTaken = 1;
    }
    return self;
}



- (NSNumber *)getPositionOfLadderFromTheLaddersTillFinalPosition:(int)finalPosition {
    finalPosition = FINAL_POSITION; //will get this from the interface
    NSMutableArray *feasibleLadderPositions = [NSMutableArray array];
    for(NSNumber *initialPosition in [self.ladders allKeys]) {
        if ([initialPosition intValue]< 10) {
            continue;
        }
        if([initialPosition intValue] <= finalPosition && [self.ladders[initialPosition] intValue] <= finalPosition) {
            [feasibleLadderPositions addObject:initialPosition];
        }
    }
    if([feasibleLadderPositions count] == 0)
        return [NSNumber numberWithInt:-1];
    //get a random number between 0 and feasibleLadderPositions count
    int positionToSelect = arc4random() % [feasibleLadderPositions count];
    return [feasibleLadderPositions objectAtIndex:positionToSelect];
}

- (NSMutableArray *)getTheArrayOfPositionsToMoveToGivenPositionOfLadderToTake:(int)positionofLadderToTake {
    NSMutableArray *positions = [NSMutableArray array];
    int ladderStartPosition = positionofLadderToTake;
    int ladderEndPosition = [[self.ladders objectForKey:[NSNumber numberWithInt:ladderStartPosition]] intValue];
    int lengthOfLadder = ladderEndPosition - ladderStartPosition;
    int meanM = (FINAL_POSITION - lengthOfLadder) / 10;
    int currentPos = 0;
    [positions addObject:[NSNumber numberWithInt:currentPos]];
    //generate the positions for all moves
    for(int i = 0; i < 4; i++) {
        //check if the ladder start is between the current position and current position + 2 * meanM
        if(ladderStartPosition > currentPos && ladderStartPosition <= currentPos + meanM * 2) {
            if(ladderStartPosition == currentPos + meanM * 2) {
                //the 1st move can take you anywhere
                int randNum = [self randomNumberNotHavingALadderAndLessThan:(int)meanM givenCurrentPosition:currentPos];
                currentPos = currentPos + randNum;
                [positions addObject:[NSNumber numberWithInt:currentPos]];
                currentPos = ladderStartPosition;
                [positions addObject:[NSNumber numberWithInt:currentPos]];
                currentPos = ladderEndPosition;
            } else {
                int distMoved = ladderStartPosition - currentPos;
                currentPos = ladderStartPosition;
                [positions addObject:[NSNumber numberWithInt:currentPos]];
                currentPos = ladderEndPosition + meanM * 2 - distMoved;
                //currentPos must not end in a ladder
                while([[self.ladders allKeys] containsObject:[NSNumber numberWithInt:currentPos]] && (meanM*2 - distMoved)%6 != 0)
                    currentPos++;
                [positions addObject:[NSNumber numberWithInt:currentPos]];
            }
        } else {
            int randNum = [self randomNumberNotHavingALadderAndLessThan:meanM givenCurrentPosition:currentPos];
            currentPos += randNum;
            [positions addObject:[NSNumber numberWithInt:currentPos]];
            currentPos = currentPos + meanM * 2 - randNum;
            while([self isThereLadderAtPos:currentPos] || (self.positionOfLadderToTake - currentPos)%6 == 0)
                currentPos++;
            [positions addObject:[NSNumber numberWithInt:currentPos]];
        }
    }
    //last 2 steps left take its care
    // case 1 if ladder is yet to take
    if(ladderStartPosition > currentPos) {
        [positions addObject:[NSNumber numberWithInt:ladderStartPosition]];
        [positions addObject:[NSNumber numberWithInt:FINAL_POSITION]];
    } else {
        currentPos = FINAL_POSITION - 1;
        while ([[self.ladders allKeys] containsObject:[NSNumber numberWithInt:currentPos]]) {
            currentPos --;
        }
        [positions addObject:[NSNumber numberWithInt:currentPos]];
        [positions addObject:[NSNumber numberWithInt:FINAL_POSITION]];
    }
    return positions;
}

- (int)randomNumberNotHavingALadderAndLessThan:(int)meanM givenCurrentPosition:(int)currentPos{
    int ans;
    while(true){
        ans = arc4random() % meanM + 1;
        int nextPos = ans + currentPos;
        if(![self isThereLadderAtPos:nextPos] && (meanM * 2 - ans != 6) && ans!=6 && nextPos + 6 != self.positionOfLadderToTake)
            return ans;            
    }
    return 0;
}

//- (int)distanceFromLadderTheWeAreGoingToTake {
//
//}

- (BOOL)isThereLadderAtPos:(int)pos {
   return [[self.ladders allKeys] containsObject:[NSNumber numberWithInt:pos]];
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
    self.positionOfLadderToTake = [[self getPositionOfLadderFromTheLaddersTillFinalPosition:FINAL_POSITION] intValue];
    self.positions = [self getTheArrayOfPositionsToMoveToGivenPositionOfLadderToTake:self.positionOfLadderToTake];
}

- (void) dealloc {
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
    [self runAction:[CCSequence actions:[[CCDelayTime alloc] initWithDuration:3],[CCCallFuncN actionWithTarget:self selector:@selector(compDiceRoll)],nil]];
}

- (void) playerTurnLogic {
    if (rollValue_ == 6) {
        [notifyLabel_ setString:@"6! Roll Again"];
        playerPos_ += rollValue_;
        
        NSNumber *ladderEnd = [[NSNumber alloc] initWithInt:playerPos_];
        NSLog(@"%d", [(NSNumber *)[ladders_ objectForKey:ladderEnd] intValue]);
//        if ([ladders_ objectForKey:ladderEnd]) {
//            [notifyLabel_ setString:@"Wow! Ladder"];
//            NSLog(@"Hit a ladder");
//            playerPos_ = [ladders_[ladderEnd] intValue];
//        }
        NSNumber *snakeEnd = [[NSNumber alloc] initWithInt:playerPos_];
        NSLog(@"%d", [ladderEnd intValue]);
//        if ([snakes_ objectForKey:snakeEnd]) {
//            [notifyLabel_ setString:@"Snake's belly stinks!"];
//            NSLog(@"Hit a snake");
//            playerPos_ = [snakes_[snakeEnd] intValue];
//        }
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
//        if ([snakes_ objectForKey:snakeEnd]) {
//            [notifyLabel_ setString:@"Snake's belly stinks!"];
//            NSLog(@"Hit a snake");
//            playerPos_ = [snakes_[snakeEnd] intValue];
//        }
        [self updatePlayerPos];
        [self phoneTurnRoll];
        isPlayersTurn_ = NO;
    }
}

- (void) phoneTurnLogic {
    if (rollValue_ == 6) {
        phonePos_ += rollValue_;
        NSNumber *ladderEnd = [[NSNumber alloc] initWithInt:phonePos_];
        NSLog(@"%d", [(NSNumber *)[ladders_ objectForKey:ladderEnd] intValue]);
//        if ([ladders_ objectForKey:ladderEnd] && rollValue_!=6) {
//            [notifyLabel_ setString:@"Wow! Ladder"];
//            NSLog(@"Hit a ladder");
//            phonePos_ = [ladders_[ladderEnd] intValue];
//        }
        NSNumber *snakeEnd = [[NSNumber alloc] initWithInt:phonePos_];
        NSLog(@"%d", [ladderEnd intValue]);
//        if ([snakes_ objectForKey:snakeEnd]) {
//            [notifyLabel_ setString:@"Snake's belly stinks!"];
//            NSLog(@"Hit a snake");
//            phonePos_ = [snakes_[snakeEnd] intValue];
//        }
        [notifyLabel_ setString:@"6! Rolling Again"];
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
//        if ([snakes_ objectForKey:snakeEnd]) {
//            [notifyLabel_ setString:@"Snake's belly stinks!"];
//            NSLog(@"Hit a snake");
//            phonePos_ = [snakes_[snakeEnd] intValue];
//        }
        [self updatePhonePos];
        [diceMenu_ setEnabled:YES];
        isPlayersTurn_ = YES;
    }
}

- (void) diceRoll {
    if(self.turnsTaken > 10 && rollValue_ != 6) {
        [self gameOver];
        return;
    }
    NSLog(@"Player position: %d, Phone position: %d", playerPos_, phonePos_);
    CCSprite *downArrow = [CCSprite spriteWithFile:@"arrow_down.png" rect:CGRectMake(0, 0, 24, 24)];
    downArrow.position = ccp((userPic_.position.x + phonePic_.position.x)/2, userPic_.position.y + diceSprite_.contentSize.height/2 + downArrow.contentSize.height/2);
    [self addChild:downArrow];
    int rValue = arc4random() % 6 + 1;
    if([self.positions[self.turnsTaken] integerValue] - playerPos_ > 6) {
        rValue = 6;
    } else {
        rValue = [self.positions[self.turnsTaken] integerValue] - playerPos_;
        self.turnsTaken++;
    }
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

- (void) compDiceRoll {
    NSLog(@"Player position: %d, Phone position: %d", playerPos_, phonePos_);
    CCSprite *downArrow = [CCSprite spriteWithFile:@"arrow_down.png" rect:CGRectMake(0, 0, 24, 24)];
    downArrow.position = ccp((userPic_.position.x + phonePic_.position.x)/2, userPic_.position.y + diceSprite_.contentSize.height/2 + downArrow.contentSize.height/2);
    [self addChild:downArrow];
    int rValue = arc4random() % 6 + 1;
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
