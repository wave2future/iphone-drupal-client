//
//  Drupal_ExampleViewController.h
//  Drupal Example
//
//  Created by Steve on 10/03/09.
//  Copyright Eighty Elements 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Drupal_ExampleAppDelegate.h"


@interface Drupal_ExampleViewController : UIViewController <UITextFieldDelegate, DrupalClientDelegate> {
    IBOutlet UITextField *input;
    IBOutlet UITextField *paramsInput;    
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UITextView *output;
    
    Drupal_ExampleAppDelegate* appDelegate;
}


@property (nonatomic, retain) UITextField *input;
@property (nonatomic, retain) UITextField *paramsInput;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UITextView *output;

@property (nonatomic, assign) Drupal_ExampleAppDelegate* appDelegate;


- (IBAction)sendRequest:(UIButton *)sender;


@end

