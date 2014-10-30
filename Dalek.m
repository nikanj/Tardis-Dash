//
//  Dalek.m
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/10/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "Dalek.h"
#import "Constants.h"

@interface Dalek() {
    SKNode* parentNode;
}

@end

@implementation Dalek

-(id)initWithParent:(SKNode*) parent{
    
    parentNode  = parent;
    int randomDalekName = [self getRandomNumberBetween:1 to:2];
    NSString *dalekImage = [NSString stringWithFormat:@"Dalek%d.png",randomDalekName];
    self = [super initWithImageNamed:dalekImage];
    if (self) {
        [self setPosition:CGPointMake(parent.frame.size.width + self.frame.size.width/2, self.frame.size.height/2)];
        self.name = enemyCategoryName;
        self.zPosition = kZPositionFront;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.zPosition = kZPositionFront;
        self.physicsBody.categoryBitMask = enemyCategory;
        self.physicsBody.collisionBitMask = tardisCategory|bulletCategory;
        
        NSString *dalekThrust = [[NSBundle mainBundle] pathForResource:@"DalekThrust" ofType:@"sks"];
        SKEmitterNode *dalekTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:dalekThrust];
        dalekTrail.zPosition = -1;
        dalekTrail.position = CGPointMake(0, -40);
        [self addChild:dalekTrail];
        //dalekTrail.targetNode= parent;
        
    }
    return self;
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}



@end
