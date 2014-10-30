//
//  MainMenuScene.m
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "MainMenuScene.h"
#import "ViewController.h"
#import "MyScene.h"
#import "GameOverScene.h"
#import "HighScoreScene.h"
#import "Constants.h"

static NSString* playCategoryName = @"play";
static NSString* highScoreCategoryName = @"highscore";
static NSString* titleCategoryName = @"Tardis Blue";

@implementation MainMenuScene{
    NSTimeInterval previousUpdateTime;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])  {
        
        screenHeight = self.frame.size.height;
        screenWidth = self.frame.size.width;
        self.backgroundColor = [SKColor blackColor];

        
        SKAction *wait = [SKAction waitForDuration:[self getRandomNumberBetween:1 to:2]];
        SKAction *generateClouds = [SKAction runBlock:^{
            [self generateSpaceDust];
        }];
        SKAction *updateClouds = [SKAction sequence:@[wait,generateClouds]];
        [self runAction:[SKAction repeatActionForever:updateClouds]];
        
        [self setupBackground];
        [self setupTardis];
        [self setupHighscores];
        
    }
    return self;
}

-(void)setupBackground{
    
    NSString *starsPath = [[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"];
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:starsPath];
    stars.position = CGPointMake(screenWidth*.50,screenHeight*.50);
    
    [self addChild:stars];
    
    SKTextureAtlas *cloudsAtlas = [SKTextureAtlas atlasNamed:@"SpaceDust"];
    NSArray *textureNames = [cloudsAtlas textureNames];
    _spaceDustTextures = [NSMutableArray new];
    for (NSString *name in textureNames) {
        SKTexture *texture = [cloudsAtlas textureNamed:name];
        [_spaceDustTextures addObject:texture];
    }
}

-(void)generateSpaceDust{
    int randomSpaceDust = [self getRandomNumberBetween:0 to:1];
    if(randomSpaceDust == 1){
        int whichDust = [self getRandomNumberBetween:0 to:6];
        SKSpriteNode *dust = [SKSpriteNode spriteNodeWithTexture:[_spaceDustTextures objectAtIndex:whichDust]];
        int randomYAxix = [self getRandomNumberBetween:0 to:self.frame.size.height];
        dust.position = CGPointMake(self.frame.size.width + dust.size.width/2, randomYAxix);
        int randomDustTime = [self getRandomNumberBetween:1 to:3];
        
        SKAction *move =[SKAction moveTo:CGPointMake(0-dust.size.height, randomYAxix) duration:randomDustTime*10];
        SKAction *remove = [SKAction removeFromParent];
        [dust runAction:[SKAction sequence:@[move,remove]]];
        dust.zPosition = kZPositionBackground;
        [self addChild:dust];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

-(void)setupTardis{
    //adding the tardis
    _tardis = [SKSpriteNode spriteNodeWithImageNamed:@"TardisHD.png"];
    _tardis.position = CGPointMake(screenWidth*.15, screenHeight*0.25);
    [self addChild:_tardis];
    
}


- (void)setupHighscores
{
    _play = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _play.text = @"Play";
    _play.position = CGPointMake(screenWidth*.75, screenHeight*.50);
    _play.fontSize = 70;
    _play.name = playCategoryName;
    
    SKSpriteNode* _title = [SKSpriteNode spriteNodeWithImageNamed:@"Banner.png"];
    _title.position = CGPointMake(screenWidth*.50, screenHeight*.83);
    _title.name = titleCategoryName;
    
    _highScore = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _highScore.text = @"High Scores";
    _highScore.position = CGPointMake(screenWidth*.75, screenHeight*0.30);
    _highScore.fontSize = 70;
    _highScore.name = highScoreCategoryName;
    [self addChild:_highScore];
    [self addChild:_play];
    [self addChild:_title];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if (node.position.x > (_play.position.x - _play.frame.size.width/2) && node.position.x < (_play.position.x + _play.frame.size.width/2)) {
        
        if (node.position.y > (_play.position.y - _play.frame.size.height/2) && node.position.y < (_play.position.y + _play.frame.size.height/2)) {
            
            SKView * skView = (SKView *)self.view;
                       SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1];
            [skView presentScene:scene transition:reveal];
            
        }
    }
    
    if (node.position.x > (_highScore.position.x - _highScore.frame.size.width/2) && node.position.x < (_highScore.position.x + _highScore.frame.size.width/2)) {
        
        if (node.position.y > (_highScore.position.y - _highScore.frame.size.height/2) && node.position.y < (_highScore.position.y + _highScore.frame.size.height/2)) {
            
            SKView * skView = (SKView *)self.view;
            
            SKScene * scene = [ HighScoreScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1];
            [skView presentScene:scene transition:reveal];
            
        }
    }
}


@end
