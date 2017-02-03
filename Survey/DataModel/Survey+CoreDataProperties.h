//
//  Survey+CoreDataProperties.h
//  Survey
//
//  Created by Keerthi Shekar G on 03/02/17.
//  Copyright © 2017 Keerthi Shekar G. All rights reserved.
//

#import "Survey+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Survey (CoreDataProperties)

+ (NSFetchRequest<Survey *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *surveyDescription;
@property (nullable, nonatomic, copy) NSString *surveyImageUrl;
@property (nullable, nonatomic, copy) NSString *surveyName;
@property (nullable, nonatomic, copy) NSString *surveyId;

@end

NS_ASSUME_NONNULL_END
