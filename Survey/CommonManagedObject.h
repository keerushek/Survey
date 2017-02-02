//
//  CommonManagedObject.h
//  Survey
//
//  Created by Keerthi Shekar G on 02/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CommonManagedObject : NSManagedObject

+ (NSString *)modelName;
+ (NSManagedObjectContext *)context;
+ (NSManagedObjectContext *)privateContext;
+ (id)addNew;
+ (id)addNewInContext:(NSManagedObjectContext *)context;
+ (BOOL)save;
+ (BOOL)saveInContext:(NSManagedObjectContext *)context;
+ (id)objectWithID:(NSManagedObjectID *)objectID;
+ (id)objectWithID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context;

- (BOOL)save;
- (BOOL)saveInContext:(NSManagedObjectContext *)context;
- (void)delete;
- (void)deleteInContext:(NSManagedObjectContext *)context;
- (void)refresh:(BOOL)mergeChanges;
- (void)refreshInContext:(NSManagedObjectContext *)context mergeChanges:(BOOL)mergeChanges;

+ (NSArray *)fetchManagedObjectsWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)moc includePropertyValues:(BOOL)includePropertyValues;
+ (NSManagedObject *)fetchManagedObjectWithPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)moc includePropertyValues:(BOOL)includePropertyValues;

@end
