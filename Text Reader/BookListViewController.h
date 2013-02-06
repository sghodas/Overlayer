//
//  BookListViewController.h
//  Text Reader
//
//  Created by Satyam Ghodasara on 1/31/13.
//  Copyright (c) 2013 Satyam Ghodasara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageListViewController.h"

@interface BookListViewController : UITableViewController

@property PageListViewController *pageListViewController;
@property NSMutableArray *books;
@property NSString *documentsDirectory;

- (void)firstLoad;
- (IBAction)addBook:(id)sender;

@end