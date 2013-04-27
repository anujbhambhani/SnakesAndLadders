//
//  SettingsScene.m
//  SnakesAndLadders
//
//  Created by Prudhvi Vatala on 7/12/12.
//  Copyright 2012 Pocket Gems. All rights reserved.
//

#import "SettingsScene.h"
#import "UserData.h"
#import "HelloWorldLayer.h"
#import "CommonCrypto/CommonDigest.h"


@implementation SettingsScene

@synthesize layer = layer_;

+ (CCScene *) scene {
    CCScene *scene = [CCScene node];
    SettingsLayer *layer = [SettingsLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init {
    if (self = [super init]) {
        self.layer = [SettingsLayer node];
        [self addChild:layer_];
    }
    return self;
}

- (void) dealloc{
    [layer_ release];
    layer_ = nil;
    [super dealloc];
}

@end

@implementation SettingsLayer

@synthesize nMenuItem = nMenuItem_;
@synthesize gMenuItem = gMenuItem_;

- (id) init {
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite *defPic = [CCSprite spriteWithFile:@"pic-default-70.png" rect:CGRectMake(0, 0, 70, 70)];
        CCSprite *gravatarPic = [self getGravatar];
        CCLabelTTF *nameTitle = [CCLabelTTF labelWithString:@"Name" fontName:@"Chalkduster" fontSize:36];
        CCLabelTTF *avatarTitle = [CCLabelTTF labelWithString:@"Avatar" fontName:@"Chalkduster" fontSize:36];
        CCLabelTTF *updateGravatarLabel = [CCLabelTTF labelWithString:@"Tap gravatar to add/update.." fontName:@"Chalkduster" fontSize:13];
        CCLabelTTF *updateNameLabel = [CCLabelTTF labelWithString:@"Tap name to update.." fontName:@"Chalkduster" fontSize:13];
        
        nameTitle.position = ccp(winSize.width/2, winSize.height - 70);
        nameTitle.color = ccc3(0, 153, 255);
        [self addChild:nameTitle];
        CCMenuItemLabel *nameLabel = [[CCMenuItemLabel alloc] initWithLabel:[CCLabelTTF labelWithString:[self getName] fontName:@"Chalkduster" fontSize:24] target:self selector:@selector(updateNameTap)];
        CCMenu *nameMenu = [CCMenu menuWithItems:nameLabel, nil];
        nameMenu.position = ccp(winSize.width/2, nameTitle.position.y - 50);
        [self addChild:nameMenu];
        nMenuItem_ = nameLabel;
        updateNameLabel.position = ccp(winSize.width/2, nameMenu.position.y - 30);
        [self addChild:updateNameLabel];
        
        avatarTitle.position = ccp(nameTitle.position.x, updateNameLabel.position.y - 70);
        avatarTitle.color = ccc3(0, 153, 255);
        [self addChild:avatarTitle];
        CCLabelTTF *defTitle = [CCLabelTTF labelWithString:@"Default Pic" fontName:@"Chalkduster" fontSize:18];
        CCLabelTTF *grTitle = [CCLabelTTF labelWithString:@"Gravatar" fontName:@"Chalkduster" fontSize:18];
        defPic.position = ccp((winSize.width - 140)/3 + defPic.contentSize.width/2, avatarTitle.position.y - 85);
        [self addChild:defPic];
        CCMenuItemSprite *gravatarSprite = [[CCMenuItemSprite alloc] initWithNormalSprite:gravatarPic selectedSprite:nil disabledSprite:nil target:self selector:@selector(updateGravatarTap)];
        CCMenu *gravatarMenu = [CCMenu menuWithItems:gravatarSprite, nil];
        gravatarMenu.position = ccp(2*(winSize.width - 140)/3 + gravatarPic.contentSize.width/2 + defPic.contentSize.width, defPic.position.y);
        [self addChild:gravatarMenu];
        gMenuItem_ = gravatarSprite;
        updateGravatarLabel.position = ccp(winSize.width/2, defPic.position.y - defPic.contentSize.height/2 - 25);
        [self addChild:updateGravatarLabel];
        defTitle.position = ccp(defPic.position.x, defPic.position.y + 45);
        grTitle.position = ccp(gravatarMenu.position.x, defPic.position.y + 45);
        defTitle.color = ccc3(194, 194, 194);
        grTitle.color = ccc3(194, 194, 194);
        [self addChild:defTitle];
        [self addChild:grTitle];
        
        CCMenuItemImage *backButton = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:nil target:self selector:@selector(backToMenu)];
        CCMenu *backMenu = [CCMenu menuWithItems:backButton, nil];
        backMenu.position = ccp(backButton.contentSize.width/2 + 20, backButton.contentSize.height/2 + 20);
        [self addChild:backMenu];
    }
    return self;
}

- (void) dealloc {
    [nMenuItem_ release];
    [gMenuItem_ release];
    nMenuItem_ = nil;
    gMenuItem_ = nil;
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

- (void) backToMenu {
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
}

- (CCSprite *) getGravatar {
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    CCSprite *sprite;
    if ([userData boolForKey:@"isUsingGravatar"]) {
        UIImage *image = [UIImage imageWithData:[userData objectForKey:@"image"]];
        sprite = [CCSprite spriteWithCGImage:image.CGImage key:@"userImage"];
        NSLog(@"Initial picture: %@",(NSString *)[userData objectForKey:@"image"]);
    } else {
        sprite = [CCSprite spriteWithFile:@"gravatar-default.png" rect:CGRectMake(0, 0, 70, 70)];
    }
    return sprite;
}

- (void) updateGravatarTap {
    UIAlertView *gravAlert = [[UIAlertView alloc] initWithTitle:@"Update Gravatar" message:@"Please enter your gravatar email address.." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    gravAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    gravAlert.tag = 1;
    [gravAlert textFieldAtIndex:0].delegate = self;
    [gravAlert show];
    [gravAlert release];
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text) {
        if ([textField superview].tag == 1) {
            [(UIAlertView *)[textField superview] dismissWithClickedButtonIndex:0 animated:YES];
            [self updateGravatar:textField.text];
        } else if ([textField superview].tag == 2) {
            [(UIAlertView *)[textField superview] dismissWithClickedButtonIndex:0 animated:YES];
            [self updateName:textField.text];
        }
    }
}

- (void) updateNameTap {
    UIAlertView *nameAlert = [[UIAlertView alloc] initWithTitle:@"Update Name" message:@"Enter the name.." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    nameAlert.tag = 2;
    [nameAlert textFieldAtIndex:0].delegate = self;
    [nameAlert show];
    [nameAlert release];
}

- (void) updateGravatar:(NSString *)email {
    NSString *curatedEmail = [[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    const char *cstr = [curatedEmail UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    NSString *md5email = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
    NSString *gravatarUrl = [[NSString alloc] initWithFormat:@"http://www.gravatar.com/avatar/%@?s=70",md5email];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSURL *gravUrl = [[NSURL alloc] initWithString:gravatarUrl];
    NSData *gravImageData = nil;// = [NSData dataWithContentsOfURL:gravUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:gravUrl];
    gravImageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Gravatar server not reachable.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
        [errorAlert release];
        return;
    }
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:gravImageData forKey:@"image"];
    [userData setBool:YES forKey:@"isUsingGravatar"];
    [userData synchronize];
    NSLog(@"Changed picture: %@",(NSString *)[userData objectForKey:@"image"]);
    UIImage *im = [[UIImage alloc] initWithData:gravImageData];
    CCSprite *i = [CCSprite spriteWithCGImage:im.CGImage key:@"userImage"];
    [gMenuItem_ setNormalImage:i];
}

- (void) updateName:(NSString *)name {
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setObject:name forKey:@"name"];
    [userData synchronize];
    [nMenuItem_.label setString:name];
}

- (NSString *) getName {
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *name = (NSString *)[userData objectForKey:@"name"];
    if (name && name.length) {
        return name;
    }
    return [[NSString alloc] initWithString:@"Player"];
}

@end
