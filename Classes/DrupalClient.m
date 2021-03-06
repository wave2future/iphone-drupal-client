//
//  DrupalClient.m
//  Drupal Example
//
//  Created by Steve on 10/03/09.
//  Copyright 2009 Eighty Elements. All rights reserved.
//

#import "DrupalClient.h"

#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"


@implementation DrupalClient


- (id)initWithKey:(NSString *)key domain:(NSString *)domain delegate:(id)delegate {
	if (self = [super init]) {
        _key = key;        
        _domain = domain;
        _delegate = delegate;
    }
	
	return self;
}


- (void)dealloc {
    [super dealloc];
    
    [_key autorelease];
    [_domain autorelease];
}


#pragma mark -
#pragma mark Private Methods

/**
 *  Get a signed SHA256 key formatted for the services.module.
 */
- (NSString *)getSignedKey:(NSString *)method nonce:(NSString *)nonce timestamp:(NSInteger)timestamp {
    NSString *inputString = [NSString stringWithFormat:@"%d;%@;%@;%@",timestamp, _domain, nonce, method]; 
	NSString *returnHash;
    
	unsigned char macOut[CC_SHA256_DIGEST_LENGTH] = {0};
	const char *datachar = [inputString UTF8String];
	const char *keychar = [_key UTF8String];
    
	CCHmac(kCCHmacAlgSHA256, keychar, strlen(keychar), datachar, strlen(datachar), macOut);
	
    int i;
	char finaldigest[2*CC_SHA256_DIGEST_LENGTH];
	
    for (i=0;i<CC_SHA256_DIGEST_LENGTH;i++) {
        sprintf(finaldigest+i*2,"%02x",macOut[i]);   
    }
	
	returnHash = [[NSString alloc] initWithBytes:finaldigest length:sizeof(finaldigest) encoding:NSASCIIStringEncoding];
	
	return [returnHash autorelease];
}


/**
 *  Prepare all the parameters needed for a method request.
 */
- (XMLRPCRequest *)preProcessRequest:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey {
    NSMutableArray *params;
    
    if (!withKey) {
        params = [NSArray arrayWithArray:parameters];
    } 
    // Generate the needed parameters for the key signing.
    else {
        NSString *nonce = [NSString stringWithFormat:@"%d",random() % 10000];
        
        NSDate *date = [NSDate date];
        NSInteger timestamp = (NSInteger)[date timeIntervalSince1970];
        
        NSString *signedKey = [self getSignedKey:method nonce:nonce timestamp:timestamp];
        
        NSString *timeToString = [NSString stringWithFormat:@"%d", timestamp]; 
        params = [NSMutableArray arrayWithObjects:signedKey, _domain, timeToString, nonce, nil];
        
        if ([parameters count] > 0) {
            [params addObjectsFromArray:parameters];
        }
    }
    
    // TODO: handle base_path() ?
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/services/xmlrpc", _domain]];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithHost:url];
    [request setMethod:method withObjects:params];
    
    NSLog(@"Sending Request: %@ with %@", method, [request source]);
    
    return request;
    
    [request release];
}


#pragma mark -
#pragma mark Public Methods

- (void)requestMethod:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey {
    XMLRPCRequest *request = [self preProcessRequest:method parameters:parameters withKey:withKey];
    
	[[XMLRPCConnection alloc] initWithXMLRPCRequest:request delegate:self];
}


- (void)requestMethod:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey delegate:(id)delegate {
    [self setDelegate:delegate];
    [self requestMethod:method parameters:parameters withKey:withKey];
}


- (XMLRPCResponse *)requestSynchronousResponse:(NSString *)method parameters:(NSArray *)parameters withKey:(BOOL)withKey {
    XMLRPCRequest *request = [self preProcessRequest:method parameters:parameters withKey:withKey];
	XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
    
    return response;
}


- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}


#pragma mark - 
#pragma mark XMLRPCConnectionDelegate Methods

- (void)connection:(XMLRPCConnection *)connection didReceiveResponse:(XMLRPCResponse *)response forMethod:(NSString *)method {
    [_delegate didFinishRequest:self method:method response:response];
    [connection release];
}


- (void)connection:(XMLRPCConnection *)connection didFailWithError:(NSError *)error forMethod:(NSString *)method {
    [_delegate didErrorOnRequest:self method:method error:error];
    [connection release];
}


@end

