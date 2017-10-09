//
//  RZToolManager.m
//  test
//
//  Created by nykj-mac-03 on 2017/8/30.
//  Copyright © 2017年 12412. All rights reserved.
//
#define TIME_ZONE @"Asia/Beijing"
#import "RZToolManager.h"
@implementation RZToolManager

+ (instancetype)sharedManage{
    static RZToolManager *shareManage = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManage = [[RZToolManager alloc]init];
    });
    return shareManage;
}

+ (NSArray *)ArrayQuChongWith:(NSArray *)array{

  return [array valueForKeyPath:@"@distinctUnionOfObjects.self"];

}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
/*邮箱验证*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

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
+ (NSString *)getWeekDay:(NSTimeInterval)time {
    //创建一个星期数组
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    //将时间戳转换成日期
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
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
    
    NSArray *today = [RZToolManager getYearAndMonthAndDayFromTimeString:curTime];
    [dateArr addObject:today];
    
    
    //明天
    NSString *timeStamp = [RZToolManager timeStringIntoTimeStamp:curTime];
    NSInteger seconds = 24*60*60 + [timeStamp integerValue];
    timeStamp = [NSString stringWithFormat:@"%ld",(long)seconds];
    curTime = [RZToolManager timeStampIntoTimeString:timeStamp];
    
    NSArray *tomorrow = [RZToolManager getYearAndMonthAndDayFromTimeString:curTime];
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

+(int)getRandomNumber:(int)from to:(int)to
{
    
    return (int)(from + (arc4random() % (to-from + 1)));
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

+ (NSString *)becomePhoneNumTypeWithNSString:(NSString *)string
{
    
    NSString *newString = [[NSString alloc]init];
    
    NSString *first = [string substringToIndex:3];
    
    NSString *second = [string substringWithRange:NSMakeRange(3, 4)];
    NSString *third = [string substringFromIndex:7];
    
    newString = [NSString stringWithFormat:@"%@ %@ %@",first,second,third];
    
    return newString;
}
#pragma mark - 字典转化成字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+ (NSMutableAttributedString *)changeColor:(UIColor *)color andRanges:(NSArray<NSValue *> *)ranges string:(NSString *)textString{
    
    __block NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:textString];
    
    if (color) {
        [ranges enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [(NSValue *)obj rangeValue];
            
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        
        }];
    }
    else{
        NSLog(@"color is nil...");
    }
    return attributedStr;
}

+ (UIImage *)getyuanxingImage:(UIImage *)image{
    // borderWidth 表示边框的宽度
    CGFloat imageW = image.size.width + 2 * 0.5;
    CGFloat imageH = imageW; CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // borderColor表示边框的颜色
    [[UIColor clearColor] set];
    CGFloat bigRadius = imageW * 0.5; CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    CGFloat smallRadius = bigRadius - 0.5;
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    [image drawInRect:CGRectMake(0.5, 0.5, 24, 24)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;


}





@end
