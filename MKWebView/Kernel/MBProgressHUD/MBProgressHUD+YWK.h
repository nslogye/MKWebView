//
//  MBProgressHUD+YWK.h
//  News
//
//  Created by Ye.Sir on 2017/6/6.
//  Copyright © 2017年 lsk. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YWK)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end
