//
//  MyScene.h
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/7/13.
//  Copyright (c) 2013 Nikanj Gupta Vemala All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Tardis.h"

@interface MyScene : SKScene<UIAccelerometerDelegate,SKPhysicsContactDelegate>{
    NSTimeInterval previousUpdateTime;
    double currentMaxAccelX;
    double currentMaxAccelY;
    NSInteger life;
    NSInteger hits;
    NSInteger score;
    NSTimeInterval time;
}

@property (strong,nonatomic) Tardis *tardis;
@property (strong,nonatomic) CMMotionManager *motionManager;
@property (strong,nonatomic) NSArray *tardisTextures;
@property (strong,nonatomic) NSMutableArray *spaceDustTextures;
@property (strong,nonatomic) NSMutableArray *explosionTextures;
@property (strong,nonatomic) SKLabelNode *scoreLabel;
@property (strong,nonatomic) SKSpriteNode *life1;
@property (strong,nonatomic) SKSpriteNode *life2;
@property (strong,nonatomic) SKSpriteNode *life3;

@end
