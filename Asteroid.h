//
//  Asteroid.h
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/10/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Asteroid : SKSpriteNode{
    int asteroidType;
}

-(id)initWithParent:(SKNode*) parent;
-(void)move;

@end
