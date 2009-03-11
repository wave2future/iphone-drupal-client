//
//  Drupal_ExampleAppDelegate.m
//  Drupal Example
//
//  Created by Steve on 10/03/09.
//  Copyright Eighty Elements 2009. All rights reserved.
//

#import "Drupal_ExampleAppDelegate.h"
#import "Drupal_ExampleViewController.h"


// TODO: should probably move these to a NSUserDefaults?
#define DRUPAL_API_KEY      @"f6c4fd09600db7c63e872152a9419977"
#define DRUPAL_DOMAIN       @"d6"


@implementation Drupal_ExampleAppDelegate


@synthesize window;
@synthesize viewController;

@synthesize drupal;


- (void)applicationDidFinishLaunching:(UIApplication *)application {       
    self.drupal = [[DrupalClient alloc] initWithKey:DRUPAL_API_KEY domain:DRUPAL_DOMAIN delegate:self];    

    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [super dealloc];
    
    [viewController release];
    [window release];
    
    [drupal release];
}


@end

