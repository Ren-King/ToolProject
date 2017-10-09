//
//  ViewController.m
//  test
//
//  Created by nykj-mac-03 on 2017/8/30.
//  Copyright © 2017年 12412. All rights reserved.
//

#import "ViewController.h"
#import "RZToolManager.h"
#import "WUIImage.h"
#import <Accelerate/Accelerate.h>
#import "UIColor+RGB.h"
#define HexColor(color) [UIColor colorWithHexString:color]
#import "NetWorkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NetWorkManager sharedInstance]getWithURLString:@"http://app.info.dig88api.com/index.php?page=maintenance&web_id=8" success:^(id responseObject) {
        NSLog(@"地方舒服舒服 = %@",responseObject);
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (UIImage *)createViewImage:(UIView *)shareView {
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, NO, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"打电话 ");
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}





- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur{
    
    if (blur < 0.f || blur > 1.f)
    {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer,
    outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL) NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer; outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) { NSLog(@"error from convolution %ld", error);
    
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
    
   
    
}
    
//- (UIImage *)GPUImageStyleWithImage:(UIImage *)image{
//    
//    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
//    filter.blurRadiusInPixels = 10.0;//值越大，模糊度越大
//    UIImage *blurImage = [filter imageByFilteringImage:image];
//    return blurImage;
//}
//    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
