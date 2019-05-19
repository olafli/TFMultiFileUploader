//
//  MFUFileUploadHUD.m
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/9.
//  Copyright © 2019 OlafLi. All rights reserved.
//

#import "MFUFileUploadHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MFUFileUploadHUD ()

@property (strong, nonatomic) MBProgressHUD *fileUploadHUD;

+ (instancetype)sharedHUD;

- (void)showFileUploadHUD;

- (void)hiddenFileUploadHUD;

- (void)updateFileUploadHUDProcess:(CGFloat)process;

- (void)updateFileUploadHUDProcess:(CGFloat)process WithTitle:(NSString *)title;
@end

@implementation MFUFileUploadHUD

+ (instancetype)sharedHUD {
	static dispatch_once_t onceToken;
	static MFUFileUploadHUD *uploadHUD;
	dispatch_once (&onceToken, ^{
	  uploadHUD = [[MFUFileUploadHUD alloc] init];
	});
	return uploadHUD;
}

+ (void)showFileUploadHUD {
	[[MFUFileUploadHUD sharedHUD] showFileUploadHUD];
	[[MFUFileUploadHUD sharedHUD] updateFileUploadHUDProcess:0];
}

+ (void)hiddenFileUploadHUD {
	[[MFUFileUploadHUD sharedHUD] hiddenFileUploadHUD];
}

+ (void)updateProcess:(CGFloat)process {
	[[MFUFileUploadHUD sharedHUD] updateFileUploadHUDProcess:process];
}

+ (void)updateProcess:(CGFloat)process withTitle:(NSString *)title {
	[[MFUFileUploadHUD sharedHUD] updateFileUploadHUDProcess:process WithTitle:title];
}

- (void)showFileUploadHUD {
	[self resignFirstResponder];
	UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
	if (self.fileUploadHUD == nil) {
		_fileUploadHUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
		_fileUploadHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
		_fileUploadHUD.label.text = @"正在上传文件";
		_fileUploadHUD.removeFromSuperViewOnHide = YES;
	} else {
		_fileUploadHUD.progress = 0;
		[keyWindow addSubview:_fileUploadHUD];
		[_fileUploadHUD showAnimated:YES];
	}
}

- (void)hiddenFileUploadHUD {
	[_fileUploadHUD hideAnimated:YES];
}

- (void)updateFileUploadHUDProcess:(CGFloat)process {
	self->_fileUploadHUD.progress = process;
}

- (void)updateFileUploadHUDProcess:(CGFloat)process WithTitle:(NSString *)title {
	_fileUploadHUD.progress = process;
	_fileUploadHUD.label.text = title;
}

@end
