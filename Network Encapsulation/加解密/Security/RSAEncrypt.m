//
//  RSAEncrypt.m
//  RSATest
//
//  Created by YK on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RSAEncrypt.h"
#import "GTMBase64.h"

#define FireflyRSAKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDH1+ArWIj3UNviZJmqi6IQpC8yx6X1UyBrJIU63WaQCbOqCBfelVnn4oXKFiQx2xo/2wigYzyuKZBMAa4pIM9R502WdM98PAG/lkQ6jKwSHAVLAMWeleEPrzh6DWQV5M1/VcDUiS4Y8V590mQzy8OcjOiUZ4QC/SHKERCdRth4twIDAQAB"


#define FireflyRSAStoreKey @"FireflyRsaStoreKey"

@interface RSAEncrypt ()

- (void)addPublickeyToKeyChain:(NSString *)storeKey Data:(NSData *)data;
- (void)removePublicKey:(NSString *)storeKey;
- (SecKeyRef)getPublicKeyReference:(NSString *)storeName;
- (NSData *)stripPublicKeyHeader:(NSData *)d_key;

@end

@implementation RSAEncrypt

-(NSData *)encrypt:(NSString *)plainText usingKey:(SecKeyRef)key error:(NSError **)err{
	size_t cipherBufferSize = SecKeyGetBlockSize(key);
	uint8_t *cipherBuffer = NULL;
	cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
	memset((void *)cipherBuffer, 0*0, cipherBufferSize);
	NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	int blockSize = (int)(cipherBufferSize-28);
	int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
	NSMutableData *encryptedData = [[NSMutableData alloc] init];
	for (int i=0; i<numBlock; i++) {
		int bufferSize = (int)(MIN(blockSize,[plainTextBytes length]-i * blockSize));
		NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
		OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1,
										(const uint8_t *)[buffer bytes],
										[buffer length], cipherBuffer,
										&cipherBufferSize);
		if (status == noErr)
		{
			NSData *encryptedBytes = [[NSData alloc]
									   initWithBytes:(const void *)cipherBuffer
									   length:cipherBufferSize];
			[encryptedData appendData:encryptedBytes];
			[encryptedBytes release];
		}
		else
		{
			*err = [NSError errorWithDomain:@"errorDomain" code:status userInfo:nil];
            [encryptedData release];
            (void)(free(cipherBuffer)),cipherBuffer = NULL;
			return nil;
		}
	}
	if (cipherBuffer)
	{
        (void)(free(cipherBuffer)),cipherBuffer = NULL;
	}
	return [encryptedData autorelease];
}

- (SecKeyRef)getPublicKey
{
//    SecKeyRef pubKeyRefData = [self getPublicKeyReference:FireflyRSAStoreKey];
//    if (pubKeyRefData == nil)
//    {
        NSData *myCertData = [GTMBase64 decodeString:FireflyRSAKEY];
        NSData *trimData = [self stripPublicKeyHeader:myCertData];
        [self addPublickeyToKeyChain:FireflyRSAStoreKey Data:trimData];
        return [self getPublicKeyReference:FireflyRSAStoreKey];
//    }
//    else
//    {
//        return pubKeyRefData;
//    }
}

- (void)addPublickeyToKeyChain:(NSString *)storeKey Data:(NSData *)data
{
    OSStatus sanityCheck = noErr;
    CFTypeRef persistPeer = NULL;

    [self removePublicKey:storeKey];
    
    NSData * peerTag = [[NSData alloc] initWithBytes:(const void *)[storeKey UTF8String] length:[storeKey length]];
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
    [peerPublicKeyAttr setObject:(id)kSecClassKey forKey:(id)kSecClass];
    [peerPublicKeyAttr setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [peerPublicKeyAttr setObject:peerTag forKey:(id)kSecAttrApplicationTag];
    [peerPublicKeyAttr setObject:data forKey:(id)kSecValueData];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
    sanityCheck = SecItemAdd((CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);
    
    if (persistPeer != NULL)
    {
        CFRelease(persistPeer);
        persistPeer = NULL;
    }
    
    [peerPublicKeyAttr removeObjectForKey:(id)kSecValueData];
    sanityCheck = SecItemCopyMatching((CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef*)&persistPeer);
    
    
    [peerTag release];
    [peerPublicKeyAttr release];
    if (persistPeer != NULL)
    {
        CFRelease(persistPeer);
        persistPeer = NULL;
    }
}

- (void)removePublicKey:(NSString *)storeKey
{
    NSData *tag = [NSData dataWithBytes:[storeKey UTF8String] length:[storeKey length]];
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(id) kSecClassKey forKey:(id)kSecClass];
    [publicKey setObject:(id) kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [publicKey setObject:tag forKey:(id)kSecAttrApplicationTag];
    SecItemDelete((CFDictionaryRef)publicKey);
    [publicKey release];
}

- (SecKeyRef)getPublicKeyReference:(NSString *)storeName
{
    OSStatus sanityCheck = noErr;
    
    SecKeyRef pubKeyRefData = NULL;
    NSData * peerTag = [[NSData alloc] initWithBytes:(const void *)[storeName UTF8String] length:[storeName length]];
    NSMutableDictionary * peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
    
    [peerPublicKeyAttr setObject:(id)kSecClassKey forKey:(id)kSecClass];
    [peerPublicKeyAttr setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [peerPublicKeyAttr setObject:peerTag forKey:(id)kSecAttrApplicationTag];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnRef];
    
    
    [peerPublicKeyAttr removeObjectForKey:(id)kSecValueData];
    [peerPublicKeyAttr removeObjectForKey:(id)kSecReturnPersistentRef];
    
    
    sanityCheck = SecItemCopyMatching((CFDictionaryRef)peerPublicKeyAttr,
                                      (CFTypeRef *)&pubKeyRefData);

    return pubKeyRefData;
}

- (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned int len = (unsigned int)[d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}
@end
