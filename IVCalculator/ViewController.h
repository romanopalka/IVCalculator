//
//  ViewController.h
//  IVCalculator
//
//  Created by Roman on 7/25/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
{
    
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

@property (strong, nonatomic) IBOutlet UITextField *txtPerfectCP;
@property (strong, nonatomic) IBOutlet UITextField *txtPerfectHP;
@property (strong, nonatomic) IBOutlet UITextField *txtLVL;
@property (strong, nonatomic) IBOutlet UITextField *txtSTA;
@property (strong, nonatomic) IBOutlet UITextField *txtATT;
@property (strong, nonatomic) IBOutlet UITextField *txtDEF;

@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionName1;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionName2;
@property (strong, nonatomic) IBOutlet UILabel *lblEvolutionName3;

@property (strong, nonatomic) IBOutlet UITextField *txtEvolutionRange1;
@property (strong, nonatomic) IBOutlet UITextField *txtEvolutionRange2;
@property (strong, nonatomic) IBOutlet UITextField *txtEvolutionRange3;




@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


- (IBAction)onPokemon:(id)sender;
- (IBAction)onDustPrice:(id)sender;




- (IBAction)onCalc:(id)sender;

@end

