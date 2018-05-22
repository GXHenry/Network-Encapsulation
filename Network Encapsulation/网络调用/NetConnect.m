//
//  NetConnect.m
//  demo
//
//  Created by gaoxin on 15/12/30.
//  Copyright © 2015年 gaoxin. All rights reserved.
//
#define kAppDataKey @""//APP密钥
#import "NetConnect.h"
//#import "BaseFunction.h"
#import "Security.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
//#import "UserData.h"
@implementation NetConnect

static AFHTTPSessionManager *httpSessionManager;
#pragma mark -time
+(NSString *)nowTimeSince1970//
{
    NSDate *date = [NSDate date];
    return [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
}
+(NSString *)timeFormat:(NSString *)time andDateFormat:(NSString *)format//时间格式转换
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time.integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
#pragma mark -请求流水号
+(NSString *)getReqSeq
{
    NSString *time = [NSString stringWithFormat:@"%@",[self timeFormat:[self nowTimeSince1970] andDateFormat:@"yyyyMMddHHmmss"]];
    NSString *rNumber = [NSString stringWithFormat:@"%d",[self getRandomNumber]];
    NSString *reqSeq = [time stringByAppendingString:rNumber];
    return reqSeq;
}
+(int)getRandomNumber
{
    return (int)(1 + (arc4random() % (100000)));
}
#pragma mark -MD5验证
+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}
+(NSString *)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
//        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(NSString *)UrlValueEncode:(NSString*)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)str,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

#pragma mark ===获取设备型号====
+ (NSString *)deviceModelName

{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    
    
    //iPhone 系列
    
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    
    
    //iPod 系列
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    
    
    //iPad 系列
    
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        
        ||[deviceModel isEqualToString:@"iPad4,5"]
        
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        
        ||[deviceModel isEqualToString:@"iPad4,8"]
        
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    
    
    return deviceModel;
    
}




#pragma mark =====网络调用方法======
+(void)getPayJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessResponseBlock)success
                  failure:(FailResponseBlock)failure
{
    if ([NSJSONSerialization isValidJSONObject:parameters])
    {
        
        NSString *sendClient = @"***";
        NSString *channel = @"***";
        NSString *version = @"***";
        NSString *deviceId = [[UIDevice currentDevice].identifierForVendor UUIDString];
        NSString *seq = [self getReqSeq];
        NSString *userName = @"***";//手机号
        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
        NSString *device = [NSString stringWithFormat:@"%@  %@",phoneVersion,[self deviceModelName]];
        httpSessionManager = [AFHTTPSessionManager manager];
        httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [httpSessionManager.requestSerializer setValue:@"******" forHTTPHeaderField:@"accessToken"];
        [httpSessionManager.requestSerializer setValue:sendClient forHTTPHeaderField:@"sendClient"];
        [httpSessionManager.requestSerializer setValue:channel forHTTPHeaderField:@"sendChl"];
        [httpSessionManager.requestSerializer setValue:version forHTTPHeaderField:@"verChl"];//app版本号
        [httpSessionManager.requestSerializer setValue:deviceId forHTTPHeaderField:@"sendDev"];//设备号
        [httpSessionManager.requestSerializer setValue:seq forHTTPHeaderField:@"serialSeq"];//请求流水
        [httpSessionManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"terminal"];
        [httpSessionManager.requestSerializer setValue:version forHTTPHeaderField:@"version"];
        [httpSessionManager.requestSerializer setValue:userName forHTTPHeaderField:@"userName"];//手机号
        [httpSessionManager.requestSerializer setValue:device forHTTPHeaderField:@"device"];
        [httpSessionManager.requestSerializer setValue:@"market-appstore" forHTTPHeaderField:@"chlName"];
        //[httpSessionManager setSecurityPolicy:[self customSecurityPolicy]];//HTTPS测试环境使用
        NSDictionary *keyParams = parameters;
        [httpSessionManager POST:urlString parameters:keyParams progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        
        }];
    }
}



#pragma mark -证书验证
+(AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"***" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    NSSet *set = [[NSSet alloc] initWithObjects:certData,nil];

    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

+ (NSDictionary *)paramsDecrypt:(NSString *)str
{
    if (str!=nil) {
        NSString *enStr = [Security AESDecrypt:str key:kAppDataKey];
        if([enStr isEqual:[NSNull null]])
        {
            //[self showAlertNoTitle:@"数据加载失败，请检查网络后再重新打开试试" andTag:0];
            return nil;
        }
        NSData *jsonData = [enStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        if (jsonData == nil) {
            //NSLog(@"key = %@,str = %@",key,str);
            return nil;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            //            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    }
    return nil;
}
+ (NSDictionary *)paramsEncrypt:(NSDictionary *)dic
{
    if (dic!=nil) {
        NSString *jsonStr = [NSString stringWithFormat:@"%@",[self dataTOjsonString:dic]];
        NSString *enStr = [Security AESEncrypt:jsonStr key:kAppDataKey];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"body"] = enStr;
        return params;
    }
    return nil;
}
+ (NSDictionary *)NewBusinessparamsEncrypt:(NSDictionary *)dic
{
    if (dic!=nil) {
        NSString *jsonStr = [NSString stringWithFormat:@"%@",[self dataTOjsonString:dic]];
//        NSString *enStr = [Security AESEncrypt:jsonStr key:kAppDataKey];
        NSString *enStr = [Security aesEncrypt:jsonStr key:@"***" vector:@"1234567812345678"];
        
        //verctor为
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"request"] = enStr;
        return params;
    }
    return nil;
}
+(void)cancelAllOperations;//取消所有连接
{
    [httpSessionManager.operationQueue cancelAllOperations];
}
@end
