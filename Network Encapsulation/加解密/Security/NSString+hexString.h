//
//  NSString+hexString.h
//  CMBCPersonBank
//
//  Created by 莫光清 on 14-3-6.
//  Copyright (c) 2014年 cmbc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (hexString)
//字符串转换为字节数组
- (NSData *)dataFromHexString;
@end
