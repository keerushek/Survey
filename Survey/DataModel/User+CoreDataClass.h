//
//  User+CoreDataClass.h
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CommonManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : CommonManagedObject

+ (NSArray *)getAllUserAccounts;
+ (NSArray *)getAllUserAccountsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (User *)getUserAccountWithEmail:(NSString *)email;
+ (User *)getUserAccountWithEmail:(NSString *)email withManagedObjectContext:(NSManagedObjectContext *)moc;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
