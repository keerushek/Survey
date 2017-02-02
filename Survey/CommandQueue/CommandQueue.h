//
//  CommandQueue.h
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandBase.h"

@interface CommandQueue : NSOperationQueue

/**User Shared Instance of CommandQueue*/
+ (instancetype)sharedCommandQueueInstance;

/**Add Derived class to CommandQueue*/
- (BOOL)addClassToCommandQueue:(CommandBase *)classToAdd;

/**Remove Derived Class from CommandQueue */
- (void)removeClassFromCommandQueue:(CommandBase *)classToRemove;

@end
