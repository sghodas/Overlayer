//
//  SGMainViewController.h
//  Overlayer
//
//  Created by Satyam Ghodasara on 4/9/14.
//  Copyright (c) 2014 Satyam Ghodasara. All rights reserved.
//

//  Frameworks
#import <QuickLook/QuickLook.h>


@interface SGMainViewController : UIViewController <UIImagePickerControllerDelegate,  UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate, QLPreviewControllerDataSource, UIScrollViewDelegate>

- (void)createDocumentWithImage:(UIImage *)image;

@end
