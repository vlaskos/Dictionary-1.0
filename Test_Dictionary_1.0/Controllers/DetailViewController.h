//
//  DetailViewController.h
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 25.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordsModel.h"
#import "Words.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) WordsModel *model;

@end
