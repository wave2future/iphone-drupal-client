//
//  DrupalClient.h
//  Drupal Example
//
//  Created by Steve on 10/03/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>


@protocol DrupalClientDelegate;


@class XMLRPCRequest, XMLRPCResponse;


@interface DrupalClient : NSObject {
    NSString *_domain;
    NSString *_key;
    id _delegate;
}


// Init method.
- (id)initWithKey:(NSString *)key domain:(NSString *)domain delegate:(id)delegate;


// Handle making requests to the drupal site.
- (void)requestMethod:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey;
- (void)requestMethod:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey delegate:(id)delegate;

- (XMLRPCResponse *)requestSynchronousResponse:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey;


// Simple method to change the delegate as needed.
- (void)setDelegate:(id)delegate;


@end


@protocol DrupalClientDelegate<NSObject>


// Available delegate methods.
- (void)didFinishRequest:(DrupalClient *)client method:(NSString *)method response:(XMLRPCResponse *)response;
- (void)didErrorOnRequest:(DrupalClient *)client method:(NSString *)method error:(NSError *)error;


@end

