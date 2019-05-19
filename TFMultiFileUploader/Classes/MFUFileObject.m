//
//  MFUFileObject.m
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/19.
//  Copyright © 2019 OlafLi. All rights reserved.
//

#import "MFUFileObject.h"

@interface MFUFileObject ()
@property (nonatomic, strong) NSProgress *uploadProgress;
@end

@implementation MFUFileObject

+ (instancetype)fileObjectWithData:(NSData *)data {
	MFUFileObject *object = [[MFUFileObject alloc] init];
	object.fileData = data;
	object.fileObjectType = FileObjectTypeFile;
	object.uploadProgress = [NSProgress progressWithTotalUnitCount:data.length];
	return object;
}

+ (instancetype)fileObjectWithImage:(UIImage *)image {
	MFUFileObject *object = [self fileObjectWithData:UIImageJPEGRepresentation (image, 0.8)];
	object.fileObjectType = FileObjectTypeImage;
	return object;
}

+ (instancetype)fileObjectWithFilePath:(NSString *)filePath {
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	if ([filePath containsString:@"mp4"]) {
		return [self fileObjectWithFilePath:filePath withFileObjectType:FileObjectTypeVideo];
	} else {
		MFUFileObject *object = [self fileObjectWithData:data];
		object.fileObjectType = FileObjectTypeFile;
		return object;
	}
}

+ (instancetype)fileObjectWithFilePath:(NSString *)filePath withFileObjectType:(FileObjectType)fileObjectType {
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	MFUFileObject *object = [self fileObjectWithData:data];
	object.fileObjectType = fileObjectType;
	if (data == nil) {
		object.fileObjectType = FileObjectTypeUnknow;
	}
	return object;
}

- (NSString *)fileName {
	if (self.fileObjectType == FileObjectTypeImage) {
		return [NSString stringWithFormat:@"%@.jpg", [self nowDateString]];
	}
	if (self.fileObjectType == FileObjectTypeVideo) {
		return [NSString stringWithFormat:@"%@.mp4", [self nowDateString]];
	}
	return [NSString stringWithFormat:@"%@.data", [self nowDateString]];
}

-(NSString *) nowDateString {
	return [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
}

@end


