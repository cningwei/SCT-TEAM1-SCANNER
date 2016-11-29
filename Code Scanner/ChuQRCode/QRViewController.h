//
//  QRViewController.h
//  ChuQRCode
//
//  Created by Xes.Sky.Macbook on 2016/11/4.
//  Copyright © 2016年 Xes.Sky.Macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^resultCallBack)(NSString *);

@interface QRViewController : UIViewController

- (instancetype)initWithCallback:(resultCallBack)callback;

@end
