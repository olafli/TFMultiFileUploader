//
//  MFUFileObject.h
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/19.
//  Copyright © 2019 OlafLi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FileObjectType) {
	FileObjectTypeImage = 0,
	FileObjectTypeVideo = 1,
	FileObjectTypeFile = 2,
	FileObjectTypeUnknow = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface MFUFileObject : NSObject

@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) FileObjectType fileObjectType;
@property (nonatomic, copy) NSString *toUrl;
@property (nonatomic, copy) NSString *fileName;

+ (instancetype)fileObjectWithData:(NSData *)data;

+ (instancetype)fileObjectWithImage:(UIImage *)image;

+ (instancetype)fileObjectWithFilePath:(NSString *)filePath;

+ (instancetype)fileObjectWithFilePath:(NSString *)filePath withFileObjectType:(FileObjectType)fileObjectType;

@end



NS_ASSUME_NONNULL_END
