//
//  SHA_1.h
//  DeviceTest
//
//  Created by YK on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"
@interface SHA_1 : NSObject {

}
+(NSString *)digest:(NSString *)input;
@end
