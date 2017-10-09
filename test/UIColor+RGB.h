//
//  UIColor+RGB.h
//  test
//
//  Created by nykj-mac-03 on 2017/9/12.
//  Copyright © 2017年 12412. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)


// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;



@end
