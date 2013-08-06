//
//  TempViewController.h
//  temperature
//
//  Created by Mukund on 06/08/13.
//  Copyright (c) 2013 Mukund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *fahrenheitText;
@property (nonatomic, strong) IBOutlet UITextField *celsiusText;
@property (nonatomic, strong) IBOutlet UIButton    *convertButton;

@end
