//
//  Drupal_ExampleViewController.m
//  Drupal Example
//
//  Created by Steve on 10/03/09.
//  Copyright Eighty Elements 2009. All rights reserved.
//

#import "Drupal_ExampleViewController.h"


@implementation Drupal_ExampleViewController


@synthesize input;
@synthesize paramsInput;
@synthesize indicator;
@synthesize output;

@synthesize appDelegate;


/**
 *  If a memoryWarning is fired and this view is not being viewed, its content will be removed.
 *  Make sure that we clear everything we create in viewDidLoad as well as IBOutlets.
 */
- (void)setView:(UIView *)view {
    if (view == nil) {
        self.input = nil;
        self.paramsInput = nil;
        self.indicator = nil;
        self.output = nil;
        
        self.appDelegate = nil;
    }
    
    [super setView:view];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (Drupal_ExampleAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)dealloc {
    [super dealloc];
    
    [input release];
    [paramsInput release];
    [indicator release];
    [output release];
}


#pragma mark - Selectors

- (IBAction)sendRequest:(UIButton *)sender {
    [self.input resignFirstResponder];
    [self.paramsInput resignFirstResponder];
    
    [self.indicator startAnimating];

    if ([self.paramsInput.text isEqualToString:@""] || self.paramsInput.text == nil) {
        [self.appDelegate.drupal requestMethod:self.input.text parameters:nil delegate:self];
    } else {
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        NSArray *inputs = [self.paramsInput.text componentsSeparatedByString:@";"];
        
        // Make sure numbers get added properly for our example.
        for (NSString *param in inputs) {
            NSScanner *scanner = [NSScanner scannerWithString:param];
            NSInteger integerValue;
            
            if ([scanner scanInteger:&integerValue] && [scanner isAtEnd]) {
                [parameters addObject:[NSNumber numberWithInteger:integerValue]];
            } else {
                [parameters addObject:param];
            }
        }
    
        [self.appDelegate.drupal requestMethod:self.input.text parameters:parameters delegate:self];
        [parameters release];
    }
}


#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.input) {
        [self.paramsInput becomeFirstResponder];
    } else if (textField == self.paramsInput) {
        [self.paramsInput resignFirstResponder];
        [self sendRequest:nil];
    }
        
    return NO;
}


#pragma mark - DrupalClientDelegate Methods

- (void)didFinishRequest:(DrupalClient *)client method:(NSString *)method response:(XMLRPCResponse *)response {
    [self.output setText:[NSString stringWithFormat:@"%@ = (%@)", method, [response source]]];    
    [self.indicator stopAnimating];
}


- (void)didErrorOnRequest:(DrupalClient *)client method:(NSString *)method error:(NSError *)error {
    [self.output setText:[NSString stringWithFormat:@"Error on method: %@ (%@)", method, error]];
    [self.indicator stopAnimating];
}


@end

