//
//  ViewController.m
//  IVCalculator
//
//  Created by Roman on 7/25/16.
//  Copyright © 2016 Roman. All rights reserved.
//

#import "ViewController.h"
#import "PokemonT.h"
#import "ActionSheetStringPicker.h"

@interface ViewController ()
{
    
}
@end

@implementation ViewController
@synthesize mArrBaseData;
@synthesize mArrPokemons;
@synthesize mArrLevels;
@synthesize mArrStardust;
@synthesize mArrEvolutions;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mArrBaseData = [[NSMutableArray alloc] init];
    mArrPokemons = [[NSArray alloc] init];
    mArrLevels = [[NSMutableArray alloc] init];
    mArrStardust = [[NSMutableArray alloc] init];
    mArrEvolutions = [[NSMutableArray alloc] init];
    
    self.messageView.layer.borderWidth = 1.0f;
    self.messageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.messageView.layer.cornerRadius = 5.0f;
    
    self.btnCalc.layer.borderWidth = 1.0f;
    self.btnCalc.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnCalc.layer.cornerRadius = 3.0f;
    
    
    attack = defense = stamina = -1;
    mLevel = 0;
    
    [self hideEvolutions];
    [self initBaseData];
    
}

-(void) initBaseData
{
    NSString *strDataPath = [[NSBundle mainBundle] pathForResource:@"pokemon" ofType:@"plist"];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithContentsOfFile:strDataPath];
    
    mArrBaseData = [dicData objectForKey:@"baseData"];
    
    NSMutableArray *arrTmpPokemons = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dicBaseStats in mArrBaseData) {
        [arrTmpPokemons addObject:[dicBaseStats valueForKey:@"pokemon"]];
    }
    
    mArrPokemons = [arrTmpPokemons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSMutableArray *arrLevelsByStardust = [dicData objectForKey:@"levelsByStardust"];
    
    for (NSMutableDictionary *dic in arrLevelsByStardust) {
        
        [mArrLevels addObject:[dic valueForKey:@"level"]];
        [mArrStardust addObject:[dic valueForKey:@"stardust"]];
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
    
    [ActionSheetStringPicker showPickerWithTitle:@"Pokemon" rows:mArrPokemons initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        for (NSMutableDictionary *dicData in mArrBaseData)
        {
            NSString *strPokemon = [dicData valueForKey:@"pokemon"];
            if ([strPokemon isEqualToString:mArrPokemons[selectedIndex]])
            {
                NSString *strAttack = [dicData valueForKey:@"attack"];
                NSString *strDefense = [dicData valueForKey:@"defense"];
                NSString *strStamina = [dicData valueForKey:@"stamina"];
                
                attack = [strAttack intValue];
                defense = [strDefense intValue];
                stamina = [strStamina intValue];
                
                self.txtPokemon.text = strPokemon;
                
                self.txtCP.text = @"";
                self.txtHP.text = @"";
                self.txtPercentPerfect.text = @"";
                
                [self hideEvolutions];
                
                break;
            }
        }
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.txtPokemon];
}

- (IBAction)onDustPrice:(id)sender {
    
    [self hideKeyboard];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Dust Price" rows:mArrStardust initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSString *strDustPrice = mArrStardust[selectedIndex];
        self.txtDustPrice.text = strDustPrice;
        
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.txtDustPrice];
                     
}

- (IBAction)onCalc:(id)sender
{
    self.lblMessage.text = @"";
    NSString *strPokemonName = self.txtPokemon.text;
    NSString *strCP = self.txtCP.text;
    
    if ([strPokemonName isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select pokemon name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([strCP isEqual:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please input CP." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    int cp = [strCP intValue];
    
    [mArrEvolutions removeAllObjects];
    [self calculatorEvolution:strPokemonName min:cp max:cp];
    
    if ([mArrEvolutions count] > 0) {
        [self showEvolutions];
    }
    
    [self calcPercent];
    
}


#pragma mark - calulate Evolutions
-(void)showEvolutions
{
    
    for (int i = 0; i < mArrEvolutions.count; i++)
    {
        NSMutableDictionary *dicData = mArrEvolutions[i];
        NSString *strEvolutionName = [dicData valueForKey:@"name"];
        NSString *strEvolutionRange = [dicData valueForKey:@"range"];
        
        switch (i) {
            case 0:
                self.lblEvolutionName1.text = strEvolutionName;
                self.txtEvolutionRange1.text = strEvolutionRange;
                break;
            case 1:
                [self.secondEvolutionView setHidden:NO];
                self.lblEvolutionName2.text = strEvolutionName;
                self.txtEvolutionRange2.text = strEvolutionRange;
                break;
            case 2:
                [self.thirdEvolutionView setHidden:NO];
                self.lblEvolutionName3.text = strEvolutionName;
                self.txtEvolutionRange3.text = strEvolutionRange;
                break;
                
            default:
                break;
        }
        
    }
}

-(void)hideEvolutions
{
    self.lblEvolutionName1.text = @"";
    self.lblEvolutionName2.text = @"";
    self.lblEvolutionName3.text = @"";
    
    self.txtEvolutionRange1.text = @"";
    self.txtEvolutionRange2.text = @"";
    self.txtEvolutionRange3.text = @"";
    
    self.lblMessage.text = @"";
    
    [self.secondEvolutionView setHidden:YES];
    [self.thirdEvolutionView setHidden:YES];
}

-(void)calculatorEvolution:(NSString*)strPokemonName min:(int)minValue max:(int)maxValue
{
    for (NSMutableDictionary *dicData in mArrBaseData) {
        if ([strPokemonName isEqualToString:[dicData valueForKey:@"pokemon"]])
        {
            NSMutableArray *arrEvolutions = [dicData objectForKey:@"evolutions"];
            if (arrEvolutions) {
                for (NSMutableDictionary *dicEvolution in arrEvolutions)
                {
                    NSString *strEvolutionName = [dicEvolution valueForKey:@"name"];
                    float multiplierMin = [[dicEvolution valueForKey:@"min"] floatValue];
                    float multiplierMax = [[dicEvolution valueForKey:@"max"] floatValue];
                    int evolutionMin = minValue * multiplierMin;
                    int evolutionMax = maxValue * multiplierMax;
                    NSString *strEvolutionRange = [NSString stringWithFormat:@"%d~%d", evolutionMin, evolutionMax];
                    
                    NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
                    [dicTemp setValue:strEvolutionName forKey:@"name"];
                    [dicTemp setValue:strEvolutionRange forKey:@"range"];
                    [mArrEvolutions addObject:dicTemp];
                    
                    [self calculatorEvolution:strEvolutionName min:evolutionMin max:evolutionMax];
                }
            }
            else
            {
                return;
            }
            
            
            break;
        }
    }
}

#pragma mark - calculate percent perfect
-(void)calcPercent
{
    NSString *strPokemonName = self.txtPokemon.text;
    NSString *strCP = self.txtCP.text;
    NSString *strHP = self.txtHP.text;
    
    if ([strPokemonName isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select pokemon name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([strCP isEqual:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please input CP." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([strHP isEqual:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please input HP." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSString *strDustPrice = self.txtDustPrice.text;
    for (int i = 0; i < mArrStardust.count; i++)
    {
        if ([strDustPrice isEqualToString:mArrStardust[i]]) {
            mLevel = [mArrLevels[i] floatValue];
            break;
        }
    }
    
    
    int cp = [strCP intValue];
    int hp = [strHP intValue];
    
    PokemonT *p = [[PokemonT alloc] initWithCP:cp HP:hp Level:mLevel ATT:attack DEF:defense STA:stamina];
    
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSString *strMessage = @"";
    for ( float l = p.mLevelMin; l <= p.mLevelMax; l += 1 ) {
        BOOL valid = [p setLevel:l];
        
        if (valid) {
            NSLog(@"%f, %f, %f", p.mIV_ATT, p.mIV_DEF, p.mIV_STA);
            
            float percentPerfect = (p.mIV_ATT + p.mIV_DEF + p.mIV_STA) / 45.0f * 100;
            NSString *strPercentPerfect = [NSString stringWithFormat:@"%.2f", percentPerfect];
            [arrResult addObject:strPercentPerfect];
            
            if (percentPerfect > 0.0f && percentPerfect < 45.0f )
            {
                strMessage = @"Below Average";
            } else if (percentPerfect >= 45.0f && percentPerfect < 55.0f) {
                strMessage = @"Average";
            } else if (percentPerfect >= 55.0f && percentPerfect < 70.0f) {
                strMessage = @"Pretty Good";
            } else if (percentPerfect >= 70.0f && percentPerfect < 90.0f) {
                strMessage = @"Not perfect, but still great!";
            } else if (percentPerfect >= 90.0f && percentPerfect < 100.0f) {
                strMessage = @"Practically Perfect!";
            }
            
        }
    }

    if (arrResult.count == 1) {
        self.txtPercentPerfect.text = arrResult[0];
        self.lblMessage.text = strMessage;
    }
    
    
    
}

#pragma mark -
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
