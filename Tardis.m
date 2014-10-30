//
//  Tardis.m
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/10/13.
//  Copyright (c) 2013 Nikanj Gupta Vemala. All rights reserved.
//

#import "Constants.h"
#import "Tardis.h"

@interface Tardis() {
    SKNode* parentNode;
}
@end

@implementation Tardis

-(id)initWithParent:(SKNode*) parent{
    parentNode = parent;
    NSMutableArray *tardisSpinFrames = [NSMutableArray array];
    SKTextureAtlas *tardisAtlas = [SKTextureAtlas atlasNamed:@"Tardis"];
    NSUInteger numImages = tardisAtlas.textureNames.count;
    for (int i=1; i <= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"tardis%d", i];
        SKTexture *temp = [tardisAtlas textureNamed:textureName];
        [tardisSpinFrames addObject:temp];
    }
    _tardisTextures = tardisSpinFrames;
    SKTexture *temp = _tardisTextures[0];
    
    self = [super initWithTexture:temp];
    if (self) {
        self.position = CGPointMake(parent.frame.size.width*0.1, parent.frame.size.height*0.5);
        self.name = tardisCategoryName;
        self.zPosition = kZPositionFront;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = tardisCategory;
        self.physicsBody.collisionBitMask = asteroidCategory|enemyCategory|enemyBulletCategory;
        self.physicsBody.contactTestBitMask = asteroidCategory|enemyCategory|enemyBulletCategory;
        
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_tardisTextures timePerFrame:0.02f resize:NO restore:YES]]withKey:@"tardisSpin"];
        
        [parent addChild:self];
    }
    return self;
}

-(SKAction *)lifeEndedMovement{
    SKAction *move= [SKAction moveByX:-self.frame.size.width*3 y:0 duration:0.5];
    SKAction *wait= [SKAction waitForDuration:1];
    SKAction *moveBack = [SKAction moveTo:CGPointMake(parentNode.frame.size.width*0.1, parentNode.frame.size.height*0.5) duration:1];
    SKAction *action = [SKAction sequence:@[move,wait,moveBack]];
    return action;
}

@end
