//
//  ViewController.m
//  微博分享登录
//
//  Created by 洪铭翔 on 16/5/25.
//  Copyright © 2016年 洪铭翔. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface ViewController ()
- (IBAction)weiboShareAcion:(id)sender;
- (IBAction)authorizationAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weiboShareAcion:(id)sender {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建iPad弹出菜单容器,详见第六步
    id<ISSContainer> container = [ShareSDK container];
    
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:@{@(ShareTypeSinaWeibo): @[@"follow_app_official_microblog"]}
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
//    [ShareSDK clientShareContent:publishContent type:ShareTypeSinaWeibo authOptions:authOptions shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        
//        if (state == SSPublishContentStateSuccess)
//        {
//            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
//        }
//        else if (state == SSPublishContentStateFail)
//        {
//            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
//        }
//    }];
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo, nil];
    [ShareSDK oneKeyShareContent:publishContent//内容对象
                       shareList:shareList//平台类型列表
                     authOptions:authOptions//授权选项
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                              }
                          }];
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(@"分享成功");
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
//                                }
//                            }];
}

- (IBAction)authorizationAction:(id)sender {
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:@{@(ShareTypeSinaWeibo): @[@"follow_app_official_microblog"]}
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo //平台类型
                      authOptions:authOptions //授权选项
                           result:^(BOOL result, id userInfo, id error) { //返回回调
                               if (result)
                               {
                                   NSLog(@"uid =  %@",[userInfo uid]);
                                   
                                   NSLog(@"name = %@",[userInfo nickname]);
                                   
                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                   
                                   //通过地址得到URL
                                   NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/public_timeline.json?access_token=2.00rP91yD7VYqcE28f740dd5bIX3DoB"];
                                   
                                   //通过单例session得到一个sessionTask
                                   NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                       NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       NSLog(@"result = %@", result);
                                   }];
                                   
                                   [task resume];
                                   
                               }
                               
                               else
                               {
                                   NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                   
                               }
                               
                           }];
}
@end
