//
//  MFUViewController.m
//  TFMultiFileUploader
//
//  Created by olafLi on 05/19/2019.
//  Copyright (c) 2019 olafLi. All rights reserved.
//

#import "MFUViewController.h"
#import <TFMultiFileUploader/TFMultiFileUploader.h>

@interface MFUViewController ()

@end

@implementation MFUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	UIImage * uploadImage = [UIImage imageNamed:@"download.jpg"];
	MFUFileObject * object = [MFUFileObject fileObjectWithImage:uploadImage];
	NSString * toUrl = @"http://192.168.0.1:8080/normalUpload";

	[MFUFileUploader uploadFileObjects:@[object] toURL:toUrl params:nil completionHandler:^(NSArray<MFUFileResponseObject *> * _Nonnull fileObjects, NSError * _Nonnull error) {
		MFUFileResponseObject * responseObject = fileObjects.firstObject;
		NSDictionary * responseDictionary = responseObject.responseObject;
		/* 服务器返回的数据 */
		NSLog(@"%@",responseDictionary);
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
