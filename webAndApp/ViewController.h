//
//  ViewController.h
//  webAndApp
//
//  Created by 赵宇 on 16/1/18.
//  Copyright © 2016年 赵宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol WebviewProtocol <JSExport>

- (BOOL)checkLogin;
- (void)shareEnable:(NSString *)enable;

- (void)JSToOC:(NSDictionary *)params;
- (void)OCToJS:(NSDictionary *)params;
- (void)showAlert:(NSDictionary *)params;

@end
@interface ViewController : UIViewController<WebviewProtocol>


@end

