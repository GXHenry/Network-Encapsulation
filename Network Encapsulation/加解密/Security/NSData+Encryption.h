//
//  NSData+Encryption.h
//  MSZX
//
//  Created by Keldon on 14-11-11.
//  Copyright (c) 2014年 Keldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

+ (NSData *)TripleAES:(NSData*)plainData encryptOrDecrypt:(int)encryptOrDecrypt key:(NSString*)key  vector:(NSString *)vector;

@end
