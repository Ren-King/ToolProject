//
//  RZToolManager.h
//  test
//
//  Created by nykj-mac-03 on 2017/8/30.
//  Copyright © 2017年 12412. All rights reserved.
//
//字符串是否为空

#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

//数组是否为空

#define ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空

#define DictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象

#define RObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#define RUserDefaults       [NSUserDefaults standardUserDefaults]

#define RNotificationCenter [NSNotificationCenter defaultCenter]

//颜色
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]


#define ColorWithHex(rgbValue) \ [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \ green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \ blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]



//弱引用/强引用

#define WeakSelf(type)   __weak typeof(type) weak##type = type;

#define StrongSelf(type) __strong typeof(type) type = weak##type;


// 获取 屏幕 宽 高
#define Win_height [UIScreen mainScreen].bounds.size.height

#define Win_width  [UIScreen mainScreen].bounds.size.width

//屏幕比例
#define Mutiple_x  [UIScreen mainScreen].bounds.size.width / 375

#define Mutiple_y  [UIScreen mainScreen].bounds.size.height / 667

/// 获取图片
#define RImageWithName(text) [UIImage imageNamed:text]

/// 当前app delegate
#define GetAPPDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

/// 数值转字符串
#define IntToString(intValue) ([NSString stringWithFormat:@"%@", @(intValue)])
#define StrToInt(str) [str integerValue]
#define StrToDouble(str) [str doubleValue]
#define DoubleStringFormat(str) [NSString stringWithFormat:@"%.2f", [str doubleValue]]

#define RzLog(format, ...) NSLog((@"%s [Line %d] " format), __FUNCTION__, __LINE__, ##__VA_ARGS__)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RZToolManager : NSObject

//实现单例
+ (instancetype)sharedManage;

//数组去重

+ (NSArray *)ArrayQuChongWith:(NSArray *)array;

//压缩图片
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  判断手机号码是否正确
 */
+ (BOOL)isValidateMobileNumber:(NSString *)mobileNum;
/**
 *  判断邮箱是否正确
 */
+(BOOL) isValidateEmail:(NSString *)email;

/**
 *  获取当前时间
 */
+ (NSString *)currentTime;


/**
 *  将时间转换成时间戳
 *
 *   时间戳：指格林威治时间1970年01月01日00时00分00秒(北京时间1970年01月01日08时00分00秒)起至现在的总秒数。
 */
+ (NSString *)timeStringIntoTimeStamp:(NSString *)time;

/**
 *  将时间戳转换成时间
 */
+ (NSString *)timeStampIntoTimeString:(NSString *)time;

/**
 *  转换为周X
 *
 *  @param time 时间戳
 *
 *  @return 周几
 */
+ (NSString *) getWeekDay:(NSTimeInterval) time;


/**
 *  通过时间字符串获取年、月、日
 */
+ (NSArray *)getYearAndMonthAndDayFromTimeString:(NSString *)time;

/**
 *  当前界面截图
 */
+ (UIImage *)imageFromCurrentView:(UIView *)view;

/**
 *  去掉html中的标签
 */
+ (NSString *)stringRemovetheHTMLtags:(NSString *)htmlString;

/**
 *  生成随机数 n到m
 */
+(int)getRandomNumber:(int)from to:(int)to;

/**
 *  将image 转化成nsdata
 */
+(NSData *)getImageDataWith:(UIImage *)image;

/**
 *  转化成手机号空格式字符串
 */
+ (NSString *)becomePhoneNumTypeWithNSString:(NSString *)string;

/**
 *  字典转化成字符串
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;


/**
 *  改变多段字符串为一种颜色
 *
 *  @param color  字符串的颜色
 *  @param ranges 范围数组:[NSValue valueWithRange:NSRange]
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
+ (NSMutableAttributedString *)changeColor:(UIColor *)color andRanges:(NSArray<NSValue *> *)ranges string:(NSString *)textString;


+ (UIImage *)getyuanxingImage:(UIImage *)image;






@end
