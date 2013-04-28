//
//  HelloWorldLayer.mm
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/11/12.
//  Copyright Pocket Gems 2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"
#import "GameScene.h"
#import "SettingsScene.h"
#import "GlobalState.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
extern GlobalState *globalState;

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *snakeImage = [CCSprite spriteWithFile:@"snake-100.png" rect:CGRectMake(0, 0, 88, 100)];
        snakeImage.position = ccp(winSize.width - snakeImage.contentSize.width/2 - 20, winSize.height - snakeImage.contentSize.height/2 - 20);
        [self addChild:snakeImage];
        
        CCSprite *ladderImage = [CCSprite spriteWithFile:@"ladder-200.png" rect:CGRectMake(0, 0, 60, 200)];
        ladderImage.position = ccp(40 + ladderImage.contentSize.width/2, ladderImage.contentSize.height/2 - 20);
        [self addChild:ladderImage];
        [ladderImage setRotation:-30];
        
        //[ladderImage runAction:[CCSequence actions:[[CCDelayTime alloc] initWithDuration:1],[CCRotateBy actionWithDuration:1.2 angle:-30],nil]];
        
        CCLabelTTF *titleAnd = [CCLabelTTF labelWithString:@"&" fontName:@"Chalkduster" fontSize:40];
        titleAnd.position = ccp(winSize.width/2, 3*winSize.height/4 - 30);
        
        CCLabelTTF *titleSnakes = [CCLabelTTF labelWithString:@"Snakes" fontName:@"Chalkduster" fontSize:34];
        titleSnakes.position = ccp(titleAnd.position.x - titleSnakes.contentSize.width/2 + 30, titleAnd.position.y + titleSnakes.contentSize.height/2 + 5);
        titleSnakes.color = ccc3(0, 153, 255);
        [self addChild:titleSnakes];
        
        CCLabelTTF *titleLadders = [CCLabelTTF labelWithString:@"Ladders" fontName:@"Chalkduster" fontSize:34];
        titleLadders.position = ccp(titleAnd.position.x + titleLadders.contentSize.width/2 - 30, titleAnd.position.y - titleLadders.contentSize.height/2);
        titleLadders.color = ccc3(0, 153, 255);
        [self addChild:titleLadders];
        
        [self addChild:titleAnd];
        
        CCMenuItemLabel *newGame = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"New Game" fontName:@"Chalkduster" fontSize:24] target:self selector:@selector(startNewGame:)];
        
        CCMenuItemLabel *settings = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Settings" fontName:@"Chalkduster" fontSize:24] target:self selector:@selector(showSettings:)];
            
        CCMenuItemLabel *achievements = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Achievements" fontName:@"Chalkduster" fontSize:24] target:self selector:@selector(testMethod:)];
        
        CCMenu *startMenu = [CCMenu menuWithItems:newGame, settings, achievements, nil];
        startMenu.position = ccp(titleAnd.position.x, titleAnd.position.y - 140);
        [startMenu alignItemsVerticallyWithPadding:15.0];
		[self addChild:startMenu];
        
	}
	return self;
}

-(void) dealloc
{
    [super dealloc];
}

- (void) testMethod:(id)sender {
    CCLabelTTF *test = [CCLabelTTF labelWithString:@"test" fontName:@"Arial" fontSize:15];
    test.color = ccc3(0, 0, 0);
    test.position = ccp(10, 40);
    [self addChild:test];
}

- (void) startNewGame:(id)sender {
    [globalState placeBet];
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}

- (void) showSettings:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[SettingsScene scene]];
}

@end
