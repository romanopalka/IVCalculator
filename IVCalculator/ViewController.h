//
//  ViewController.h
//  IVCalculator
//
//  Created by Roman on 7/25/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnPokemon;
@property (strong, nonatomic) IBOutlet UITextField *txtCP;
@property (strong, nonatomic) IBOutlet UITextField *txtHP;
@property (strong, nonatomic) IBOutlet UITextField *txtDustPrice;

@property (strong, nonatomic) IBOutlet UITextField *txtPerfectCP;
@property (strong, nonatomic) IBOutlet UITextField *txtPerfectHP;
@property (strong, nonatomic) IBOutlet UITextField *txtIVI;
@property (strong, nonatomic) IBOutlet UITextField *txtSTA;
@property (strong, nonatomic) IBOutlet UITextField *txtATT;
@property (strong, nonatomic) IBOutlet UITextField *txtDEF;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


- (IBAction)onPokemon:(id)sender;

@end

