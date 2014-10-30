//
//  Asteroid.m
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/10/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "Asteroid.h"
#import "Constants.h"

@implementation Asteroid

-(id)initWithParent:(SKNode*) parent{
    
    
    asteroidType = [self getRandomNumberBetween:1 to:3];
    
    NSString *asteroidImage = [NSString stringWithFormat:@"Asteroid%d.png",asteroidType];
    self = [super initWithImageNamed:asteroidImage];
    if (self) {
        int randomYAxix = [self getRandomNumberBetween:0 to:parent.frame.size.height];
        self.physicsBody.mass = 100;
        self.position = CGPointMake(parent.frame.size.width + self.size.width/2, randomYAxix);
        self.name = asteroidCategoryName;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height/2-3];
        self.physicsBody.dynamic = YES;
        self.zPosition = kZPositionFront;
        self.physicsBody.categoryBitMask = asteroidCategory;
        self.physicsBody.collisionBitMask = tardisCategory|bulletCategory;
        [parent addChild:self];
    }
    return self;
    
}

-(void)move{
    float randomX = [self getRandomNumberBetween:15 to:20];
    if(asteroidType == 1){
        [self.physicsBody applyImpulse:CGVectorMake(-randomX*10, 0)];
    }if(asteroidType == 2){
        [self.physicsBody applyImpulse:CGVectorMake(-randomX*7, 0)];
    }else{
        [self.physicsBody applyImpulse:CGVectorMake(-randomX*5, 0)];
    };
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

@end
