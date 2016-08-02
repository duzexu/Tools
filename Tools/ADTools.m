//
//  ADTools.m
//  Tools
//
//  Created by WangMengZhi on 13-5-3.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//

#import "ADTools.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation ADTools
/**
 *  @brief  判断邮箱格式是否正确 利用正则表达式验证
 *
 *  @param  email NSString类型 要判断的邮箱名
 *
 *  @return BOOL型 是否正确
 */
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 *  @brief  图片形状改变
 *
 *  @param  image   UIImage型  原始图片
 *  @param  newSize CGSize型   要改变的大小
 *
 *  @return UIImage型  改变后的图片
 */
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this newcontext, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
/**
 *  @brief  截取屏幕图片(引入QuartzCore)
 *
 *  @param  size  CGSize型  截取的大小
 *  @param  view  UIView型  截取的原始view
 *
 *  @return UIImage型  截取的图片
 */
- (UIImage*)getScreenImageInRect:(CGSize)size onView:(UIView*)view
{
    //创建一个基于位图的图形上下文并指定大小为size
    UIGraphicsBeginImageContext(size);
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //返回一个基于当前图形上下文的图片
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    return aImage;
    //苹果最新接口
//    CGImageRef UIGetScreenImage();
//    CGImageRef img = UIGetScreenImage();
//    UIImage* scImage=[UIImage imageWithCGImage:img];
//    return scImage;
}
/**
 *  @brief  图片上添加文字
 *
 *  @param  img    UIImage型   需要加文字的图片
 *  @param  atext  NSString型  文字描述
 *
 *  @return  UIImage型  加好文字的图片
 */
-(UIImage *)addText:(UIImage *)img text:(NSString *)atext
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[atext cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Georgia", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 255, 255, 0.8);
    
    //位置调整
    CGContextShowTextAtPoint(context, w/2-strlen(text)*4.5 , h - 135, text, strlen(text));
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

/**
 *  把两张图片合成一张
 *
 *  @param image1 图片1
 *  @param image2 图片2
 *  @param rect1  1的位置
 *  @param rect2  2的位置
 *
 *  @return 合成的图片
 */
- (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 {
    CGSize size = CGSizeMake(rect1.size.width+rect2.size.width, rect1.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    [image1 drawInRect:rect1];
    [image2 drawInRect:rect2];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

/**
 *  @brief  查看网络连接是否可用(引入SystemConfiguration netdb)
 *
 *  @return BOOL型 是否可用
 */
-(BOOL)netWorkIsExistence{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
/**
 *  @brief  给文件路径添加不要备份属性
 *          应用的离线文件(如杂志,地图等)添加不要备份属性可以避免被itunes和iCloud备份
 *          系统是5.0.1以上的才支持
 *          引入 #import <sys/xattr.h>
 *  @return BOOL型 是否成功
 */
#import <sys/xattr.h>
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)aFilePath
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:aFilePath]);
    
    NSError *error = nil;
    BOOL success = NO;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 5.1f)
    {
        success = [[NSURL fileURLWithPath:aFilePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                               forKey:NSURLIsExcludedFromBackupKey
                                                                error:&error];
    }
    else if ([systemVersion isEqualToString:@"5.0.1"])
    {
        const char* filePath = [aFilePath fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }
    else
    {
        NSLog(@"Can not add 'do no back up' attribute at systems before 5.0.1");
    }
    
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [aFilePath lastPathComponent], error);
    }
    
    return success;
}
/**
 *  @brief  读取一张图片的属性,而不用把图片读取到内存(加入 ImageI/O 框架)
 *
 *  @param  imageName    NSString型   图片名
 *
 */
#import <ImageIO/ImageIO.h>
- (void)imageProperties:(NSString*)imageName
{
    //#import <ImageIO/ImageIO.h>
    //Some path
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];
    NSURL* imageFileURL = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileURL, NULL);
    if (imageSource) {
        NSDictionary* options = @{(NSString*)kCGImageSourceShouldCache:@NO};
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);
        if (imageProperties) {
            NSLog( @"properties: %@", imageProperties);
            CFRelease(imageProperties);
        }
    } else {
        NSLog(@" Error loading image");
    }
}

/**
 *  @brief  把汉字转为拼音
 *
 *  @param  String   NSString型   转换的字符串
 *
 *  @return NSString型 转换后的字符串
 */
- (NSString*)ChineseToPinyin:(NSString*)String
{
    //用到的函数
    // Boolean CFStringTransform(CFMutableStringRef string, CFRange *range, CFStringRef transform, Boolean reverse);
    //  string参数是要转换的string,比如要转换的中文，同时它是mutable的，因此也直接作为最终转换后的字符串。
    //  range是要转换的范围，同时输出转换后改变的范围，如果为NULL，视为全部转换
    //  transform可以指定要进行什么样的转换，这里可以指定多种语言的拼写转换。
    //  reverse指定该转换是否必须是可逆向转换的。
    //  如果转换成功就返回true，否则返回false。
    
    //如果要进行汉字到拼音的转换，我们只需要将transform设定为kCFStringTransformMandarinLatin或者kCFStringTransformToLatin（kCFStringTransformToLatin也可适用于非汉字字符串）
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (CFStringRef)String);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"== %@",string);
    //不需要音标
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSLog(@"## %@", string);
    return (NSString*)string;
}

/**
 *  @brief  得到手机的Mac地址
 *          引入 #import <sys/socket.h> <sys/sysctl.h> <net/if.h> <net/if_dl.h>
 *  @return NSString型 Mac地址
 */
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
- (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        
        // Release the buffer memory
        free(msgBuffer);
        
        return macAddressString;
    }
    
    return errorFlag;
}


#import <CoreText/CoreText.h>
/**
 *  根据文字生成Path
 *
 *  @param text     文字
 *  @param reversed 正向还是反向
 *
 *  @return path
 */
+ (UIBezierPath *)pathRefFromText: (NSAttributedString *)text reversed: (BOOL)reversed
{
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line           = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)text);
    CFArrayRef runArray      = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++){
        CTRunRef run      = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++){
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            CGPathRef letter       = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t    = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    CGRect boundingBox = CGPathGetBoundingBox(letters);
    CGPathRelease(letters);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    if (reversed) {
        return [path bezierPathByReversingPath] ;
    }
    return path;
}

#import <objc/runtime.h>
void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)  {    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//找到view转换后的坐标
- (void)method
{
    UIView *view = nil;
    CGPoint originCenter = CGPointApplyAffineTransform(view.center, CGAffineTransformInvert(view.transform));
    CGPoint topRight = originCenter;
    topRight.x += view.bounds.size.width/2.0;
    topRight.y -= view.bounds.size.height/2.0;
    topRight = CGPointApplyAffineTransform(topRight, view.transform);
}

#pragma mark - 富文本操作

/**
 *  单纯改变一句话中的某些字的颜色
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subArray) {
        
        NSMutableArray *array = [self ls_getRangeWithTotalString:totalStr SubString:rangeStr];
        
        for (NSNumber *rangeNum in array) {
            
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        
    }
    
    return attributedStr;
}

/**
 *  单纯改变句子的字间距（需要 <CoreText/CoreText.h>）
 *
 *  @param totalString 需要更改的字符串
 *  @param space       字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeSpaceWithTotalString:(NSString *)totalString Space:(CGFloat)space {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    long number = space;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  单纯改变段落的行间距
 *
 *  @param totalString 需要更改的字符串
 *  @param lineSpace   行间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    return attributedStr;
}

/**
 *  同时更改行间距和字间距
 *
 *  @param totalString 需要改变的字符串
 *  @param lineSpace   行间距
 *  @param textSpace   字间距
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeLineAndTextSpaceWithTotalString:(NSString *)totalString LineSpace:(CGFloat)lineSpace textSpace:(CGFloat)textSpace {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalString length])];
    
    long number = textSpace;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attributedStr addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedStr length])];
    CFRelease(num);
    
    return attributedStr;
}

/**
 *  改变某些文字的颜色 并单独设置其字体
 *
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param totalString 总的字符串
 *  @param subArray    想要变色的字符数组
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_changeFontAndColor:(UIFont *)font Color:(UIColor *)color TotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}

/**
 *  为某些文字改为链接形式
 *
 *  @param totalString 总的字符串
 *  @param subArray    需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)ls_addLinkWithTotalString:(NSString *)totalString SubStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        [attributedStr addAttribute:NSLinkAttributeName value:totalString range:range];
    }
    
    return attributedStr;
}

#pragma mark - 获取某个子字符串在某个总字符串中位置数组
/**
 *  获取某个字符串中子字符串的位置数组
 *
 *  @param totalString 总的字符串
 *  @param subString   子字符串
 *
 *  @return 位置数组
 */
+ (NSMutableArray *)ls_getRangeWithTotalString:(NSString *)totalString SubString:(NSString *)subString {
    
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [totalString rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange      rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (int i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = totalString.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                
                location = rang1.location + rang1.length;
                length = totalString.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [totalString rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        
        return arrayRanges;
    }
    
    return nil;
}

#pragma mark - 选择相册相关API

/**
 *  获取相册的图片
 *
 *  @param result 获取到的图片
 *  @param error  失败信息
 */
+ (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error
{
    NSMutableArray *savedPhotoList = [NSMutableArray array];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= __IPHONE_9_0) {
        
        NSMutableArray* assetarray = [NSMutableArray array];
        PHFetchResult* collections = [PHAssetCollection fetchMomentsWithOptions:nil];
        
        for (PHAssetCollection* collection in collections) {
            PHFetchResult* assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            for (PHAsset* asset in assets) {
                if (asset.mediaType ==  PHAssetMediaTypeImage) {
                    [assetarray addObject:asset];
                }
            }
        }
        
        [assetarray sortUsingComparator:^NSComparisonResult(PHAsset* obj1, PHAsset* obj2) {
            return [obj2.creationDate compare:obj1.creationDate];
        }];
        
        if (result) {
            result(assetarray);
        }
        return;
        
    }
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        
        
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos) {
            
            [group setAssetsFilter: [ALAssetsFilter allPhotos]];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
                @autoreleasepool {
                    
                    if(alPhoto == nil) {
                        
                        NSArray * tempArray = [savedPhotoList copy];
                        [savedPhotoList removeAllObjects];
                        [savedPhotoList addObjectsFromArray: [[tempArray reverseObjectEnumerator] allObjects]];
                        
                        
                        result([savedPhotoList mutableCopy]);
                        
                        return;
                    }
                    
                    [savedPhotoList addObject:alPhoto];
                }
            }];
        }
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err) {
        
        NSLog(@"Asset read Error : %@", [err description]);
    };
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
}

/**
 *  获取asset中的image
 *
 *  @param asset       PSAsset
 *  @param size        尺寸
 *  @param completion  完成block
 *  @param synchronous 是否异步
 */
+ (void)generaImaeWithAsset:(PHAsset *)asset size:(CGSize)size completion:(void (^)(UIImage *))completion synchronous:(BOOL)synchronous {
    
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc]init];
    options.synchronous = synchronous;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (completion) {
            completion(result);
        }
    }];
    
}

/**
 *  获取Asset中的size
 *
 *  @param asset Asset
 *
 *  @return 得到的size
 */
+ (CGSize)getSizeFromAsset:(id)asset {
    
    CGSize size;
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHAsset* pa = (PHAsset*)asset;
        size = CGSizeMake(pa.pixelWidth, pa.pixelHeight);
    } else {
        
        ALAssetRepresentation * representation = [asset defaultRepresentation];
        size = [representation dimensions];
    }
    
    return size;
}

/**
 *  从asset中截取一定尺寸的图片
 *
 *  @param asset asset
 *  @param size  需要的尺寸
 *
 *  @return 得到的image
 */
+ (UIImage *)getThumImageFromAsset:(id)asset withSize:(CGSize)size {
    
    __block UIImage *image;
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHAsset* pa = (PHAsset*)asset;
        
        [self generaImaeWithAsset:pa size:size completion:^(UIImage *result) {
            
            image = result;
        } synchronous:YES];
        
    } else {
        
        if ([[[UIDevice alloc] systemVersion] floatValue] >= 9.0) {
            
            image = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];;
        } else {
            
            image = [UIImage imageWithCGImage:[asset thumbnail]];;
        }
    }
    
    return image;
    
}

@end
