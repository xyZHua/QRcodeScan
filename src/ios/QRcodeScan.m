//
//  QRcodeScan.m
//  agentApp
//
//  Created by ZlHy on 2019/11/1.
//

#import "QRcodeScan.h"

@implementation QRcodeScan
-(void)ScanMethod:(CDVInvokedUrlCommand*)command{
    self.latestCommand = command;    
    self.WCVC = [[WCQRCodeVC alloc] init];
    [self QRCodeScanVC:self.WCVC];
    
    __weak QRcodeScan* weakSelf  = self;
    self.WCVC.WCqrcodeVcBlock = ^(NSString *url) {
        
            [weakSelf.commandDelegate runInBackground:^{
            
            CDVPluginResult * pluginRes = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:url];
            [weakSelf.commandDelegate sendPluginResult:pluginRes callbackId:command.callbackId];
            
        }];
        
        //        [weakSelf capturedQRcodeScanWithString:url];
        [weakSelf.WCVC dismissViewControllerAnimated:YES completion:nil];
        if ([url isEqualToString:@""]) {
            return ;
        }
        //                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:url preferredStyle:UIAlertControllerStyleAlert];
        //
        //                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //                 NSLog(@"action = %@", action);
        //                }];
        //                 UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //                                NSLog(@"action = %@", action);
        //                }];
        //
        //                 [alert addAction:defaultAction];
        //                 [alert addAction:cancelAction];
        //                 [self.viewController presentViewController:alert animated:YES completion:nil];
        
    };
}


- (void)QRCodeScanVC:(UIViewController *)scanVC {
    
    __weak QRcodeScan* weakSelf = self;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            //                            [self.navigationController pushViewController:scanVC animated:YES];
                            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:scanVC];
                            
                            [weakSelf.viewController presentViewController:nav animated:YES completion:nil];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                //                [self.navigationController pushViewController:scanVC animated:YES];
                //                [self.viewController presentViewController:scanVC animated:YES completion:nil];
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:scanVC];
                [self.viewController presentViewController:nav animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                
                [weakSelf.viewController presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [weakSelf.viewController presentViewController:alertC animated:YES completion:nil];
}


-(void)capturedQRcodeScanWithString:(NSString*)str {
    //    NSLog(@"str------------:%@", str);
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:str] callbackId:self.latestCommand.callbackId];
    
}



@end
