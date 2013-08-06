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
    
//BOOL toCelsiusFlag;
}

@property(nonatomic, assign) BOOL toCelsiusFlag;

- (void) updateValues;
- (void) convertTemperature;
- (void) tapHandler:(UITapGestureRecognizer *) gesture;
- (UIImage*) imageWithColor:(UIColor *) color;

@end

@implementation TempViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Temperature";
        //toCelsiusFlag = YES;
        //[self updateValues];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fahrenheitText.text = @"";
    self.celsiusText.text = @"";
    
    //I was able to set this in the xib itself. But this disables the return key
    //self.celsiusText.keyboardType = UIKeyboardTypeDecimalPad;
    //self.fahrenheitText.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.fahrenheitText.delegate = self;
    self.celsiusText.delegate = self;
    self.toCelsiusFlag = YES;
    
    [self.convertButton setBackgroundImage:[self imageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
    
    // Disable the decimal keypad as it does not have the return
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:tapRecognizer];

    [self.convertButton addTarget:self action:@selector(convertTemperature) forControlEvents:UIControlEventAllTouchEvents];
    // Do any additional setup after loading the view from its nib.
    //[self updateValues];
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
        //Unable to make the text transparent/translucent
        //self.fahrenheitText.opaque = NO;
    } else {
        self.toCelsiusFlag = YES;
        self.celsiusText.userInteractionEnabled = NO;
        //Unable to make the text transparent/translucent
        //self.celsiusText.opaque = NO;
    }
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
        // Any empty text evaluates to 0 fahrenheit
        float fahrenheit = [self.fahrenheitText.text floatValue];
        float celsius = ((fahrenheit - 32) * 5.0)/9.0;
        self.celsiusText.text = [NSString stringWithFormat:@"%0.1f", celsius];
        self.celsiusText.userInteractionEnabled = YES;
    } else {
        // Any empty non 0 text evaluates to 0 Celsius
        if (self.celsiusText.text == NULL) {
            self.celsiusText.text = @"0.0";
        }
        float celsius = [self.celsiusText.text floatValue];
        float fahrenheit = ((celsius * 9.0)/5.0 + 32.0);
        self.fahrenheitText.text = [NSString stringWithFormat:@"%0.1f", fahrenheit];
        self.fahrenheitText.userInteractionEnabled = YES;
    }
}

// I have borrowed/copied this from stackoverflow. I do not like this solution - looks overly complicated
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
