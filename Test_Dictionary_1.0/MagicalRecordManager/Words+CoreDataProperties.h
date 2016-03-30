//
//  Words+CoreDataProperties.h
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 29.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Words.h"

NS_ASSUME_NONNULL_BEGIN

@interface Words (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *rootWord;
@property (nullable, nonatomic, retain) NSString *translatedWord;

@end

NS_ASSUME_NONNULL_END
