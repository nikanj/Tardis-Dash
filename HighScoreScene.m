//
//  HighScoreScene.m
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "HighScoreScene.h"
#import "GameDataHelper.h"
#import "MainMenuScene.h"
#import "Constants.h"

@implementation HighScoreScene{
    NSTimeInterval previousUpdateTime;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])  {
        self.backgroundColor = [SKColor blackColor];
        
        
        screenHeight = self.frame.size.height;
        screenWidth = self.frame.size.width;
        
        SKAction *wait = [SKAction waitForDuration:[self getRandomNumberBetween:1 to:2]];
        SKAction *generateClouds = [SKAction runBlock:^{
            [self generateSpaceDust];
        }];
        
        SKAction *updateClouds = [SKAction sequence:@[wait,generateClouds]];
        [self runAction:[SKAction repeatActionForever:updateClouds]];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        [self setupBackground];
        [self setupStats];
        
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

-(void)setupStats{
    _finalScore = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _finalScore.text = @"Max Score:";
    _finalScore.position = CGPointMake(screenWidth*.45, screenHeight*0.80);
    _finalScore.fontSize = 50;
    
    _finalTime = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _finalTime.text = @"Max Time Survived:";
    _finalTime.position = CGPointMake(screenWidth*.40, screenHeight*0.70);
    _finalTime.fontSize = 50;
    
    GameDataHelper *statsC = [GameDataHelper defaultController];
    
    _resultScore = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _resultScore.text = [NSString stringWithFormat:@"%i",statsC.maxScore];
    _resultScore.fontColor= [[SKColor alloc]initWithRed:105 green:181 blue:227 alpha:1.0];
    _resultScore.position = CGPointMake(screenWidth*.62, screenHeight*0.80);
    _resultScore.fontSize = 50;
    
    _resultTime = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _resultTime.text = [NSString stringWithFormat:@"%0.0f seconds",statsC.maxTime];
    _resultTime.fontColor= [SKColor colorWithRed:105 green:181 blue:227 alpha:1.0];
    _resultTime.position = CGPointMake(screenWidth*.70, screenHeight*0.70);
    _resultTime.fontSize = 50;
    
    
    _mainMenu = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _mainMenu.text = @"Main Menu";
    _mainMenu.position = CGPointMake(screenWidth*.50, screenHeight*0.37);
    _mainMenu.fontSize = 50;
    
    
    
    [self addChild:_mainMenu];
    [self addChild:_finalScore];
    [self addChild:_resultTime];
    [self addChild:_resultScore];
    [self addChild:_finalTime];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if (node.position.x > (_mainMenu.position.x - _mainMenu.frame.size.width/2) && node.position.x < (_mainMenu.position.x + _mainMenu.frame.size.width/2)) {
        
        if (node.position.y > (_mainMenu.position.y - _mainMenu.frame.size.height/2) && node.position.y < (_mainMenu.position.y + _mainMenu.frame.size.height/2)) {
            
            SKView * skView = (SKView *)self.view;
            
            SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1];
            [skView presentScene:scene transition:reveal];
            
        }
    }
}
@end
