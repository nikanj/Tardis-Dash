//
//  GameDataHelper.h
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/9/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDataHelper : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) double time;
@property (nonatomic, assign) int maxScore;
@property (nonatomic, assign) double maxTime;



+ (GameDataHelper *)defaultController;
- (void)updatePropertiesWithDict:(NSDictionary *)dict;
- (void)savePropertiesToPlist;
- (NSDictionary *)dictionaryFromProperties;


- (NSDictionary *)readGameStatsFromPlist;


- (BOOL)saveGameStatsToPlist:(NSDictionary *)dict;
@end
