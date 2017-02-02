//
//  CommonManagedObject.m
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "CommonManagedObject.h"

@implementation CommonManagedObject

+ (NSManagedObjectContext *)context
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

+ (NSManagedObjectContext *)privateContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:[self context]];
    return context;
}

+ (NSString *)modelName
{
    NSAssert(1, @"Cannot call this from the base model");
    return @"";
}

+ (id)addNewInContext:(NSManagedObjectContext *)context
{
    NSManagedObject *object;
    
    object = [NSEntityDescription insertNewObjectForEntityForName:[self modelName] inManagedObjectContext:context];
    
    if (object == nil)
    {
        @throw [NSException exceptionWithName:@"[ManagedObject addNew] failed" reason:[NSString stringWithFormat:@"Model name: %@",[self modelName]] userInfo:nil];
    }
    return object;
}

+ (id)addNew
{
    return [self addNewInContext:[self context]];
}

+ (BOOL)saveInContext:(NSManagedObjectContext *)context
{
    BOOL returnValue = YES;
    
    NSError *error = nil;
    [context save:&error];
    if (error!=nil)
    {
        @throw [NSException exceptionWithName:@"+[BBManagedObject save] failed." reason:error.localizedDescription userInfo:nil];
        returnValue = NO;
    }
    return returnValue;
}

+ (BOOL)save
{
    return [self saveInContext:[self context]];
}

+ (id)objectWithID:(NSManagedObjectID *)objectID
{
    return [[self context] objectWithID:objectID];
}

+ (id)objectWithID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context
{
    return [context objectWithID:objectID];
}

- (BOOL)saveInContext:(NSManagedObjectContext *)context
{
    BOOL returnValue = YES;
    NSError *error = nil;
    
    [context save:&error];
    if (error!=nil) {
        @throw [NSException exceptionWithName:@"-[BBManagedObject save] failed." reason:error.localizedDescription userInfo:nil];
    }
    return returnValue;
}

- (BOOL)save
{
    return [self saveInContext:[self.class context]];
}

-(void)refreshInContext:(NSManagedObjectContext *)context mergeChanges:(BOOL)mergeChanges
{
    [context refreshObject:self mergeChanges:mergeChanges];
}

- (void)refresh:(BOOL)mergeChanges
{
    [self refreshInContext:[self.class context] mergeChanges:mergeChanges];
}

- (void)delete
{
    [self deleteInContext:[self.class context]];
}

- (void)deleteInContext:(NSManagedObjectContext *)context
{
    [context deleteObject:self];
}

+ (NSArray *)fetchManagedObjectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)moc includePropertyValues:(BOOL)includePropertyValues
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:[self modelName] inManagedObjectContext:moc]];
    [fetchRequest setIncludesPropertyValues:includePropertyValues];
    // Add a sort descriptor. Mandatory.
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    NSArray *fetchResults = [moc executeFetchRequest:fetchRequest error:&error];
    
    if (fetchResults == nil)
    {
        // Handle the error.
        NSLog(@"executeFetchRequest failed with error: %@", [error localizedDescription]);
    }
    
    return fetchResults;
}

+ (NSManagedObject *)fetchManagedObjectWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)moc includePropertyValues:(BOOL)includePropertyValues
{
    NSArray *fetchResults = [self fetchManagedObjectsWithPredicate:predicate withSortDescriptors:sortDescriptors andContext:moc includePropertyValues:includePropertyValues];
    
    NSManagedObject *managedObject = nil;
    
    if (fetchResults && [fetchResults count] > 0)
    {
        // Found record
        managedObject = [fetchResults objectAtIndex:0];
    }
    
    return managedObject;
}

@end
