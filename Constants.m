//
//  Constants.m
//  TardisDash
//
//  Created by Abhijith Srivatsav on 10/10/13.
//  Copyright (c) 2013 Abhijith Srivatsav. All rights reserved.
//

#import "Constants.h"

NSString* const tardisCategoryName = @"tardis";
NSString* const bulletCategoryName = @"bullet";
NSString* const asteroidCategoryName = @"asteroid";
NSString* const enemyCategoryName = @"enemy";
NSString* const enemyBulletCategoryName = @"enemyBullet";

const uint32_t tardisCategory = 0x1 << 0;
const uint32_t bulletCategory = 0x1 << 1;
const uint32_t asteroidCategory = 0x1 << 2;
const uint32_t enemyCategory = 0x1 << 3;
const uint32_t enemyBulletCategory = 0x1 << 4;
