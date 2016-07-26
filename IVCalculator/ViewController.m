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
@synthesize arrEvolutions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    arrBaseStats = [[NSMutableArray alloc] init];
    arrPokemons = [[NSArray alloc] init];
    arrLevels = [[NSMutableArray alloc] init];
    arrStardust = [[NSMutableArray alloc] init];
    arrEvolutions = [[NSMutableArray alloc] init];
    
    [self initBaseData];
    
}

-(void) initBaseData
{
    NSString *strDataPath = [[NSBundle mainBundle] pathForResource:@"pokemon" ofType:@"plist"];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithContentsOfFile:strDataPath];
    
    arrEvolutions = [dicData objectForKey:@"evolutions"];
    arrBaseStats = [dicData objectForKey:@"baseStats"];
    
    NSMutableArray *arrTmpPokemons = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicBaseStats in arrBaseStats) {
        [arrTmpPokemons addObject:[dicBaseStats valueForKey:@"pokemon"]];
    }
    
    arrPokemons = [arrTmpPokemons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
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
        
        for (NSMutableDictionary *dicData in arrBaseStats) {
            NSString *strPokemon = [dicData valueForKey:@"pokemon"];
            if ([strPokemon isEqualToString:arrPokemons[selectedIndex]]) {
                NSString *strAttack = [dicData valueForKey:@"attack"];
                NSString *strDefense = [dicData valueForKey:@"defense"];
                NSString *strStamina = [dicData valueForKey:@"stamina"];
                
                self.txtPokemon.text = strPokemon;
                self.txtSTA.text = strStamina;
                self.txtATT.text = strAttack;
                self.txtDEF.text = strDefense;
                
                break;
            }
        }
        
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
    NSString *strCP = self.txtCP.text;
    if ([strCP isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please input CP." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    int cp = [strCP intValue];
    
    for (NSMutableDictionary *dicEvolution in arrEvolutions) {
        NSString *strPokemonName = [dicEvolution valueForKey:@"pokemon"];
        if ([strPokemonName isEqualToString:self.txtPokemon.text]) {
            NSDictionary *dicYellowEvolution = [dicEvolution objectForKey:@"yellowEvolution"];
            if (dicYellowEvolution)
            {
                NSString *strYellowName = [dicYellowEvolution valueForKey:@"name"];
                float multiplierMin = [[dicYellowEvolution valueForKey:@"min"] floatValue];
                float multiplierMax = [[dicYellowEvolution valueForKey:@"max"] floatValue];
                int yellowRangeMin = cp * multiplierMin;
                int yellowRangeMax = cp * multiplierMax;
                NSString *strYellowRange = [NSString stringWithFormat:@"%d~%d", yellowRangeMin, yellowRangeMax];
                
                self.lblEvolutionName1.text = strYellowName;
                self.txtEvolutionRange1.text = strYellowRange;
                
            }
            NSDictionary *dicRedEvolution = [dicEvolution objectForKey:@"redEvolution"];
            if (dicRedEvolution)
            {
                NSString *strRedName = [dicRedEvolution valueForKey:@"name"];
                float multiplierMin = [[dicRedEvolution valueForKey:@"min"] floatValue];
                float multiplierMax = [[dicRedEvolution valueForKey:@"max"] floatValue];
                int redRangeMin = cp * multiplierMin;
                int redRangeMax = cp * multiplierMax;
                NSString *strRedRange = [NSString stringWithFormat:@"%d~%d", redRangeMin, redRangeMax];
                
                self.lblEvolutionName2.text = strRedName;
                self.txtEvolutionRange2.text = strRedRange;
                
            }
            
            
        }
    }
    
    
    
    
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
