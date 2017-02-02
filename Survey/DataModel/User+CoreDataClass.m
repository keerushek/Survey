//
//  User+CoreDataClass.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "User+CoreDataClass.h"

@implementation User
+ (NSString *)modelName
{
    return @"User";
}
+ (NSArray *)getAllUserAccounts
{
    return [self getAllUserAccountsInManagedObjectContext:[self context]];
}

+ (NSArray *)getAllUserAccountsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *userAccountsArray = [self fetchManagedObjectsWithPredicate:nil withSortDescriptors:nil andContext:context includePropertyValues:YES];
    
    return (userAccountsArray.count > 0) ? userAccountsArray : [NSArray array];
}

+ (User *)getUserAccountWithEmail:(NSString *)email
{
    return [self getUserAccountWithEmail:email withManagedObjectContext:[self context]];
}
+ (User *)getUserAccountWithEmail:(NSString *)email withManagedObjectContext:(NSManagedObjectContext *)moc
{
    if((email == nil) && (moc == nil))
        return  nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userName == %@)", email];
    
    return (User *)[self fetchManagedObjectWithPredicate:predicate withSortDescriptors:nil andContext:moc includePropertyValues:YES];
}
@end
