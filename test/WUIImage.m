//
//  UIImage-Handling.m
//  WinAdDemo
//
//  Created by frank on 11-5-13.
//  Copyright 2011 wongf70@gmail.com All rights reserved.
//

#import "WUIImage.h"
#import "RZToolManager.h"

@implementation WUIImage
+(NSDictionary*)SeparateImage:(UIImage*)image ByX:(int)x andY:(int)y cacheQuality:(float)quality
{
	
	//kill errors
	if (x<1) {
		NSLog(@"illegal x!");
		return nil;
	}else if (y<1) {
		NSLog(@"illegal y!");
		return nil;
	}
	if (![image isKindOfClass:[UIImage class]]) {
		NSLog(@"illegal image format!");
		return nil;
	}
	
	//attributes of element
	float _xstep=24;
	float _ystep=24;
	NSMutableDictionary*_mutableDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
	//NSArray*_array=[imageName componentsSeparatedByString:@"."];
	//NSString*prefixName=[_array objectAtIndex:0];
	NSString*prefixName=@"win";
	
	//snap in context and create element image view
	for (int i=0; i<x; i++) 
	{
		for (int j=0; j<y; j++) 
		{
			CGRect rect=CGRectMake(_xstep*j, _ystep*i, _xstep, _ystep);
			CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
			UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
            
			UIImageView*_imageView=[[UIImageView alloc] initWithImage:elementImage];
            
			_imageView.frame=rect;
			NSString*_imageString=[NSString stringWithFormat:@"%@_%d_%d.jpg",prefixName,i,j];
			[_mutableDictionary setObject:_imageView forKey:_imageString];
			//CFRelease(imageRef);
			
			if (quality<=0) 
			{
				continue;
			}
			quality=(quality>1)?1:quality;
			NSString*_imagePath=[NSHomeDirectory() stringByAppendingPathComponent:_imageString];
			NSData* _imageData=UIImageJPEGRepresentation(elementImage, quality);
			[_imageData writeToFile:_imagePath atomically:NO];
		}
	}
	//return dictionary including image views
	NSDictionary*_dictionary=_mutableDictionary;
	return _dictionary;
}

@end
