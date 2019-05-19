//
//  MFUFileUploadHUD.h
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/9.
//  Copyright © 2019 OlafLi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFUFileUploadHUD : UIView

+ (void)showFileUploadHUD;

+ (void)hiddenFileUploadHUD;

+ (void)updateProcess:(CGFloat)process;

+ (void)updateProcess:(CGFloat)process withTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
