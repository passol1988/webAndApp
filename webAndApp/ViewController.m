//
//  ViewController.m
//  webAndApp
//
//  Created by 赵宇 on 16/1/18.
//  Copyright © 2016年 赵宇. All rights reserved.
//

#import "ViewController.h"
#import "AnoViewController.h"

@interface ViewController ()<UIWebViewDelegate>
{
    UIWebView *web;
}
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeContactAdd];
    but.frame = CGRectMake(22,20, 30, 30);
    [self.view addSubview:but];
    [but addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, 414, 672)];
    web.delegate = self;
    web.scalesPageToFit = YES;

    
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    
//    [web loadRequest:request];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    web.delegate = self;

    
    [self.view addSubview:web];
    
}




-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSLog(@"%@",request.URL.absoluteString);
    
    NSString *str = [NSString stringWithFormat:@"%@",request.URL.absoluteString];
    str = [str substringFromIndex:7];
    NSLog(@"---  %@",str);
    if ([str hasPrefix:@"map"]) {
        AnoViewController *ano = [[AnoViewController alloc]init];
        [self presentViewController:ano animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

-(void)back
{
    [web goBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"OCWebview"] = self;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

//判断是否登录 写逻辑
- (BOOL)checkLogin
{
    return YES;

}


- (void)shareEnable:(NSString *)enable
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([enable boolValue]) {
            [[[UIAlertView alloc] initWithTitle:@"可以分享"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"取消"
                              otherButtonTitles: nil] show];
        }else{
            [[[UIAlertView alloc] initWithTitle:@"不能分享分享"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"取消"
                              otherButtonTitles: nil] show];
        }

    });
}

- (void)JSToOC:(NSDictionary *)params {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Js调用了OC的方法，参数为：%@", params);
    });
}

- (void)OCToJS:(NSDictionary *)params
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        JSValue *jsParamFunc = self.jsContext[@"JSReceive"];
        [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];

    });
}

- (void)showAlert:(NSDictionary *)params
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:[NSString stringWithFormat:@"JS收到 %@", params]
                                   delegate:nil
                          cancelButtonTitle:@"取消"
                          otherButtonTitles: nil] show];
    });
}


@end
