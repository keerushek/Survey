//
//  ImageCache.m
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "ImageCache.h"

#define MAXCACHESIZE 500

ImageCache *globalCache = nil;

@interface ImageCache()
{
    NSMutableArray *_imageCache;
    NSMutableArray *_urlCache;
}
@end

@implementation ImageCache
+ (id)sharedCache
{
    if (globalCache==nil) {
        globalCache = [[ImageCache alloc] init];
    }
    
    return globalCache;
}

- (id)init
{
    self = [super init];
    if (self) {
        _imageCache = [NSMutableArray arrayWithCapacity:MAXCACHESIZE] ;
        _urlCache = [NSMutableArray arrayWithCapacity:MAXCACHESIZE] ;
    }
    
    return self;
}

- (UIImage *)imageForURL:(NSURL *)url
{
    return [self imageForURLString:[url absoluteString]];
}

- (UIImage *)imageForURLString:(NSString *)urlString
{
    @synchronized(self) {
        NSInteger index = [_urlCache indexOfObject:urlString];
        if (index == NSNotFound) {
            return nil;
        }
        return [_imageCache objectAtIndex:index];
    }
}

- (void)addImageToCache:(UIImage *)image forURLString:(NSString *)urlString
{
    if(image != nil)
    {
        @synchronized(self) {
            NSInteger index = [_urlCache indexOfObject:urlString];
            if (index == 0) {
                return;
            }
            if (index != NSNotFound) { // Just move this item to the top of the array
                [_imageCache removeObjectAtIndex:index];
                [_urlCache removeObjectAtIndex:index];
            }
            else if (_urlCache.count >= MAXCACHESIZE) {
                [_imageCache removeObjectAtIndex:MAXCACHESIZE-1];
                [_urlCache removeObjectAtIndex:MAXCACHESIZE-1];
            }
            
            [_urlCache insertObject:urlString atIndex:0];
            [_imageCache insertObject:image atIndex:0];
        }
    }
}

- (void)addImageToCache:(UIImage *)image forURL:(NSURL *)url
{
    [self addImageToCache:image forURLString:[url absoluteString]];
}

- (void)removeImageAtURLStringFromCache:(NSString *)urlString
{
    @synchronized(self) {
        NSInteger index = [_urlCache indexOfObject:urlString];
        if (index != NSNotFound) {
            [_urlCache removeObjectAtIndex:index];
            [_imageCache removeObjectAtIndex:index];
        }
    }
}

- (void)removeImageAtURLFromCache:(NSURL *)url
{
    [self removeImageAtURLStringFromCache:[url absoluteString]];
}

- (void)flushCache
{
    @synchronized(self) {
        [_urlCache removeAllObjects];
        [_imageCache removeAllObjects];
    }
}
@end
