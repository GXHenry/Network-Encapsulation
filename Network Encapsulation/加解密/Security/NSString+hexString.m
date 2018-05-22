//
//  NSString+hexString.m
//  CMBCPersonBank
//
//  Created by 莫光清 on 14-3-6.
//  Copyright (c) 2014年 cmbc. All rights reserved.
//

#import "NSString+hexString.h"

@implementation NSString (hexString)
- (NSData *)dataFromHexString
{
    const char *chars = [self UTF8String];
    int i = 0, len = (int)self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}
@end
