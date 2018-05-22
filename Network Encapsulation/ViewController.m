//
//  ViewController.m
//  NetworkEncapsulation
//
//  Created by 上海睿民互联网科技有限公司 on 2018/5/17.
//  Copyright © 2018年 高鑫. All rights reserved.
//

#import "ViewController.h"
#import "NetConnect.h"
@interface ViewController ()
@property (strong,nonatomic) UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    // Do any additional setup after loading the view, typically from a nib.
}
-(UIButton *)button
{
    if(!_button)
    {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 100)];
        [_button setTitle:@"请求" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(CLickButton:) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont systemFontOfSize:16];
        [_button.layer setMasksToBounds:YES];
        [_button.layer setCornerRadius:10.0];
        [_button.layer setBorderWidth:1.0];
        _button.layer.borderColor= [UIColor blackColor].CGColor;
    }
    return _button;
}
-(void)CLickButton:(UIButton *)button
{
    //此处显示等待loading
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userName"] = @"******";
    params[@"userNameType"] = @"******";
    
    [self getJSONDataWithUrl:@"https:******/******" parameters:params success:^(id responseObject) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        NSString *retCode = [dic objectForKey:@"code"];
        if ([retCode isEqualToString:@"00"])
        {
            //处理业务逻辑
            
        }
        else
        {
            //提示后台返回错误信息
        }
        
    } failure:^(NSError *error) {
        //[self ShowWarningHud:@"似乎已断开与互联网的连接"];
    }];
}
- (void)getJSONDataWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters success:(SuccessResponseBlock)success
                   failure:(FailResponseBlock)failure
{
    if ([NSJSONSerialization isValidJSONObject:parameters])
    {
        
        [NetConnect getPayJSONDataWithUrl:urlString parameters:parameters success:^(id responseObject) {
            //            [self hudDissmiss];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
            if([dic count] == 0)
            {
                NSLog(@"数据返回有误,请再试一次");
                return ;
            }
            NSString *retCode = [dic objectForKey:@"code"];
            if ([retCode isEqualToString:@"1009"])
            {
                
                //根据后台返回的Code来判断是否踢下线，踢下线的操作
            }
            else
            {
                success(responseObject);
            }
            
        } failure:^(NSError *error) {
            failure(error);
            //网络错误时 取消极光推送别名
            NSInteger errCode = error.code;
            NSString *err = [NSString stringWithFormat:@"网络调用失败[%ld]",(long)errCode];
            //网络错误时 取消极光推送别名
            //            [JPUSHService setAlias:@""
            //                  callbackSelector:nil
            //                            object:self];
            //            [self hudDissmiss];////此处取消等待loading
            //            [self showMessageHud:err];//此处显示错误信息
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
