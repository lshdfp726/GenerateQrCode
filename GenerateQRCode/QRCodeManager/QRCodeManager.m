//
//  QRCodeManager.m
//  GenerateQRCode
//
//  Created by lsh726 on 2020/2/22.
//  Copyright © 2020 liusonghong. All rights reserved.
//

#import "QRCodeManager.h"
#import <CoreImage/CoreImage.h>
#import <Foundation/NSObjCRuntime.h>

@implementation QRCodeManager
+ (UIImage *)createQRCodeWithString:(NSString *)qrString
                        qrImagesize:(CGSize)size
                         waterImage:(NSString *)waterImageName {
    UIImage *desImage = nil;
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    [filter setValue:[qrString dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];

    desImage = [self disposeQrImage:filter.outputImage waterImage:waterImageName size:size];

    return desImage;
}


/**
* qrImage 二维码图片
* 此接口主要是 把qrImage 和其他UI 布局融合起来，具体怎么布局看自己的需求a来定
*/
+ (UIImage *)combineImage:(UIImage *)qrImage content:(NSDictionary *)dic {
    CGSize size = CGSizeMake(qrImage.size.width + 50, qrImage.size.height + 150);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *topImage = [UIImage imageNamed:@"waterImage"];
    CGFloat imageSizeH = 25;
    CGFloat imageSizeW = 25;
    [topImage drawInRect:CGRectMake(25, 15, imageSizeW, imageSizeH)];

    [qrImage drawInRect:CGRectMake(30, 50, qrImage.size.width, qrImage.size.height)];

    NSArray *arr = @[@"型号：xxxx",@"序列号：123456789",@"验证码：ABCDEF"];
    CGFloat origin = 270;
    for (NSString *str in arr) {
        NSDictionary *attr = @{NSFontAttributeName :[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor]};
        CGFloat width = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size.width;
        [str drawInRect:CGRectMake(30, origin , width, 20) withAttributes:attr];
        origin += 30;
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

+ (UIImage *)disposeQrImage:(CIImage *)qrImage waterImage:(NSString *)waterImageName size:(CGSize)size {
    UIImage *desImage = nil;
    CGRect extend = CGRectIntegral(qrImage.extent);

    CGFloat scaleW = size.width / extend.size.width;
    CGFloat scaleH = size.height / extend.size.height;

    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleW, scaleH)
                          highQualityDownsample:YES];

    extend = CGRectIntegral(qrImage.extent);

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extend);

    size_t height = CGRectGetHeight(extend);

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();

    //上下文环境
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);

    CIContext *context = [CIContext contextWithOptions:nil];

    CGImageRef bitmapImage = [context createCGImage:qrImage fromRect:extend];

    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);

    CGContextScaleCTM(bitmapRef, 1, 1);


    CGContextDrawImage(bitmapRef, extend, bitmapImage);

    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);

    CGContextRelease(bitmapRef);

    CGImageRelease(bitmapImage);

    //原图

    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];


    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);

    [outputImage drawInRect:CGRectMake(0,0 , size.width, size.height)];

    //水印图
    UIImage *waterImage = [UIImage imageNamed:waterImageName];
    CGFloat waterImagesize = 50;
    [waterImage drawInRect:CGRectMake((size.width-waterImagesize)/2.0, (size.height-waterImagesize)/2.0, waterImagesize, waterImagesize)];

    desImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return desImage;
}
@end
