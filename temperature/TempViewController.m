//
//  TempViewController.m
//  temperature
//
//  Created by Mukund on 06/08/13.
//  Copyright (c) 2013 Mukund. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController ()
{
//BOOL toCelsiusFlag; On talking to Rohit he mentioned that this is not a good choice so went with property.
}

@property(nonatomic, assign) BOOL toCelsiusFlag;

- (void) updateValues;
- (void) convertTemperature;
- (void) tapHandler:(UITapGestureRecognizer *) gesture;

@end

@implementation TempViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Temperature";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fahrenheitText.text = @"32";
    self.celsiusText.text = @"0";
    
    self.fahrenheitText.delegate = self;
    self.celsiusText.delegate = self;
    self.toCelsiusFlag = YES;
  
    // Found simpler choice in XIB's custom button after talking to Rohit
    //[self.convertButton setBackgroundImage:[self imageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
    
    // The decimal keypad does not have the return. Hence enable gesture on touching anywhere in the App
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:tapRecognizer];

    [self.convertButton addTarget:self action:@selector(convertTemperature) forControlEvents:UIControlEventAllTouchEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.celsiusText) {
        self.toCelsiusFlag = NO;
        self.fahrenheitText.userInteractionEnabled = NO;
        //Unable to make the other textfield transparent/translucent
        //self.fahrenheitText.opaque = NO;
        [self.fahrenheitText setBackgroundColor:[UIColor grayColor]];
    } else {
        self.toCelsiusFlag = YES;
        self.celsiusText.userInteractionEnabled = NO;
        //Unable to make the text transparent/translucent
        //self.celsiusText.opaque = NO;
        [self.celsiusText setBackgroundColor:[UIColor grayColor]];
    }
    [self.convertButton setBackgroundColor:[UIColor grayColor]];
    return YES;
}


// This is no longer needed as the Decimal keypad does not have the return key
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self updateValues];
    return YES;
}
    

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    // Updating here is not needed
    // [self updateValues];
    return YES;
}


// Modidifed this simple implementation from Stackoverflow...
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2 )
        return NO;
    
    // Does not catch all the cases of invalid chars like 33., .45 etc.
    // The decimal keypad does not allow -ve numbers. Probably a separate button is needed to simplify life
    // to invert the sign.
    return YES;
}

#pragma mark - private methods

- (void) tapHandler: (UITapGestureRecognizer *) gesture {
    [self.view endEditing:YES];
}


- (void) convertTemperature {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void) updateValues {
    
    if (self.toCelsiusFlag) {
        // Any empty text evaluates to 0 fahrenheit. On simulator you can enter text and this gets
        // converted to float by Xcode. I am ignoring the simulator case as the app on a real device will
        // not have this issue
        if ([self.fahrenheitText.text length] == 0) {
            self.fahrenheitText.text = @"0";
        }
        float fahrenheit = [self.fahrenheitText.text floatValue];
        float celsius = ((fahrenheit - 32) * 5.0)/9.0;
        self.celsiusText.text = [NSString stringWithFormat:@"%0.1f", celsius];
        self.celsiusText.userInteractionEnabled = YES;
        [self.celsiusText setBackgroundColor:[UIColor clearColor]];
    } else {
        // Any empty text evaluates to 0 Celsius. On simulator you can enter text and this gets
        // converted to float by Xcode. I am ignoring the simulator case as the app on a real device will
        // not have this issue
        if ([self.celsiusText.text length] == 0) {
            self.celsiusText.text = @"0";
        }
        float celsius = [self.celsiusText.text floatValue];
        float fahrenheit = ((celsius * 9.0)/5.0 + 32.0);
        self.fahrenheitText.text = [NSString stringWithFormat:@"%0.1f", fahrenheit];
        self.fahrenheitText.userInteractionEnabled = YES;
        [self.fahrenheitText setBackgroundColor:[UIColor clearColor]];
    }
    [self.convertButton setBackgroundColor:[UIColor greenColor]];
}


@end
