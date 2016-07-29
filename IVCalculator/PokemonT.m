//
//  PokemonT.m
//  IVCalculator
//
//  Created by Roman on 7/29/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import "PokemonT.h"


@implementation PokemonT
@synthesize mLevelMin;
@synthesize mLevelMax;
@synthesize mIV_ATT;
@synthesize mIV_DEF;
@synthesize mIV_STA;
@synthesize mArrCPMultiplier;

-(id)initWithCP:(float)cp HP:(float)hp Level:(float)level ATT:(float)att DEF:(float)def STA:(float)sta
{
    if (![self init])
        return nil;
    
    mCP = cp;
    mHP = hp;
    mLevelMin = level;
    mLevelMax = level + 1.5f;
    
    mATT = att; mDEF = def; mSTA = sta;
    
    mIV_ATT = mIV_DEF = mIV_STA = -1;
    
    [self setLevel:level];
    
    mArrCPMultiplier = [[NSMutableArray alloc] init];
    
    return self;
}


-(BOOL)setLevel:(float)level
{
    mLevel = level;
    
    float minHP = [self getHP:0];
    float maxHP = [self getHP:15];
    
    if ( mHP < minHP || mHP > maxHP) {
        return false;
    }
    
    
    float min = [self clamp:0 x:(mHP / [self getCpMultiplier]) - mSTA max:15];
    float max = [self clamp:0 x:((mHP + 1.0) / [self getCpMultiplier]) - mSTA max:15];
    mIV_STA = ( min + max ) / 2;
    
    if ( mCP < [self getCp:min att:0 def:0] || mCP > [self getCp:max att:15 def:15])
    {
        return false;
    }
    
    float bestDistance = FLT_MAX;
    float bestIV = 0;
    
    // calculate ATT and DEF IVs, assuming ATT = DEF
    for ( float x = -0.05; x <= 15.05; x += 0.05 ) {
        float cp = [self getCp:-1 att:x def:x];
        
        if ( fabsf( mCP - cp ) < bestDistance ) {
            bestDistance = fabs( mCP - cp );
            bestIV = x;
        }
    }
    
    mIV_ATT = bestIV;
    mIV_DEF = bestIV;
    
    return true;
}

-(float)getHP:(float)sta
{
    return floor([self compositeSTA:sta]);
}

-(float)compositeSTA:(float)iv
{
    if (iv == -1)
        iv = mIV_STA;
    
    return ( mSTA + iv ) * [self getCpMultiplier];

}

-(float)compositeATT:(float)iv
{
    if (iv == -1)
        iv = mIV_ATT;
    
    return (mATT + iv) * [self getCpMultiplier];
}

-(float)compositeDEF:(float)iv
{
    if (iv == -1)
        iv = mIV_DEF;
    return (mDEF + iv ) * [self getCpMultiplier];
}

-(float)getCp:(float)sta att:(float)att def:(float)def
{
    return floor( 0.1 * pow([self compositeSTA:sta], 0.5 ) * [self compositeATT:att] * pow([self compositeDEF:def], 0.5));
}

-(float)clamp:(float)min x:(float)x max:(float)max
{

    return MIN(MAX(min, x), max);
}

-(float)getCpMultiplier
{
    return [self getCpMultiplier:mLevel];
}

-(float)getCpMultiplier:(float)level
{
    NSString *strDataPath = [[NSBundle mainBundle] pathForResource:@"pokemon" ofType:@"plist"];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithContentsOfFile:strDataPath];
    
    mArrCPMultiplier = [dicData objectForKey:@"CPMultiplierByLevel"];
    
    for (NSMutableDictionary *dicCPMultiplier in mArrCPMultiplier)
    {
        float lvl = [[dicCPMultiplier valueForKey:@"level"] floatValue];
        if (lvl == level)
        {
            float cpMultiplier = [[dicCPMultiplier valueForKey:@"multiplier"] floatValue];
            
            return cpMultiplier;
        }
    }
    return -1;
}

@end
