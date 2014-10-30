//
//  GameOverScene.m
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "GameOverScene.h"
#import "MainMenuScene.h"
#import "MyScene.h"
#import "GameDataHelper.h"
#import "Constants.h"

@implementation GameOverScene{
    NSTimeInterval previousUpdateTime;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])  {
        self.backgroundColor = [SKColor blackColor];
        
        
        screenHeight = self.frame.size.height;
        screenWidth = self.frame.size.width;
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        [self setupBackground];
        [self setupStats];
        [self drawDalek];
        
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

-(void) drawDalek{
    //adding the dalek
    SKSpriteNode *dalek1 = [SKSpriteNode spriteNodeWithImageNamed:@"Dalek1HD.png"];
    dalek1.position = CGPointMake(screenWidth*.15, screenHeight*0.25);
    [self addChild:dalek1];
    
    SKSpriteNode *dalek2 = [SKSpriteNode spriteNodeWithImageNamed:@"Dalek2HD.png"];
    dalek2.position = CGPointMake(screenWidth*.85, screenHeight*0.25);
    [self addChild:dalek2];
    
}

-(void)setupStats{
    
    _gameOver = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _gameOver.text = @"You have been EXTERMINATED!!!";
    _gameOver.position = CGPointMake(screenWidth*.50, screenHeight*0.90);
    _gameOver.fontSize = 50;
    
    _finalScore = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _finalScore.text = @"Score:";
    _finalScore.position = CGPointMake(screenWidth*.45, screenHeight*0.80);
    _finalScore.fontSize = 50;
    
    _finalTime = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _finalTime.text = @"Time Survived:";
    _finalTime.position = CGPointMake(screenWidth*.40, screenHeight*0.70);
    _finalTime.fontSize = 50;
    
    GameDataHelper *statsC = [GameDataHelper defaultController];
    
    _resultScore = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _resultScore.text = [NSString stringWithFormat:@"%i",statsC.score];
    _resultScore.fontColor= [SKColor colorWithRed:105 green:181 blue:227 alpha:1.0];
    _resultScore.position = CGPointMake(screenWidth*.60, screenHeight*0.80);
    _resultScore.fontSize = 50;
    
    _resultTime = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _resultTime.text = [NSString stringWithFormat:@"%0.00f seconds",statsC.time];
    _resultTime.fontColor= [SKColor colorWithRed:105.0 green:181.0 blue:227.0 alpha:1.0];
    _resultTime.position = CGPointMake(screenWidth*.67, screenHeight*0.70);
    _resultTime.fontSize = 50;
    
    
    _mainMenu = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _mainMenu.text = @"Main Menu";
    _mainMenu.position = CGPointMake(screenWidth*.50, screenHeight*0.37);
    _mainMenu.fontSize = 50;
    
    _restart = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _restart.text = @"Restart";
    _restart.position = CGPointMake(screenWidth*.50, screenHeight*0.20);
    _restart.fontSize = 50;
    
    [self addChild:_gameOver];
    [self addChild:_mainMenu];
    [self addChild:_finalScore];
    [self addChild:_restart];
    [self addChild:_resultScore];
    [self addChild:_finalTime];
    [self addChild:_resultTime];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if (node.position.x > (_mainMenu.position.x - _mainMenu.frame.size.width/2) && node.position.x < (_mainMenu.position.x + _mainMenu.frame.size.width/2)) {
        
        if (node.position.y > (_mainMenu.position.y - _mainMenu.frame.size.height/2) && node.position.y < (_mainMenu.position.y + _mainMenu.frame.size.height/2)) {
            //do whatever...
            SKView * skView = (SKView *)self.view;
            
            SKScene * scene = [MainMenuScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1];
            [skView presentScene:scene transition:reveal];
            
        }
        
    }
    
    if (node.position.x > (_restart.position.x - _restart.frame.size.width/2) && node.position.x < (_restart.position.x + _restart.frame.size.width/2)) {
        
        if (node.position.y > (_restart.position.y - _restart.frame.size.height/2) && node.position.y < (_restart.position.y + _restart.frame.size.height/2)) {
            
            SKView * skView = (SKView *)self.view;
            SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1];
            [skView presentScene:scene transition:reveal];
            
        }
        
    }
}

@end
