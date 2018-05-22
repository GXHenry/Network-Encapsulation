//
//  NetConnect.h
//  demo
//
//  Created by gaoxin on 15/12/30.
//  Copyright © 2015年 gaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^SuccessResponseBlock)(id responseObject);
typedef void (^FailResponseBlock)(NSError* error);

@interface NetConnect : NSObject<UIAlertViewDelegate>
+(NSString *)getReqSeq;//获取请求流水号
+(int)getRandomNumber;//1-10000随机数
+(NSString *)dataTOjsonString:(id)object;//转json
+(NSString *)UrlValueEncode:(NSString*)str;//转码
+(NSString *)md5:(NSString *)str; //MD5验证
+ (NSString *)deviceModelName; //获取设备号
+(NSString *)nowTimeSince1970;
+(NSString *)timeFormat:(NSString *)time andDateFormat:(NSString *)format;//时间格式转换
//给pay接口调用方法
+(void)getPayJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessResponseBlock)success
                        failure:(FailResponseBlock)failure;




+(AFSecurityPolicy*)customSecurityPolicy;//验证证书使用
+(void)cancelAllOperations;//取消所有连接
@end
