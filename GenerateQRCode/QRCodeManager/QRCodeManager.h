//
//  QRCodeManager.h
//  GenerateQRCode
//
//  Created by lsh726 on 2020/2/22.
//  Copyright © 2020 liusonghong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface QRCodeManager : NSObject
/**
 * qrString  二维码里面的信息
 * size 二维码大小
 * waterImageName 水印的图片名称
 */
+ (UIImage *)createQRCodeWithString:(NSString *)qrString
                        qrImagesize:(CGSize)size
                         waterImage:(NSString *)waterImageName;

/**
 * qrImage 二维码图片
 * 此接口主要是 把qrImage 和其他UI 布局融合起来，具体怎么布局看自己的需求a来定
 */
+ (UIImage *)combineImage:(UIImage *)qrImage content:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
