// UIButton+AFNetworking.m
//
// Copyright (c) 2013 AFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIButton+AFNetworking.h"
#import "NSString+NSString_MD5HexDigest.h"
#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import "AFHTTPRequestOperation.h"

@interface UIButton (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFHTTPRequestOperation *af_imageRequestOperation;
@property (readwrite, nonatomic, strong, setter = af_setBackgroundImageRequestOperation:) AFHTTPRequestOperation *af_backgroundImageRequestOperation;
@end

@implementation UIButton (_AFNetworking)

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_sharedImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_sharedImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        _af_sharedImageRequestOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    });

    return _af_sharedImageRequestOperationQueue;
}

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, @selector(af_imageRequestOperation));
}

- (void)af_setImageRequestOperation:(AFHTTPRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, @selector(af_imageRequestOperation), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFHTTPRequestOperation *)af_backgroundImageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, @selector(af_backgroundImageRequestOperation));
}

- (void)af_setBackgroundImageRequestOperation:(AFHTTPRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, @selector(af_backgroundImageRequestOperation), imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark -

@implementation UIButton (AFNetworking)

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
{
    [self setImageForState:state withURL:url placeholderImage:nil];

}

- (void)setImageForState:(UIControlState)state
                 withURL:(NSURL *)url
        placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageForState:(UIControlState)state
          withURLRequest:(NSURLRequest *)urlRequest
        placeholderImage:(UIImage *)placeholderImage
                 success:(void (^)(NSHTTPURLResponse *response, UIImage *image))success
                 failure:(void (^)(NSError *error))failure
{
    [self cancelImageRequestOperation];

    [self setImage:placeholderImage forState:state];

    __weak __typeof(self)weakSelf = self;
    self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    self.af_imageRequestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[operation.request URL]]) {
            if (success) {
                success(operation.response, responseObject);
            } else if (responseObject) {
                [strongSelf setImage:responseObject forState:state];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([[urlRequest URL] isEqual:[operation.response URL]]) {
            if (failure) {
                failure(error);
            }
        }
    }];

    [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
}

#pragma mark -

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
{
    [self setBackgroundImageForState:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSURL *)url
                  placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setBackgroundImageForState:state withURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                    withURLRequest:(NSURLRequest *)urlRequest
                  placeholderImage:(UIImage *)placeholderImage
                           success:(void (^)(NSHTTPURLResponse *response, UIImage *image))success
                           failure:(void (^)(NSError *error))failure
{
    [self cancelBackgroundImageRequestOperation];

    [self setBackgroundImage:placeholderImage forState:state];
    
    
    //加载本地
    NSString *urlString = [[urlRequest URL] absoluteString];
    NSString* md5StrUrl = [[urlString md5HexDigest] stringByAppendingString:@".png"];
    
    NSData *data = [self loadImageData:[self pathInDocDirectory:@"dahanPic"] imageName:md5StrUrl];
    if (data)
    {
        UIImage* img = [UIImage imageWithData:data];
        [self setBackgroundImage:img forState:state];
        
        self.af_imageRequestOperation = nil;
            
        if (success) {
            success(nil, img);
        }
        return;
    }
        
    __weak __typeof(self)weakSelf = self;
    self.af_backgroundImageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    self.af_backgroundImageRequestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [self.af_backgroundImageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([[urlRequest URL] isEqual:[operation.request URL]]) {
            if (success) {
                success(operation.response, responseObject);
            } else if (responseObject) {
                [strongSelf setBackgroundImage:responseObject forState:state];
            }
            
            //图片本地缓存
            if ([weakSelf createDirInDoc:@"dahanPic"]) {
                NSString *imageType = @"png";
                //从url中获取图片类型
                　　NSMutableArray *arr = (NSMutableArray *)[urlString componentsSeparatedByString:@"."];
                if (arr) {
                    imageType = [arr objectAtIndex:arr.count-1];
                }
                [weakSelf saveImageToDocDir:[weakSelf pathInDocDirectory:@"dahanPic"] image: responseObject imageName:[urlString md5HexDigest] imageType:imageType];
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([[urlRequest URL] isEqual:[operation.response URL]]) {
            if (failure) {
                failure(error);
            }
        }
    }];

    [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_backgroundImageRequestOperation];
}

#pragma mark -

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

- (void)cancelBackgroundImageRequestOperation {
    [self.af_backgroundImageRequestOperation cancel];
    self.af_backgroundImageRequestOperation = nil;
}

-(NSString* )pathInDocDirectory:(NSString *)fileName
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹
-(BOOL) createDirInDoc:(NSString *)dirName
{
    NSString *imageDir = [self pathInDocDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

// 删除图片缓存
- (BOOL) deleteDirInDoc:(NSString *)dirName
{
    NSString *imageDir = [self pathInDocDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
    }
    
    return isDeleted;
}

// 图片本地缓存
- (BOOL) saveImageToDocDir:(NSString *)directoryPath  image:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType
{
    BOOL isDir = NO;

    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            
            NSString* str = [directoryPath stringByAppendingString:@"/"];
            NSString* str1 = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
            
            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        }
        else
        {
            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    return isSaved;
}
// 获取缓存图片
-(NSData*) loadImageData:(NSString *)directoryPath imageName:( NSString *)imageName
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *imagePath = [[directoryPath stringByAppendingString :@"/"] stringByAppendingString:imageName];
        BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : imagePath];
        return imageData;
    }
    else
    {
        return NULL;
    }
}

@end

#endif
