//
//  HighScoreScene.h
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HighScoreScene : SKScene<SKPhysicsContactDelegate>{
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property (strong,nonatomic) NSMutableArray *spaceDustTextures;
@property (strong,nonatomic) SKLabelNode *finalScore;
@property (strong,nonatomic) SKLabelNode *resultScore;
@property (strong,nonatomic) SKLabelNode *finalTime;
@property (strong,nonatomic) SKLabelNode *resultTime;
@property (strong,nonatomic) SKLabelNode *mainMenu;

@end
