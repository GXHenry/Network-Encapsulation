//
//  SHA_1.m
//  DeviceTest
//
//  Created by YK on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SHA_1.h"


@implementation SHA_1
+(NSString *)digest:(NSString *)input{
//	const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
//	NSData *data = [NSData dataWithBytes:cstr length:input.length];

	NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x",digest[i]];
	}
	return output;
}
@end
