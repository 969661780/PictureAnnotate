//
//  MTHandPaintedViewController.m
//  PictureAnnotate
//
//  Created by mt y on 2018/6/25.
//  Copyright © 2018年 mt y. All rights reserved.
//

#import "MTHandPaintedViewController.h"
#import "HBDrawSettingBoard.h"
#import "UIView+WHB.h"
#import "HBDrawingBoard.h"
#import "HBDrawCommon.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
@interface MTHandPaintedViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HBDrawingBoardDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (nonatomic, strong) HBDrawingBoard *drawView;
@property (nonatomic, copy) boardSettingBlock stype;

@end

@implementation MTHandPaintedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Image annotation";
    [self.view addSubview:self.drawView];
    [[NSNotificationCenter defaultCenter] postNotificationName:ImageBoardNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self.imageView forKey:@"imageBoardName"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -touch
- (IBAction)lineBtn:(UIButton *)sender {
    self.drawView.shapType = 1;
    
    [self.drawView showSettingBoard];
}
- (IBAction)tuoYuanBtn:(UIButton *)sender {
    
     self.drawView.shapType = 3;
    [self.drawView showSettingBoard];
}
- (IBAction)juxingBtn:(UIButton *)sender {
    
    self.drawView.shapType = 2;
    [self.drawView showSettingBoard];
}
- (IBAction)abcBtn:(UIButton *)sender {
    self.drawView.shapType = ((UIButton *)sender).tag;
    
    [self.drawView showSettingBoard];
}
- (IBAction)pointBtn:(UIButton *)sender {
    self.drawView.shapType = 0;
    
    [self.drawView showSettingBoard];
}
- (IBAction)saveBtn:(UIButton *)sender {
    if (self.stype) {
        self.stype(setTypeSave);
    }
    UIGraphicsBeginImageContextWithOptions(self.myImageView.frame.size, NO, 0.0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),  (__bridge void *)self);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    [SVProgressHUD showSuccessWithStatus:@"Saved successfully"];
    [SVProgressHUD dismissWithDelay:1.0];
}
- (HBDrawingBoard *)drawView
{
    if (!_drawView) {
        _drawView = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0, 0, ZHScreenW, ZHScreenH - 50 - 64)];
        _drawView.delegate = self;
        
    }
    return _drawView;
}
@end
