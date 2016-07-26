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
@property (strong, nonatomic) NSMutableArray *arrBaseStats;
@property (strong, nonatomic) NSMutableArray *arrPokemons;
@property (strong, nonatomic) NSMutableArray *arrLevels;
@property (strong, nonatomic) NSMutableArray *arrStardust;


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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


- (IBAction)onPokemon:(id)sender;
- (IBAction)onDustPrice:(id)sender;




- (IBAction)onCalc:(id)sender;

@end

