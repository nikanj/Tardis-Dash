//
//  GameOverScene.h
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@interface GameOverScene : SKScene<SKPhysicsContactDelegate>{
    CGFloat screenHeight;
    CGFloat screenWidth;
}


@property (strong,nonatomic) SKSpriteNode *tardis;
@property (strong,nonatomic) NSArray *tardisTextures;
@property (strong,nonatomic) NSMutableArray *spaceDustTextures;
@property (strong,nonatomic) SKLabelNode *finalScore;
@property (strong,nonatomic) SKLabelNode *finalTime;
@property (strong,nonatomic) SKLabelNode *mainMenu;
@property (strong,nonatomic) SKLabelNode *restart;
@property (strong,nonatomic) SKLabelNode *resultScore;
@property (strong,nonatomic) SKLabelNode *resultTime;
@property (strong,nonatomic) SKLabelNode *gameOver;

@end

