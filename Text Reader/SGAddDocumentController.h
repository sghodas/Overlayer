//
//  SGAddDocumentController.h
//  Text Reader
//
//  Created by Satyam Ghodasara on 10/23/13.
//  Copyright (c) 2013 Satyam Ghodasara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGAddDocumentController;


@protocol SGAddDocumentDelegate <NSObject>

- (void)addDocumentController:(SGAddDocumentController *)addDocumentVC didAddDocumentWithTitle:(NSString *)title;

@end


@interface SGAddDocumentController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<SGAddDocumentDelegate> delegate;

@end