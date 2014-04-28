//
//  SGDocument.m
//  Overlayer
//
//  Created by Satyam Ghodasara on 4/21/14.
//  Copyright (c) 2014 Satyam Ghodasara. All rights reserved.
//

#import "SGDocument.h"

//  Frameworks
#import <StandardPaths/StandardPaths.h>

//  Utilities
#import "SGTextRecognizer.h"
#import "SGDocumentManager.h"
#import "SGUtility.h"


@interface SGDocument ()

@property (readwrite, strong, nonatomic) NSString *title;
@property (readwrite, strong, nonatomic) UIImage *documentImage;
@property (readwrite, strong, nonatomic) NSString *documentFileName;
@property (readwrite, strong, nonatomic) NSString *documentPDFPath;

@property (readwrite, assign, getter = isDrawingLines) BOOL drawingLines;
@property (readwrite, assign) CGFloat drawingLinesProgress;

@end

@implementation SGDocument

+ (instancetype)createDocumentWithImage:(UIImage *)image title:(NSString *)title
{
    SGDocument *document = [[SGDocument alloc] initWithImage:image title:title];
    [[SGDocumentManager sharedManager] saveDocument:document];
    return document;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [super init];
    if (self) {
        NSAssert(title, @"The title is nil");
        
        self.documentFileName = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
        self.documentImage = image;
        self.title = title;
    }
    return self;
}

- (UIImage *)documentImage
{
    return [UIImage imageWithContentsOfFile:[[NSFileManager defaultManager] pathForPublicFile:self.documentFileName]];
}

- (void)setDocumentImage:(UIImage *)documentImage
{
    UIImage *upOrientedImage = [SGUtility imageOrientedUpFromImage:documentImage];
    if (![UIImagePNGRepresentation(upOrientedImage) writeToFile:[[NSFileManager defaultManager] pathForPublicFile:self.documentFileName] atomically:YES]) {
        NSLog(@"Error saving the document image file");
    }
    upOrientedImage = nil;
}

- (NSString *)documentPDFPath
{
    if (!_documentPDFPath) {
        [self generatePDF];
    }
    return [self.documentFileName stringByAppendingPathExtension:@"pdf"];
}

- (void)drawLinesCompletion:(void (^)(UIImage *, NSString *, NSArray *))completion
{
    self.drawingLines = YES;
    __block SGDocument *blockSelf = self;
    [[SGTextRecognizer sharedClient] recognizeTextOnImage:self.documentImage update:^(CGFloat progress) {
        blockSelf.drawingLinesProgress = progress;
    } completion:^(UIImage *imageWithLines, NSString *recognizedText, NSArray *recognizedCharacterRects) {
        blockSelf.documentImage = imageWithLines;
        blockSelf.drawingLines = NO;
        if (completion) {
            completion(imageWithLines, recognizedText, recognizedCharacterRects);
        }
        [[SGDocumentManager sharedManager] saveDocument:blockSelf];
    }];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.documentFileName = [aDecoder decodeObjectForKey:@"documentImageFileName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.documentFileName forKey:@"documentImageFileName"];
}

#pragma mark - Helpers

- (void)generatePDF
{
    NSMutableData *pdfData = [NSMutableData data];
    
    CGSize pdfPageSize = self.documentImage.size;
    CGRect pdfPageRect = CGRectMake(0, 0, pdfPageSize.width, pdfPageSize.height);
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageRect, nil);
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    UIGraphicsBeginPDFPage();
        
    UIImageView *documentImageView = [[UIImageView alloc] initWithImage:self.documentImage];
    [documentImageView.layer renderInContext:pdfContext];
    
    UIGraphicsEndPDFContext();
    
    NSString *pdfFileName = [self.documentFileName stringByAppendingPathExtension:@"pdf"];
    NSString *pdfPath = [[NSFileManager defaultManager] pathForPublicFile:pdfFileName];
    if (![pdfData writeToFile:pdfPath atomically:YES]) {
        NSLog(@"Failed to write PDF file to disk");
    }
}

@end
