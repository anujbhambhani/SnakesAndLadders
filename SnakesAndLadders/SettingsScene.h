//
//  SettingsScene.h
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/12/12.
//  Copyright 2012 Pocket Gems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SettingsLayer : CCLayer <UIAlertViewDelegate, UITextFieldDelegate>

@property (retain, nonatomic) CCMenuItemLabel *nMenuItem;
@property (retain, nonatomic) CCMenuItemSprite *gMenuItem;

@end

@interface SettingsScene : CCScene

@property (retain, nonatomic) SettingsLayer *layer;

+ (CCScene *) scene;

@end