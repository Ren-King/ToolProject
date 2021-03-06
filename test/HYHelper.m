//
//  HYHelper.m
//
//  Created by Ghy on 17/1/6.
//  Copyright © 2017年 ghy. All rights reserved.
//
#define TIME_ZONE @"Asia/Beijing"


#import "HYHelper.h"
#import "sys/utsname.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>
#import <dlfcn.h>


#import <SystemConfiguration/SystemConfiguration.h>
@implementation HYHelper

#pragma mark - 将字符串转化成试图控制器
+ (UIViewController *)StringIntoViewController:(NSString *)classString
{
    UIViewController *vc = [NSClassFromString(classString) new];
    return vc;
}

#pragma mark - 验证银行卡号是否规范
+ (BOOL)validateBankCardWithNumber:(NSString *)cardNum
{
    NSString * CT = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *regextestCard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestCard evaluateWithObject:cardNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 判断身份证号码是否规范
+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

#pragma mark - 拨打电话
+ (void)makePhoneCallWithTelNumber:(NSString *)tel
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}

#pragma mark - 判断手机号码是否正确
+ (BOOL)isValidateMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,155,156,185,186,145,176
     * 电信：133,1349,153,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[47]|5[0-35-9]|7[68]|8[0-9])\\d{8}$";
    
    /**
     * 中国移动
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     */
    NSString * CU = @"^1(3[0-2]|4[5]|5[256]|7[6]|8[56])\\d{8}$";
    /**
     * 中国电信
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 判断手机号码的运营商类型
+ (NSString *)judgePhoneNumTypeOfMobileNum:(NSString *)mobileNum
{
    NSString *phoneNumType = nil;
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,155,156,185,186,145,176
     * 电信：133,1349,153,180,181,189
     */
    //NSString *MOBILE = @"^1(3[0-9]|4[47]|5[0-35-9]|7[68]|8[0-9])\\d{8}$";
    
    /**
     * 中国移动
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     */
    NSString * CU = @"^1(3[0-2]|4[5]|5[256]|7[6]|8[56])\\d{8}$";
    /**
     * 中国电信
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if ([regextestcm evaluateWithObject:mobileNum] == YES)
    {
        phoneNumType = @"移动";
    }
    else if ([regextestct evaluateWithObject:mobileNum] == YES)
    {
        phoneNumType = @"联通";
    }
    else if ([regextestcu evaluateWithObject:mobileNum] == YES)
    {
        phoneNumType = @"电信";
    }
    
    return phoneNumType;
}

#pragma mark - 直接打开网页
+ (void)openURLWithUrlString:(NSString *)url
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
}

#pragma mark - 获取当前时间
+ (NSString *)currentTime
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [formater setTimeZone:timeZone];
    NSString * curTime = [formater stringFromDate:curDate];
    
    return curTime;
}

#pragma mark - 将时间转换成时间戳
/**
 *  时间戳：指格林威治时间1970年01月01日00时00分00秒(北京时间1970年01月01日08时00分00秒)起至现在的总秒数。
 */
+ (NSString *)timeStringIntoTimeStamp:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [dateFormatter dateFromString:time];
    
    NSString *timeSP = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    
    return timeSP;
}

#pragma mark - 将时间戳转换成时间
+ (NSString *)timeStampIntoTimeString:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    /* 设置时区 */
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    //dateString = [dateString substringToIndex:20];
    return  dateString;
}

#pragma mark - 通过时间字符串获取年、月、日
+ (NSArray *)getYearAndMonthAndDayFromTimeString:(NSString *)time
{
    NSString *year = [time substringToIndex:4];
    NSString *month = [[time substringFromIndex:5] substringToIndex:2];
    NSString *day = [[time substringFromIndex:8] substringToIndex:2];
    
    return @[year,month,day];
}
#pragma mark - 获取今天、明天、后天的日期
+ (NSArray *)timeForTheRecentDate
{
    NSMutableArray *dateArr = [[NSMutableArray alloc]init];
    
    //今天
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:TIME_ZONE];
    [formater setTimeZone:timeZone];
    NSString * curTime = [formater stringFromDate:curDate];
    
    NSArray *today = [HYHelper getYearAndMonthAndDayFromTimeString:curTime];
    [dateArr addObject:today];
    
    
    //明天
    NSString *timeStamp = [HYHelper timeStringIntoTimeStamp:curTime];
    NSInteger seconds = 24*60*60 + [timeStamp integerValue];
    timeStamp = [NSString stringWithFormat:@"%ld",(long)seconds];
    curTime = [HYHelper timeStampIntoTimeString:timeStamp];
    
    NSArray *tomorrow = [HYHelper getYearAndMonthAndDayFromTimeString:curTime];
    [dateArr addObject:tomorrow];
    
    
    return [NSArray arrayWithArray:dateArr];
}

#pragma mark - 当前界面截图
+ (UIImage *)imageFromCurrentView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 去掉html中的标签
+ (NSString *)stringRemovetheHTMLtags:(NSString *)htmlString
{
    NSScanner *scanner = [NSScanner scannerWithString:htmlString];
    
    NSString *text = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    scanner = [NSScanner scannerWithString:htmlString];
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"{" intoString:NULL];
        [scanner scanUpToString:@"}" intoString:&text];
        
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@}",text] withString:@""];
    }
    
    return htmlString;
}

#pragma mark - 获取Documents中文件的路径
+ (NSString *)accessToTheDocumentsInTheFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    return filePath;
}

#pragma mark - 生成随机数 n到m
+(int)getRandomNumber:(int)from to:(int)to
{
    
    return (int)(from + (arc4random() % (to-from + 1)));
}

#pragma mark - 判断网址是否有效
+ (BOOL)validateHttp:(NSString *)textString
{
    NSString* number=@"^([w-]+.)+[w-]+(/[w-./?%&=]*)?$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark - 给view设置边框
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

#pragma mark - 将数组中重复的对象去除，只保留一个
+ (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray =  [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}

#pragma mark - 图片大小设置
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 44 * w, colorSpace,kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, size.width/3, size.height/3);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), scaledImage.CGImage);
    //CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //返回新的改变大小后的图片
    return scaledImage;
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

#pragma mark - 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

#pragma mark - 清空字典数据
+(NSMutableDictionary *)clearNullData:(NSDictionary *)dic
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    NSArray *data = dic.allKeys;
    for (int i=0; i<data.count; i++) {
        
        NSString *str = dic[data[i]];
        
        if ((NSNull *)str == [NSNull null]){
            [result setObject:@"" forKey:data[i]];
        }else{
            [result setObject:dic[data[i]] forKey:data[i]];
        }
    }
    
    return result;
}

#pragma mark - 将image 转化成nsdata
+(NSData *)getImageDataWith:(UIImage *)image
{
    NSData *data =UIImagePNGRepresentation(image);
    if (data==nil)
    {
        data =UIImageJPEGRepresentation(image, 0.1);
    }
    return data;
}

#pragma mark - 格式化千分位
+ (NSString *)positiveFormat:(NSString *)text
{
    if(!text || [text floatValue] == 0)
    {
        return @"0.00";
    }
    else if ([text floatValue]<1)
    {
        return [NSString stringWithFormat:@"%@",text];
    }
    else
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@",###.00"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
    }
    return @"";
}

#pragma mark - 不四舍五入  小数
+(NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%0.2f元",[roundedOunces floatValue]];
}

#pragma mark - 获取用户手机信息
+ (NSMutableDictionary *)getUserPhoneInfo
{
    NSMutableDictionary *phoneInfoDict = [NSMutableDictionary new];
    
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //手机序列号（设备号）
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    //手机品牌型号
    [phoneInfoDict setObject:[self getUserPhoneModelNumber] forKey:@"mobiletype"];
    
    //添加手机系统版本
    [phoneInfoDict setObject:phoneVersion forKey:@"sysversion"];
    
    //登录来源 PC IOS Android WeChat
    [phoneInfoDict setObject:@"IOS" forKey:@"logintype"];
    
    //添加应用app版本号
    [phoneInfoDict setObject:appCurVersion forKey:@"appversion"];
    
    //添加手机序列号（设备号）
    [phoneInfoDict setObject:identifierNumber forKey:@"devicenumber"];
    return phoneInfoDict;
}

#pragma mark - 获取手机品牌型号
+ (NSString *)getUserPhoneModelNumber
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}

#pragma mark - 转化成手机号空格式字符串
+ (NSString *)becomePhoneNumTypeWithNSString:(NSString *)string
{
    
    NSString *newString = [[NSString alloc]init];
    
    NSString *first = [string substringToIndex:3];
    
    NSString *second = [string substringWithRange:NSMakeRange(3, 4)];
    NSString *third = [string substringFromIndex:7];
    
    newString = [NSString stringWithFormat:@"%@ %@ %@",first,second,third];
    
    return newString;
}

#pragma mark - 判断手机型号是否是5s以上
+ (BOOL)judgePhoneTypeIsCanFingerprint
{
    
    //获取手机品牌型号
    NSRange range = {6,1};
    
    NSString *phoneModelNum = @"0";
    if ([HYHelper getUserPhoneModelNumber].length >= 7)
    {
        phoneModelNum = [[HYHelper getUserPhoneModelNumber] substringWithRange:range];
    }
    
    if ([phoneModelNum integerValue] > 5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 拼接成中间有空格的字符串(类似银行卡中间空格)
+ (NSString *)jointBlankWithString:(NSString *)str
{
    NSString *getString = @"";
    
    int a = (int)str.length/4;
    int b = (int)str.length%4;
    int c = a;
    if (b>0)
    {
        c = a+1;
    }
    else
    {
        c = a;
    }
    for (int i = 0 ; i<c; i++)
    {
        NSString *string = @"";
        
        if (i == (c-1))
        {
            if (b>0)
            {
                string = [str substringWithRange:NSMakeRange(4*(c-1), b)];
            }
            else
            {
                string = [str substringWithRange:NSMakeRange(4*i, 4)];
            }
            
        }
        else
        {
            string = [str substringWithRange:NSMakeRange(4*i, 4)];
        }
        getString = [NSString stringWithFormat:@"%@ %@",getString,string];
    }
    return getString;
}

#pragma mark - 从单例类（NSUserDefaults）中取出可变数组（用于后面操作添加或者删除元素）
+ (NSMutableArray *)getMutableArrayFromNSUserDefaults:(NSString *)path
{
    NSMutableArray *Array = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //mutableCopy 一定要添加 否则在对数组进行添加或者删除元素等操作的时候线程会卡死
    Array = [[defaults objectForKey:path] mutableCopy];
    
    return Array;
}

#pragma mark - 字典转化成字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma mark - 获取设备IP地址
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {                     // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }     // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - 获取host属性
+ (NSString *)hostname
{
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '/0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}

#pragma mark - 获取本地host(主机)的IP地址
+ (NSString *)localIPAddress
{
    struct hostent *host = gethostbyname([[HYHelper hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

#pragma mark - 获取设备的Mac地址
+ (NSString *)macAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}
@end
