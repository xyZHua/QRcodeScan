//
//  WCQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRcodeScan.h"

@class QRcodeScan;

@interface WCQRCodeVC : UIViewController

@property (copy,nonatomic)void(^WCqrcodeVcBlock)(NSString *url);

@end
