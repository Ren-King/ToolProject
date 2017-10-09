//
//  NetWorkManager.h
//  AFB
//
//  Created by nykj-mac-03 on 2017/3/18.
//  Copyright © 2017年 com.ecard.ecardiostest. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Sucess)(id responseData);
typedef void(^Failure)(NSError *error);
@interface NetWorkManager : NSObject
+ (instancetype)sharedInstance;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)getWithURLString:(NSString *)URLString success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

@end
