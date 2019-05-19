//
//  MFUFileUploader.h
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/9.
//  Copyright © 2019 OlafLi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MFUFileObject;
@class MFUFileResponseObject;

typedef void(^MFUFileUploadCompletionHandler) (NSArray<MFUFileResponseObject *> *fileObjects, NSError *error);

@interface MFUFileUploader : NSObject

+ (void)uploadFileObjects:(NSArray<MFUFileObject *> *)fileObjects
				 toURL:(NSString *)url
				   withParams:(NSDictionary*) params
				 progress:(nullable void (^) (NSProgress *_Nonnull))uploadProgress
		completionHandler:(MFUFileUploadCompletionHandler)completion;

+ (void)uploadFileObjects:(NSArray<MFUFileObject *> *)fileObjects
					toURL:(NSString *)url
			   withParams:(NSDictionary*) params
		completionHandler:(MFUFileUploadCompletionHandler)completion;
@end

NS_ASSUME_NONNULL_END
