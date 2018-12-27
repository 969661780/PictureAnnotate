//
//  MTMarkViewController.m
//  PictureAnnotate
//
//  Created by mt y on 2018/6/25.
//  Copyright © 2018年 mt y. All rights reserved.
//

#import "MTMarkViewController.h"
#import "HBDrawSettingBoard.h"
#import "UIView+WHB.h"
#import "HBDrawingBoard.h"
#import "HBDrawCommon.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
@interface MTMarkViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HBDrawingBoardDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (nonatomic, strong) HBDrawingBoard *drawView;
@property (nonatomic, copy) boardSettingBlock stype;
@end

@implementation MTMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Image annotation";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBtn)];
    self.navigationItem.rightBarButtonItem = rightItem;
     [self.myImageView addSubview:self.drawView];
      [[NSNotificationCenter defaultCenter] postNotificationName:ImageBoardNotification object:nil userInfo:[NSDictionary dictionaryWithObject:self.imageView forKey:@"imageBoardName"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -touch
- (void)rightBtn
{
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
- (IBAction)markBtn:(UIButton *)sender {
    
    self.drawView.shapType = ((UIButton *)sender).tag;
    
    [self.drawView showSettingBoard];
}
- (HBDrawingBoard *)drawView
{
    if (!_drawView) {
        _drawView = [[HBDrawingBoard alloc] initWithFrame:CGRectMake(0, 0, ZHScreenW, ZHScreenH-50)];
        _drawView.delegate = self;
        
    }
    return _drawView;
}
@end
