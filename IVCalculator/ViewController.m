//
//  ViewController.m
//  IVCalculator
//
//  Created by Roman on 7/25/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import "ViewController.h"
#import "ActionSheetStringPicker.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize arrBaseStats;
@synthesize arrPokemons;
@synthesize arrLevels;
@synthesize arrStardust;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    arrBaseStats = [[NSMutableArray alloc] init];
    arrPokemons = [[NSMutableArray alloc] init];
    arrLevels = [[NSMutableArray alloc] init];
    arrStardust = [[NSMutableArray alloc] init];
    
    [self initBaseData];
    
}

-(void) initBaseData
{
    NSString *strDataPath = [[NSBundle mainBundle] pathForResource:@"pokemon" ofType:@"plist"];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithContentsOfFile:strDataPath];
    
    arrBaseStats = [dicData objectForKey:@"baseStats"];
    for (NSMutableDictionary *dicBaseStats in arrBaseStats) {
        [arrPokemons addObject:[dicBaseStats valueForKey:@"pokemon"]];
    }
    
    
    NSMutableArray *arrLevelsByStardust = [dicData objectForKey:@"levelsByStardust"];
    
    for (NSMutableDictionary *dic in arrLevelsByStardust) {
        
        [arrLevels addObject:[dic valueForKey:@"level"]];
        [arrStardust addObject:[dic valueForKey:@"stardust"]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notification
-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.bottomConstraint.constant = keyboardSize.height;
}

-(void)keyboardWillBeHidden:(NSNotification*)notification
{
    self.bottomConstraint.constant = 50.0f;
}


#pragma mark - button event

- (IBAction)onPokemon:(id)sender {
    
    [self hideKeyboard];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Pokemon" rows:arrPokemons initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        NSMutableDictionary *dicData = arrBaseStats[selectedIndex];
        NSString *strPokemon = [dicData valueForKey:@"pokemon"];
        NSString *strAttack = [dicData valueForKey:@"attack"];
        NSString *strDefense = [dicData valueForKey:@"defense"];
        NSString *strStamina = [dicData valueForKey:@"stamina"];
        
        self.txtPokemon.text = strPokemon;
        self.txtSTA.text = strStamina;
        self.txtATT.text = strAttack;
        self.txtDEF.text = strDefense;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.txtPokemon];
}

- (IBAction)onDustPrice:(id)sender {
    
    [self hideKeyboard];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Dust Price" rows:arrStardust initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSString *strDustPrice = arrStardust[selectedIndex];
        self.txtDustPrice.text = strDustPrice;
        self.txtLVL.text = arrLevels[selectedIndex];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.txtDustPrice];
                     
}

- (IBAction)onCalc:(id)sender {
    
}

-(void)hideKeyboard
{
    [self.txtCP resignFirstResponder];
    [self.txtHP resignFirstResponder];
}

#pragma mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self deregisterFromKeyboardNotifications];
    [super viewWillDisappear:animated];
}



@end
