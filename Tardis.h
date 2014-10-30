//
//  Tardis.h
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/10/13.
//  Copyright (c) 2013 Nikanj Gupta Vemala. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Tardis : SKSpriteNode

-(id)initWithParent:(SKNode*) parent;
-(SKAction*)lifeEndedMovement;

@property (strong,nonatomic) NSArray *tardisTextures;


@end
