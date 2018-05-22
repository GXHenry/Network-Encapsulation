//
//  RSAEncrypt.h
//  RSATest
//
//  Created by YK on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncrypt : NSObject 

- (SecKeyRef)getPublicKey;
- (NSData *)encrypt:(NSString *)plainText usingKey:(SecKeyRef)key error:(NSError **)err;

@end
