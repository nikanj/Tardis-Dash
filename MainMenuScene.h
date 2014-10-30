//
//  MainMenuScene.h
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface MainMenuScene : SKScene<SKPhysicsContactDelegate>{
    CGFloat screenHeight;
    CGFloat screenWidth;
}

@property (strong,nonatomic) SKSpriteNode *tardis;
@property (strong,nonatomic) NSMutableArray *spaceDustTextures;
@property (strong,nonatomic) SKLabelNode *play;
@property (strong,nonatomic) SKLabelNode *highScore;
@end
