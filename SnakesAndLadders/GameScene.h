//
//  GameScene.h
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/11/12.
//  Copyright (c) 2012 Pocket Gems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayerColor

@property BOOL isPlayersTurn;
@property (retain, nonatomic) CCSprite *diceSprite;
@property (retain, nonatomic) CCMenuItemSprite *diceMenuItem;
@property (retain, nonatomic) CCMenu *diceMenu;
@property int rollValue;
@property (retain, nonatomic) CCSprite *userPic;
@property (retain, nonatomic) CCSprite *phonePic;
@property int playerPos;
@property int phonePos;
@property (retain, nonatomic) CCLabelTTF *notifyLabel;
@property BOOL isDieRolling;
@property (retain, nonatomic) NSDictionary *snakes;
@property (retain, nonatomic) NSDictionary *ladders;
@property (retain, nonatomic) CCSprite *playerPawn;
@property (retain, nonatomic) CCSprite *phonePawn;
@property (nonatomic, assign) int turnsTaken;
@property (nonatomic, retain) NSMutableArray *positions;

@end

@interface GameScene : CCScene

@property (retain, nonatomic) GameLayer *layer;

+ (CCScene *) scene;

@end
