//
//  MTHomeViewController.m
//  PictureAnnotate
//
//  Created by mt y on 2018/6/25.
//  Copyright © 2018年 mt y. All rights reserved.
//

#import "MTHomeViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MTMarkViewController.h"
#import "MTHandPaintedViewController.h"
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import <SVProgressHUD.h>
#import "STConfig.h"

@interface MTHomeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, STPhotoKitDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selecedImageView;
@property (nonatomic, strong)UIImage *myImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstaint;

@end

@implementation MTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Image annotation";
    NSLog(@"%f",ZHScreenH);
    self.navigationController.automaticallyAdjustsScrollViewInsets=YES;
  
}
#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
    self.myImage = resultImage;
    self.selecedImageView.image = resultImage;

}
#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        [photoVC setSizeClip:CGSizeMake(self.selecedImageView.width, self.selecedImageView.height*2)];
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"Taking pictures" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            [SVProgressHUD showInfoWithStatus:@"Please turn on camera permissions"];
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Get from album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
            [SVProgressHUD dismissWithDelay:1.5];
        }else
        {
            [SVProgressHUD showInfoWithStatus:@"Please open album permissions"];
            [SVProgressHUD dismissWithDelay:1.5];
        }
            }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -touchs
- (IBAction)enterPhotoBtn:(UIButton *)sender {
    [self editImageSelected];
}
- (IBAction)HandPaintedBtn:(UIButton *)sender {
    if (!self.myImage) {
        [SVProgressHUD showInfoWithStatus:@"Please select picture first"];
        [SVProgressHUD dismissWithDelay:1.50f];
    }else{
        MTHandPaintedViewController *handCon = [MTHandPaintedViewController new];
        handCon.imageView = self.myImage;
        [self.navigationController pushViewController:handCon animated:YES];
    }
}

- (IBAction)markBtn:(UIButton *)sender {
    if (!self.myImage) {
        [SVProgressHUD showInfoWithStatus:@"Please select picture first"];
        [SVProgressHUD dismissWithDelay:1.50f];
    }else{
        MTMarkViewController *handCon = [MTMarkViewController new];
        handCon.imageView = self.myImage;
        [self.navigationController pushViewController:handCon animated:YES];
    }
}

@end
