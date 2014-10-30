//
//  MyScene.m
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/5/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"
#import "GameDataHelper.h"
#import "Constants.h"
#import "Asteroid.h"
#import "Dalek.h"


@interface MyScene(){
    BOOL detectCollisonWithTardis;
    NSDate *startTime;
    NSDate *endTime;
}
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        [self initialSetup];

        _tardis = [[Tardis alloc]initWithParent:self];
        [self setupBackground];
        [self setupHUD];
        
        //enemy generation
        SKAction *waitEnemy = [SKAction waitForDuration:4];
        SKAction *callEnemy = [SKAction runBlock:^{
                [self generateEnemy];
        }];
        SKAction *updateEnemy = [SKAction sequence:@[waitEnemy,callEnemy]];
        [self runAction:[SKAction repeatActionForever:updateEnemy]];
        
        
        //space dust generation
        SKAction *wait = [SKAction waitForDuration:[self getRandomNumberBetween:3 to:6]];
        SKAction *generateClouds = [SKAction runBlock:^{
            [self generateSpaceDust];
        }];
        
        SKAction *updateClouds = [SKAction sequence:@[wait,generateClouds]];
        [self runAction:[SKAction repeatActionForever:updateClouds]];
        
        //asteroid generation
        SKAction *waitAsteroid = [SKAction waitForDuration:0.5];
        SKAction *callAsteroid = [SKAction runBlock:^{
            [self generateAsteroids];
        }];
        SKAction *updateAsteroids = [SKAction sequence:@[waitAsteroid,callAsteroid]];
        [self runAction:[SKAction repeatActionForever:updateAsteroids]];
        
        //CoreMotion
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = .2;
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     // handle acceleremeter data
                                                     if(error){
                                                         NSLog(@"%@", error);
                                                     }
                                                     [self outputAccelerationData:accelerometerData.acceleration];
                                                 }];
        
    }
    return self;
}

-(void) initialSetup{
    life = 3;
    hits = 0;
    score = 0;
    time = 0;
    detectCollisonWithTardis =  YES;
    startTime = [[NSDate alloc]init];
    
    SKTextureAtlas *cloudsAtlas = [SKTextureAtlas atlasNamed:@"SpaceDust"];
    [cloudsAtlas preloadWithCompletionHandler:^{
        
        NSMutableArray *spaceDustFrames = [NSMutableArray array];
        NSUInteger numImages = cloudsAtlas.textureNames.count;
        for (int i=1; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"Cloud%d", i];
            SKTexture *temp = [cloudsAtlas textureNamed:textureName];
            [spaceDustFrames addObject:temp];
        }
        _spaceDustTextures = spaceDustFrames;
    }];

    SKTextureAtlas *explosionAtlas = [SKTextureAtlas atlasNamed:@"Explosion"];
    [explosionAtlas preloadWithCompletionHandler:^{
        
        NSMutableArray *explosionFrames = [NSMutableArray array];
        NSUInteger numImages = explosionAtlas.textureNames.count;
        for (int i=1; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"explosion%d", i];
            SKTexture *temp = [explosionAtlas textureNamed:textureName];
            [explosionFrames addObject:temp];
        }
        _explosionTextures = explosionFrames;
    }];

}



-(void) outputAccelerationData:(CMAcceleration)acceleration{
#define kFilteringFactor 0.1
#define kRestAccelX -0.4
#define kTardisMaxPointsPerSecX (self.frame.size.height*0.5)
#define kMaxDiffX 0.2
    
    UIAccelerationValue rollingX= 0;
    
    rollingX = (acceleration.x * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
    
    float accelX = acceleration.x - rollingX;
    
    float accelDiff = accelX - kRestAccelX;
    float accelFraction = accelDiff / kMaxDiffX;
    float pointsPerSec = kTardisMaxPointsPerSecX * accelFraction;
    currentMaxAccelY = pointsPerSec;
    
}

-(void)update:(NSTimeInterval)currentTime{
    
    //increment the score
    score = score + 5;
    [self updateHUDScore];
    
    //accelerometer stuff!!
    NSTimeInterval dt = currentTime - previousUpdateTime;
    previousUpdateTime = currentTime;
    
    float maxY = self.frame.size.height - _tardis.size.height/2;
    float minY = _tardis.size.height/2;
    
    float newY = _tardis.position.y + (currentMaxAccelY * dt);
    newY = MIN(MAX(newY, minY), maxY);
    _tardis.position = CGPointMake(_tardis.position.x, newY);
    

}


//this is where I clean up the things that are going off screen!! whohoo!! :)
-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:asteroidCategoryName usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < 0){
            //up for debate: DO not decrement score!!
            score = score - 1;
            SKAction *wait =[SKAction waitForDuration:0.2];
            SKAction *remove = [SKAction removeFromParent];
            [node runAction:[SKAction sequence:@[wait,remove]]];
        }
        
    }];
    
    [self enumerateChildNodesWithName:bulletCategoryName usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x > self.frame.size.width){
            SKAction *wait =[SKAction waitForDuration:0.2];
            SKAction *remove = [SKAction removeFromParent];
            [node runAction:[SKAction sequence:@[wait,remove]]];
        }
        
    }];
    
    [self enumerateChildNodesWithName:enemyBulletCategoryName usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < 0){
            //up for debate: DO not decrement score!!
            SKAction *wait =[SKAction waitForDuration:0.2];
            SKAction *remove = [SKAction removeFromParent];
            [node runAction:[SKAction sequence:@[wait,remove]]];
        }
        
    }];
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    //detecting collision with the asteroid!!
    if(firstBody.categoryBitMask == tardisCategory && secondBody.categoryBitMask == asteroidCategory){
        if(detectCollisonWithTardis){
            hits++;
            
            SKNode *asteroid = (contact.bodyB.categoryBitMask & asteroidCategory) ? contact.bodyB.node : contact.bodyA.node;
            [self generateExplosionAt:contact.bodyB.node.position];
            [asteroid runAction:[SKAction removeFromParent]];
            
            if (hits == 3 || hits == 6 || hits == 9) {
                life--;
                [self updateHUDLife];
                SKNode *tardis = (contact.bodyA.categoryBitMask & tardisCategory) ? contact.bodyA.node : contact.bodyB.node;
                //here we make the tardis go away and come back!!
                [self tardisLifeEndedEvent:tardis];
            }
            if (life == 0) {
                [self handleGameOver];
            }
        }else{
            SKNode *asteroid = (contact.bodyB.categoryBitMask & asteroidCategory) ? contact.bodyB.node : contact.bodyA.node;
            [asteroid runAction:[SKAction removeFromParent]];
            [self generateExplosionAt:asteroid.position];
        }
    }
    
    
    //collison of tardis with the enemybullet
    else if(firstBody.categoryBitMask == tardisCategory && secondBody.categoryBitMask == enemyBulletCategory){
        if(detectCollisonWithTardis){
            hits++;
            
            SKNode *enemyBullet = (contact.bodyB.categoryBitMask & enemyBulletCategory) ? contact.bodyB.node : contact.bodyA.node;
            [self generateExplosionAt:contact.bodyB.node.position];
            [enemyBullet runAction:[SKAction removeFromParent]];
            
            if (hits == 3 || hits == 6 || hits == 9) {
                life--;
                [self updateHUDLife];
                SKNode *tardis = (contact.bodyA.categoryBitMask & tardisCategory) ? contact.bodyA.node : contact.bodyB.node;
                //here we make the tardis go away and come back!!
                [self tardisLifeEndedEvent:tardis];
                
            }
            if (life == 0) {
                [self handleGameOver];
            }
        }else{
            SKNode *enemyBullet = (contact.bodyB.categoryBitMask & enemyBulletCategory) ? contact.bodyB.node : contact.bodyA.node;
            [enemyBullet runAction:[SKAction removeFromParent]];
            [self generateExplosionAt:enemyBullet.position];
        }
        
    }
    
    //collison of tardis with the enemy
    else if(firstBody.categoryBitMask == tardisCategory && secondBody.categoryBitMask == enemyCategory){
        if(detectCollisonWithTardis){
            hits++;
            SKNode *enemy = (contact.bodyB.categoryBitMask & enemyCategory) ? contact.bodyB.node : contact.bodyA.node;
            [self generateExplosionAt:contact.bodyB.node.position];
            [enemy runAction:[SKAction removeFromParent]];
            
            if (hits == 3 || hits == 6 || hits == 9) {
                life--;
                [self updateHUDLife];
                SKNode *tardis = (contact.bodyA.categoryBitMask & tardisCategory) ? contact.bodyA.node : contact.bodyB.node;
                //here we make the tardis go away and come back!!
                [self tardisLifeEndedEvent:tardis];
            }
            if (life == 0) {
                [self handleGameOver];
            }
        }else{
            SKNode *enemy = (contact.bodyB.categoryBitMask & enemyCategory) ? contact.bodyB.node : contact.bodyA.node;
            [enemy runAction:[SKAction removeFromParent]];
            [self generateExplosionAt:enemy.position];
        }
        
    }

    
    if(firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == asteroidCategory){
        //we give 10 points for destroying a asteroid
        score = score + 10;

        NSLog(@"Asteroid-Bullet Collision");
        SKNode *bullet = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyA.node : contact.bodyB.node;
        [bullet runAction:[SKAction removeFromParent]];
        SKNode *asteroid = (contact.bodyB.categoryBitMask & asteroidCategory) ? contact.bodyB.node : contact.bodyA.node;
        [asteroid runAction:[SKAction removeFromParent]];
        [self generateExplosionAt:contact.bodyB.node.position];
    }
    
    if(firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == enemyBulletCategory){
        //we give 10 points for destroying a asteroid
        score = score + 10;
        
        NSLog(@"EnemyBullet-Bullet Collision");
        SKNode *bullet = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyA.node : contact.bodyB.node;
        [bullet runAction:[SKAction removeFromParent]];
        SKNode *asteroid = (contact.bodyB.categoryBitMask & enemyBulletCategory) ? contact.bodyB.node : contact.bodyA.node;
        [asteroid runAction:[SKAction removeFromParent]];
        [self generateExplosionAt:contact.bodyB.node.position];
    }
    
    if(firstBody.categoryBitMask == bulletCategory && secondBody.categoryBitMask == enemyCategory){
        //we give 10 points for destroying a asteroid
        score = score + 20;
        NSLog(@"Enemy-Bullet Collision");
        SKNode *bullet = (contact.bodyA.categoryBitMask & bulletCategory) ? contact.bodyA.node : contact.bodyB.node;
        [bullet runAction:[SKAction removeFromParent]];
        SKNode *enemy = (contact.bodyB.categoryBitMask & enemyCategory) ? contact.bodyB.node : contact.bodyA.node;
        [enemy runAction:[SKAction removeFromParent]];
        [self generateExplosionAt:contact.bodyB.node.position];
    }
}

-(void)handleGameOver{
    // Go to game over scene
    endTime = [[NSDate alloc]init];
    time = [endTime timeIntervalSinceDate:startTime];
    
    //updating and persisting scores!!
    GameDataHelper *statC = [GameDataHelper defaultController];
    statC.score = score;
    statC.time = time;
    NSLog(@"score %i MaxScore %i Time %f MaxTime %f",statC.score,statC.maxScore,statC.time,statC.maxTime);
    if (statC.maxScore < statC.score) {
        statC.maxScore = statC.score;
    }
    if (statC.maxTime < statC.time) {
        statC.maxTime = statC.time;
    }
    NSDictionary *gameStats = @{@"Score":@(statC.score),@"Time":@(statC.time),@"MaxScore":@(statC.maxScore),@"MaxTime":@(statC.maxTime)};
    [statC updatePropertiesWithDict:gameStats];
    
    SKView *skView = (SKView*)self.view;
    SKTransition *reveal = [SKTransition fadeWithColor:[UIColor blackColor] duration:1.0f];
    SKScene* gameOverScene = [GameOverScene sceneWithSize:skView.bounds.size];
    gameOverScene.scaleMode = SKSceneScaleModeAspectFill;
    
    [skView presentScene:gameOverScene transition:reveal];
    
}

-(void) tardisLifeEndedEvent:(SKNode*)tardis{
    
    SKAction *toggleDetectCollision = [SKAction runBlock:^{
        detectCollisonWithTardis = !detectCollisonWithTardis;
    }];
    SKAction *tardisMovement = [_tardis lifeEndedMovement];
    SKAction *action = [SKAction sequence:@[toggleDetectCollision,tardisMovement,toggleDetectCollision]];
    [tardis runAction:action];
    
}

-(void)generateExplosionAt:(CGPoint)position{
    
    SKSpriteNode *explosion = [SKSpriteNode spriteNodeWithTexture:[_explosionTextures objectAtIndex:0]];
    explosion.zPosition = 1;
    explosion.scale = 0.8;
    explosion.position = position;
    [self addChild:explosion];
    SKAction *explosionAction = [SKAction animateWithTextures:_explosionTextures timePerFrame:0.015];
    SKAction *remove = [SKAction removeFromParent];
    [explosion runAction:[SKAction sequence:@[explosionAction,remove]]];
    
}


-(void)setupBackground{
    NSString *starsPath = [[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"];
    SKEmitterNode *stars = [NSKeyedUnarchiver unarchiveObjectWithFile:starsPath];
    stars.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
    stars.zPosition = kZPositionBackground;
    [self addChild:stars];
}

-(void)setupHUD{
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNextCondensed-DemiBold"];
    _scoreLabel.zPosition = kZPositionHUD;
    _scoreLabel.position = CGPointMake(self.frame.size.width*0.90, self.frame.size.height *0.90);
    _scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)score];
    _scoreLabel.fontSize= 50;
    [self addChild:_scoreLabel];
    
    _life1 = [SKSpriteNode spriteNodeWithImageNamed:@"tardis1.png"];
    _life1.zPosition = kZPositionHUD;
    _life1.position = CGPointMake(self.frame.size.width*0.07, self.frame.size.height *0.92);
    _life1.scale = 0.6;
    [self addChild:_life1];
    
    _life2 = [SKSpriteNode spriteNodeWithImageNamed:@"tardis1.png"];
    _life2.zPosition = kZPositionHUD;
    _life2.position = CGPointMake(self.frame.size.width*0.07 + _life1.frame.size.width + 2 , self.frame.size.height *0.92);
    _life2.scale = 0.6;
    [self addChild:_life2];
    
    
    _life3 = [SKSpriteNode spriteNodeWithImageNamed:@"tardis1.png"];
    _life3.zPosition = kZPositionHUD;
    _life3.position = CGPointMake(self.frame.size.width*0.07 + _life1.frame.size.width*2 + 2 , self.frame.size.height *0.92);
    _life3.scale = 0.6;

    [self addChild:_life3];
    
}

-(void)updateHUDScore{
    _scoreLabel.text = [NSString stringWithFormat:@"%d",score];
}

-(void)updateHUDLife{
    if(life==2){
        [_life3 removeFromParent];
    }else if(life == 1){
        [_life2 removeFromParent];
    }
}


-(void) generateAsteroids{
    int randomNumber = [self getRandomNumberBetween:0 to:1];
    if(randomNumber == 0){
        Asteroid *asteroid = [[Asteroid alloc]initWithParent:self];
        [asteroid move];
    }
}



-(void)generateEnemy{
    
    Dalek *dalek = [[Dalek alloc]initWithParent:self];
    
    //generating movement and shooting for the Dalek!
    //For some strange reason this could not be successfully migrated to the Dalek Entity.Oh well...
    CGMutablePathRef cgpath = CGPathCreateMutable();
    //random values
    float yStart = [self getRandomNumberBetween:0 to:self.frame.size.height - dalek.size.height];
    float yEnd = [self getRandomNumberBetween:0 to:self.frame.size.height - dalek.size.height];
    
    //ControlPoint1
    float cp1X = [self getRandomNumberBetween:0+dalek.size.width to:self.frame.size.width-dalek.size.width ];
    float cp1Y = [self getRandomNumberBetween:0+dalek.size.width to:self.frame.size.width-dalek.size.height ];
    
    //ControlPoint2
    float cp2X = [self getRandomNumberBetween:0+dalek.size.width to:self.frame.size.width-dalek.size.width ];
    float cp2Y = [self getRandomNumberBetween:0 to:cp1Y];
    
    CGPoint s = CGPointMake(self.frame.size.width, yStart);
    CGPoint e = CGPointMake(0, yEnd);
    CGPoint cp1 = CGPointMake(cp1X, cp1Y);
    CGPoint cp2 = CGPointMake(cp2X, cp2Y);
    CGPathMoveToPoint(cgpath,NULL, s.x, s.y);
    
    CGPathAddCurveToPoint(cgpath, NULL, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    [self addChild:dalek];
    
    SKAction *enemyPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:[self getRandomNumberBetween:5 to:7]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *moveEnemy = [SKAction sequence:@[enemyPath,remove]];
    
    SKAction *shoot = [SKAction runBlock:^{
        CGPoint position = dalek.position;
        [self shootEnemyBullets:(CGPoint)position];
    }];
    SKAction *waitBeforeNextBullet = [SKAction waitForDuration:1];
    SKAction *shootBullet = [SKAction sequence:@[shoot,waitBeforeNextBullet]];
    SKAction *shootBullets = [SKAction repeatActionForever:shootBullet];
    
    [dalek runAction:[SKAction group:@[moveEnemy,shootBullets]]];
    
    CGPathRelease(cgpath);
    
}

-(void)shootEnemyBullets:(CGPoint)position{
    
    SKSpriteNode *enemyBullet = [SKSpriteNode spriteNodeWithImageNamed:@"DalekBullet.png"];
    enemyBullet.position = position ;
    enemyBullet.zPosition = kZPositionFront;
    enemyBullet.name = enemyBulletCategoryName;
    enemyBullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyBullet.size.height/2];
    enemyBullet.physicsBody.categoryBitMask = enemyBulletCategory;
    enemyBullet.physicsBody.collisionBitMask = tardisCategory|bulletCategory;
    [self addChild:enemyBullet];
    [enemyBullet.physicsBody applyImpulse:CGVectorMake(-20, 0)];
    
}

-(void)generateSpaceDust{
    int randomSpaceDust = [self getRandomNumberBetween:0 to:1];
    if(randomSpaceDust == 1){
        int whichDust = [self getRandomNumberBetween:0 to:6];
        SKSpriteNode *dust = [SKSpriteNode spriteNodeWithTexture:[_spaceDustTextures objectAtIndex:whichDust]];
        int randomYAxix = [self getRandomNumberBetween:0 to:self.frame.size.height];
        dust.position = CGPointMake(self.frame.size.width + dust.size.width/2, randomYAxix);
        int randomDustTime = [self getRandomNumberBetween:7 to:10];
        
        SKAction *move =[SKAction moveTo:CGPointMake(0-dust.size.height, randomYAxix) duration:randomDustTime*10];
        SKAction *remove = [SKAction removeFromParent];
        [dust runAction:[SKAction sequence:@[move,remove]]];
        dust.zPosition = kZPositionBackground;
        [self addChild:dust];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if(detectCollisonWithTardis){
        CGPoint location = [_tardis position];
        
        SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithImageNamed:@"Bullet.png"];
        bullet.scale = 0.4;
        bullet.position = CGPointMake(location.x,location.y);
        bullet.zPosition = kZPositionFront;
        bullet.physicsBody= [SKPhysicsBody bodyWithCircleOfRadius:bullet.size.height/2];
        bullet.name = bulletCategoryName;
        bullet.physicsBody.categoryBitMask = bulletCategory;
        bullet.physicsBody.contactTestBitMask = asteroidCategory|enemyBulletCategory|enemyCategory;
        [self addChild:bullet];
        
        
        NSString *bulletTrailPath = [[NSBundle mainBundle] pathForResource:@"Pulse" ofType:@"sks"];
        SKEmitterNode *bulletTrail = [NSKeyedUnarchiver unarchiveObjectWithFile:bulletTrailPath];
        [bullet addChild:bulletTrail];
        bulletTrail.targetNode= self;
        
        [bullet.physicsBody applyImpulse:CGVectorMake(50, 0)];
        
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}

@end
