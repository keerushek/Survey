//
//  ImageCache.h
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject
+ (id)sharedCache;
- (UIImage *)imageForURL:(NSURL *)url;
- (UIImage *)imageForURLString:(NSString *)urlString;
- (void)addImageToCache:(UIImage *)image forURLString:(NSString *)urlString;
- (void)addImageToCache:(UIImage *)image forURL:(NSURL *)url;
- (void)removeImageAtURLStringFromCache:(NSString *)urlString;
- (void)removeImageAtURLFromCache:(NSURL *)url;
- (void)flushCache;
@end
