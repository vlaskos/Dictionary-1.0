//
//  ViewController.m
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 25.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "GeneralViewController.h"
#import "DetailViewController.h"

#import "NetworkManager.h"
#import <MagicalRecord/MagicalRecord.h>

#import "Words.h"
#import "Words+CoreDataProperties.h"
#import "WordsModel.h"


@interface GeneralViewController () <UITableViewDataSource,
                                     UITableViewDelegate,
                                     UISearchBarDelegate, UISearchDisplayDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *sortedArray;
@property (strong, nonatomic) NSMutableArray * models;

@property (strong, nonatomic) NSString *transText;
@property (strong, nonatomic) NSString *origText;
@property (strong, nonatomic) NSString *lanlguageType;


@end

@implementation GeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self fetchingAllData];
    [self.tableView reloadData];
    
    self.searchBar.delegate = self;
    [self.searchBar setValue:@"Translate" forKey:@"_cancelButtonText"];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self fetchingAllData];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Private Methods


- (void) addWordsToCoreData {
    

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Words *localPerson = [Words MR_createEntityInContext:localContext];
        
        if (!self.words) {
            self.words = [Words MR_createEntity];
        }
        
        localPerson.translatedWord = self.transText;
        localPerson.rootWord = self.origText;
        
    } completion:nil];
    
    
}

- (void) fetchingAllData {
    
    NSArray *wordsArray = [Words  MR_findAll];
    
    NSMutableArray *array = [NSMutableArray new];
    
    for (Words *words in wordsArray) {

        WordsModel * model = [WordsModel new];
        
        NSString *rootWord = words.rootWord;
        model.rootWord = rootWord;
        
        NSString *translatedWord = words.translatedWord;
        model.translatedWord = translatedWord;
        
        [array addObject:model];
    }
    self.models = array;
    self.sortedArray = self.models;
}


- (NSMutableArray*) generateNameFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
    NSMutableArray *arrayObjects = [NSMutableArray array];
    
    for (WordsModel* model in array) {
        if ([filterString length] > 0 && [model.rootWord rangeOfString:filterString].location == NSNotFound) {
            continue;
        }
        [arrayObjects addObject:model];
    }
    return arrayObjects;
}

#pragma mark - API

- (void) getTranslationText {
    
    [[NetworkManager sharedManager]
     postTranslationText:self.searchBar.text
            withLanguage:self.lanlguageType
               onSuccess:^(id result) {
                   
                   NSArray *resultWords = [result valueForKeyPath:@"matches"];
                   NSDictionary *dict = [resultWords objectAtIndex:0];
                   self.transText = [dict valueForKeyPath:@"translation"];
                   self.origText = [dict valueForKey:@"segment"];
                   
                   NSArray *sourseWords = [self.models valueForKeyPath:@"@unionOfObjects.rootWord"];
                   
                   if (!([sourseWords containsObject:self.origText])) {
                       
                      [self addWordsToCoreData];
                   }
                   
                   WordsModel *model = [WordsModel new];
                   model.rootWord = self.origText;
                   model.translatedWord = self.transText;
                   
                   DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
                   [vc setModel:model];
                   [self.navigationController pushViewController:vc animated:YES];
                
                   
             } onFailure:^(NSError *error, id responseObject) {
                if (responseObject[@"detail"]) {
                    NSLog(@"%@",responseObject);
                }
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    WordsModel * model = [self.sortedArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.rootWord;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordsModel * model = [self.sortedArray objectAtIndex:indexPath.row];
    
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [vc setModel:model];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:NO animated:YES];
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    for (int i = 0; i < [searchBar.text length]; i++)
    {
        unichar c = [searchBar.text characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            self.lanlguageType = @"ru|en";
        }
        else {
            self.lanlguageType = @"en|ru";
        }
    }
    
    if (searchBar.text.length > 0) {
         [self getTranslationText];
    }
    
    self.sortedArray = self.models;
     [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

   self.sortedArray = [self generateNameFromArray:self.models withFilter:searchText];
    [self.tableView reloadData];

}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    BOOL canEdit=NO;
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюяІіЇїЄє"
                                 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    for (int i = 0; i < [text length]; i++)
    {
        unichar c = [text characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            canEdit=NO;
        }
        else {
            canEdit=YES;
        }
    }
    
    if (range.length == 1) {
        return text;
    }

    return canEdit;
    
}


@end
