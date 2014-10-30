//
//  GameDataController.m
//  TardisDash
//
//  Created by Nikanj Gupta Vemala on 10/7/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "GameDataHelper.h"

@implementation GameDataHelper


static GameDataHelper *defaultController = nil;

+ (GameDataHelper *)defaultController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultController = [[GameDataHelper alloc] init];
        NSDictionary *statsD = [defaultController readGameStatsFromPlist];
        [defaultController updatePropertiesWithDict:statsD];
        });
    return defaultController;
}

- (void)updatePropertiesWithDict:(NSDictionary *)dict
{
    self.score = [dict[@"Score"] intValue];
    self.time = [dict[@"Time"] doubleValue];
    self.maxScore = [dict[@"MaxScore"] intValue];
    self.maxTime = [dict[@"MaxTime"] doubleValue];
    NSLog(@"Updated properties upd%@",dict);
}

- (void)savePropertiesToPlist
{
    NSDictionary *statsD = [self dictionaryFromProperties];
    [self saveGameStatsToPlist:statsD];
}

- (NSDictionary *)dictionaryFromProperties
{
    NSDictionary *statsD = @{
                             @"Score" : @(self.score),
                             @"Time" : @(self.time),
                             @"MaxScore" : @(self.maxScore),
                             @"MaxTime" : @(self.maxTime)
                             };
    return statsD;
}

- (NSDictionary *)readGameStatsFromPlist;
{
    
    
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"GameStats.plist"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"GameStats" ofType:@"plist"];
    }
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    if (dict != nil) {
        NSLog(@"Read game stats from plist: %@", dict);
    } else {
        NSLog(@"Could not read plist at path %@", plistPath);
    }
    
    return dict;
}

- (BOOL)saveGameStatsToPlist:(NSDictionary *)dict;
{
    
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"GameStats.plist"];
    
    
    BOOL success = [dict writeToFile:plistPath atomically:YES];
    
    
    if(success) {
        NSLog(@"Saved game stats to plist: %@", dict);
        [[GameDataHelper defaultController] updatePropertiesWithDict:dict];
        return YES;
    } else {
        NSLog(@"Could not save to plist at path %@", plistPath);
        return NO;
    }
    
    
    
}

@end
