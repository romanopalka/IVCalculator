//
//  PokemonT.h
//  IVCalculator
//
//  Created by Roman on 7/29/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PokemonT : NSObject
{
    float mLevel;
    
    float mHP;
    float mCP;
    float mATT;
    float mDEF;
    float mSTA;
    
}

@property float mLevelMin;
@property float mLevelMax;
@property float mIV_ATT;
@property float mIV_DEF;
@property float mIV_STA;

@property (strong, nonatomic) NSMutableArray *mArrCPMultiplier;


-(id)initWithCP:(float)cp HP:(float)hp Level:(float)level ATT:(float)att DEF:(float)def STA:(float)sta;

-(BOOL)setLevel:(float)level;

-(float)round:(float)x places:(int)places;

@end
