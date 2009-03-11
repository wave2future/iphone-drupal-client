//
//  Drupal_ExampleAppDelegate.h
//  Drupal Example
//
//  Created by Steve on 10/03/09.
//  Copyright Eighty Elements 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrupalClient.h"


@class Drupal_ExampleViewController, DrupalClient;


@interface Drupal_ExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Drupal_ExampleViewController *viewController;
    
    DrupalClient *drupal;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Drupal_ExampleViewController *viewController;

@property (nonatomic, retain) DrupalClient *drupal;


@end

