//
//  User+CoreDataProperties.m
//  Survey
//
//  Created by Keerthi Shekar G on 31/01/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic accessToken;
@dynamic createdAt;
@dynamic expiresIn;
@dynamic userName;

@end
