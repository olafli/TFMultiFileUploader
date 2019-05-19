//
//  MFUFileUploader.m
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/9.
//  Copyright © 2019 OlafLi. All rights reserved.
//

#import "MFUFileUploader.h"
#import "MFUFileUploadHUD.h"
#import "MFUFileObject.h"
#import "MFUFileResponseObject.h"

#import <AFNetworking/AFNetworking.h>

@implementation MFUFileUploader

+ (NSProgress *)processWithUploadTasks:(NSMutableArray<NSURLSessionTask *> *)fileUploadTasks {
	int64_t totalUnitCount = 0;
	int64_t completedUnitCount = 0;
	for (NSURLSessionTask *task in fileUploadTasks) {
		totalUnitCount += task.countOfBytesExpectedToSend;
		completedUnitCount += task.countOfBytesSent;
	}
	NSProgress *totalProcess = [NSProgress progressWithTotalUnitCount:totalUnitCount];
	totalProcess.completedUnitCount = completedUnitCount;
	totalProcess.localizedDescription =
	[NSString stringWithFormat:@"完成 %.2f%% ", completedUnitCount * 100.0 / totalUnitCount];
	return totalProcess;
}

+(void)uploadFileObjects:(NSArray<MFUFileObject *> *)fileObjects
				   toURL:(NSString *)url
				  params:(NSDictionary *)params
	   completionHandler:(MFUFileUploadCompletionHandler)completion {

	NSMutableArray * objects = [NSMutableArray new];
	for (MFUFileObject * object in fileObjects) {
		object.params = params;
		object.toUrl = url;
		[objects addObject:object];
	}
	[self uploadFileObjects:objects completionHandler:completion];
}

+(void)uploadFileObjects:(NSArray<MFUFileObject *> *)fileObjects
				   toURL:(NSString *)url
				  params:(NSDictionary *)params progress:(void (^)(NSProgress * _Nonnull))uploadProgress
	   completionHandler:(MFUFileUploadCompletionHandler)completion {

	NSMutableArray * objects = [NSMutableArray new];
	for (MFUFileObject * object in fileObjects) {
		object.params = params;
		object.toUrl = url;
		[objects addObject:object];
	}
	[self uploadFileObjects:objects progress:uploadProgress completionHandler:completion];
}

+(void)uploadFileObjects:(NSArray<MFUFileObject *> *)fileObjects completionHandler:(MFUFileUploadCompletionHandler)completion {

	dispatch_async (dispatch_get_main_queue (), ^{
		[MFUFileUploadHUD showFileUploadHUD];
	});
	[self uploadFileObjects:fileObjects progress:^(NSProgress * _Nonnull uploadProgress) {
		CGFloat processValue = uploadProgress.completedUnitCount * 1.0 / uploadProgress.totalUnitCount;
		dispatch_async (dispatch_get_main_queue (), ^{
			[MFUFileUploadHUD updateProcess:processValue withTitle:uploadProgress.localizedDescription];
		});
	} completionHandler:^(NSArray<MFUFileResponseObject *> * _Nonnull fileResponseObjects, NSError * _Nonnull error) {
		dispatch_async (dispatch_get_main_queue (), ^{
			[MFUFileUploadHUD hiddenFileUploadHUD];
		});
		completion (fileResponseObjects, error);
	}];
}



+(void)uploadFileObjects:(NSArray<MFUFileObject *> *)fileObjects
				progress:(void (^)(NSProgress * _Nonnull))uploadProgress
	   completionHandler:(MFUFileUploadCompletionHandler)completion {

	dispatch_queue_t queue = dispatch_queue_create ("com.mfu.files.upload.queue", NULL);
	dispatch_group_t group = dispatch_group_create ();

	NSMutableArray<MFUFileResponseObject *> *uploadedFileObjects = [NSMutableArray new];
	NSMutableArray<NSURLSessionTask *> *fileUploadTasks = [NSMutableArray new];

	for (int i = 0; i < fileObjects.count; i++) {
		dispatch_group_enter (group);
		dispatch_group_async (group, queue, ^{
			MFUFileObject *object = fileObjects[i];
				//单个文件上传
			NSURLSessionTask *task = [self uploadFileObject:object
												   progress:^(NSProgress *_Nonnull _uploadProgress) {
													   uploadProgress ([self processWithUploadTasks:fileUploadTasks]);
												   }
										  completionHandler:^(MFUFileResponseObject *fileResponseObject) {
											  [uploadedFileObjects addObject:fileResponseObject];
											  dispatch_group_leave (group);
										  }];
			[fileUploadTasks addObject:task];
		});
	}
	dispatch_group_notify (group, queue, ^{
		NSError *error;
			//收集上传文件的保存信息
		for (MFUFileResponseObject *object in uploadedFileObjects) {
			if (object.error) {
				error = object.error;
				break;
			}
		}
		completion (uploadedFileObjects, error);
	});
}

+ (NSURLSessionTask *)uploadFileObject:(MFUFileObject *)fileObject
							  progress:(nullable void (^) (NSProgress *_Nonnull))uploadProgress
					 completionHandler:(void (^) (MFUFileResponseObject *fileObject))completion {
	NSAssert(fileObject.toUrl != nil && fileObject.toUrl.length > 0 , @"fileObject.toUrl value is invalid");

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	return [manager POST:fileObject.toUrl parameters:fileObject.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		[formData appendPartWithFileData:fileObject.fileData name:@"file" fileName:fileObject.fileName mimeType:@"multipart/form-data"];
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
		MFUFileResponseObject * fileResponseObject = [[MFUFileResponseObject alloc] init];
		fileResponseObject.fileObject = fileObject;
		fileResponseObject.responseObject = responseObject;
		NSLog (@"upload file %@ => %@ successful", fileResponseObject.fileObject.fileName, fileResponseObject.url);
		completion (fileResponseObject);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		MFUFileResponseObject * fileResponseObject = [[MFUFileResponseObject alloc] init];
		fileResponseObject.fileObject = fileObject;
		fileResponseObject.error = error;
		NSLog (@"upload file %@ => %@ failure %@", fileResponseObject.fileObject.fileName, fileResponseObject.url, error.localizedDescription);
		completion (fileResponseObject);
	}];
}
@end
