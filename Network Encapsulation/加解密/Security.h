//
//  Security.h
//  FireflyFramework
//
//  Created by wenyanjie on 14-11-28.
//  Copyright (c) 2014年 gaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AES_VECTOR @"1234567812345678"

@interface Security : NSObject

+ (Security *)sharedInstance;

/**
 *  判断手机是否越狱
 *
 *  @return 返回YES说明越狱
 */
+(BOOL)isJailBreak;


/**
 *  生成AES密钥
 *
 *  @return AES密钥
 */
+ (NSString*)generateAESKey;

/**
 *  AES加密
 *
 *  @param code   格式为NSString
 *  @param aesKey AES秘钥
 *
 *  @return AES加密结果
 */
+(NSString*)AESEncrypt:(NSString*)code key:(NSString *)aesKey;

/**
 *  AES解密
 *
 *  @param code   格式为NSString
 *  @param aesKey AES秘钥
 *
 *  @return AES解密结果
 */
+(NSString*)AESDecrypt:(NSString*)code key:(NSString *)aesKey;

/**
 *  RSA加密
 *
 *  @param codeString 格式为NSString
 *
 *  @return RSA加密结果
 */
+ (NSString*)RSAEncrypt:(NSString*)codeString;

/**
 *  base64编码
 *
 *  @param input 输入格式为NSString
 *
 *  @return 编码结果
 */
+(NSString*)encodeBase64String:(NSString *)input;

/**
 *  base64解码
 *
 *  @param input 输入格式为NSString
 *
 *  @return 解码结果
 */
+(NSString*)decodeBase64String:(NSString *)input;

/**
 *  base64编码
 *
 *  input 输入格式为NSData
 *
 *  @return 编码结果
 */
+(NSString*)encodeBase64Data:(NSData *)data;

/**
 *  base64解码
 *
 *  input 输入格式为NSData
 *
 *  @return 解码结果
 */
+(NSString*)decodeBase64Data:(NSData *)data;

/**
 *  AES 加密,包含向量因子
 *
 *  @param codeString 加密字符串
 *  @param aesKey     aes密钥
 *  @param aesVector  aes向量因子
 *
 *  @return aes加密结果
 */
+ (NSString *)aesEncrypt:(NSString*)codeString key:(NSString *)aesKey vector:(NSString *)aesVector;

/**
 *  AES 解密,包含向量因子
 *
 *  @param codeString 解密字符串
 *  @param aesKey     aes密钥
 *  @param aesVector  aes向量因子
 *
 *  @return aes加密结果
 */
+ (NSString *)aesDecrypt:(NSString*)codeString key:(NSString *)aesKey vector:(NSString *)aesVector;

@end
