//
//  PokemonTableCell.h
//  IVCalculator
//
//  Created by Roman on 7/29/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PokemonT.h"

@interface PokemonTableCell : UITableViewCell
{
    int attack;
    int defense;
    int stamina;
    float mLevel;
}

@property (strong, nonatomic) NSMutableArray *mArrBaseData;
@property (strong, nonatomic) NSArray *mArrPokemons;
@property (strong, nonatomic) NSMutableArray *mArrLevels;
@property (strong, nonatomic) NSMutableArray *mArrStardust;
@property (strong, nonatomic) NSMutableArray *mArrEvolutions;



@property (strong, nonatomic) IBOutlet UITextField *txtPokemon;
@property (strong, nonatomic) IBOutlet UITextField *txtCP;
@property (strong, nonatomic) IBOutlet UITextField *txtHP;
@property (strong, nonatomic) IBOutlet UITextField *txtDustPrice;

@property (strong, nonatomic) IBOutlet UITextField *txtPercentPerfect;
@property (strong, nonatomic) IBOutlet UIView *messageView;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;


@property (strong, nonatomic) IBOutlet UIView *firstEvolutionView;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionName1;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionRange1;
@property (strong, nonatomic) IBOutlet UIView *evolutionRangeBackground1;

@property (strong, nonatomic) IBOutlet UIView *secondEvolutionView;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionName2;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionRange2;
@property (strong, nonatomic) IBOutlet UIView *evolutionRangeBackground2;

@property (strong, nonatomic) IBOutlet UIView *thirdEvolutionView;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionName3;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionRange3;
@property (strong, nonatomic) IBOutlet UIView *evolutionRangeBackground3;


@property (strong, nonatomic) IBOutlet UIButton *btnCalc;

- (IBAction)onPokemon:(id)sender;
- (IBAction)onDustPrice:(id)sender;

- (IBAction)onCalc:(id)sender;

@end
