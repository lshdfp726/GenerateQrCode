//
//  ViewController.m
//  GenerateQRCode
//
//  Created by lsh726 on 2020/2/22.
//  Copyright © 2020 liusonghong. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImage *image = [QRCodeManager createQRCodeWithString:@"123"
                                                          qrImagesize:CGSizeMake(200, 200)
                                                           waterImage:@"waterImage"];;

    UIImage *im = [QRCodeManager combineImage:image content:@{}];

    UIImageView *imageV = [[UIImageView alloc] initWithImage:im];
    imageV.frame = CGRectMake(100, 200, im.size.width, im.size.height);
    [self.view addSubview:imageV];
}


@end
