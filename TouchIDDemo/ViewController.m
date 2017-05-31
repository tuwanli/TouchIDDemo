//
//  ViewController.m
//  TouchIDDemo
//
//  Created by 涂欢 on 2017/5/31.
//  Copyright © 2017年 DevinTu. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()
//取消Touch Id验证的按钮的标题，默认标题是输入密码
@property (nonatomic, copy)NSString *localizedFallbackTitle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickMeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)clickMeAction:(UIButton *)btn
{
    LAContext *lacontenxt = [[LAContext alloc]init];
    lacontenxt.localizedFallbackTitle = @"输入密码";
    NSError *error;//LAPolicyDeviceOwnerAuthentication....LAPolicyDeviceOwnerAuthenticationWithBiometrics
    if ([lacontenxt canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [lacontenxt evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"TouchId Test" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                NSLog(@"success to evaluate");
            }
            if (error) {
                NSLog(@"error===%@",error);
                NSLog(@"code====%d",error.code);
                NSLog(@"errorStr ======%@",[error.userInfo objectForKey:NSLocalizedDescriptionKey]);
                if (error.code == -2) {//点击了取消按钮
                    NSLog(@"点击了取消按钮");
                }else if (error.code == -3){//点输入密码按钮
                    NSLog(@"点输入密码按钮");
                }else if (error.code == -1){//连续三次指纹识别错误
                    NSLog(@"连续三次指纹识别错误");
                }else if (error.code == -4){//按下电源键
                    NSLog(@"按下电源键");
                }else if (error.code == -8){//Touch ID功能被锁定，下一次需要输入系统密码
                    NSLog(@"Touch ID功能被锁定，下一次需要输入系统密码");
                }
                NSLog(@"未通过Touch Id指纹验证");
            }
        }];
    }else{
        // 4.根据授权失败信息执行相关操作
        switch (error.code) {
            case LAErrorPasscodeNotSet:
                NSLog(@"未设置密码 - %@", error.localizedDescription);
                break;
            case LAErrorTouchIDNotEnrolled:
                NSLog(@"未注册 Touch ID - %@", error.localizedDescription);
                break;
            case kLAErrorTouchIDNotAvailable:
                NSLog(@"该设备不支持 Touch ID - %@", error.localizedDescription);
                break;
            default:
                NSLog(@"--%@--%zd", error.localizedDescription, error.code);
                break;
        }
    }
    
    /*
     
     [SVProgressHUD show];
     
     LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
     
     context.localizedFallbackTitle = @"";//这样可以不让 feedBack 按钮显示
     //LAPolicyDeviceOwnerAuthenticationWithBiometrics
     [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
     
     [SVProgressHUD dismiss];
     //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
     if (success)
     {
     NSLog(@"指纹识别成功");
     // 指纹识别成功，回主线程更新UI
     dispatch_async(dispatch_get_main_queue(), ^{
     //成功操作
     });
     }
     
     if (error) {
     //指纹识别失败，回主线程更新UI
     NSLog(@"指纹识别成功");
     dispatch_async(dispatch_get_main_queue(), ^{
     //失败操作
     });
     }
     });
     }];
     
     */
}
- (BOOL)canEvaluatePolicy:(LAPolicy)policy error:(NSError * __autoreleasing *)error __attribute__((swift_error(none)))
{
    return YES;
}
- (void)evaluatePolicy:(LAPolicy)policy
       localizedReason:(NSString *)localizedReason
                 reply:(void(^)(BOOL success, NSError * __nullable error))reply
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
