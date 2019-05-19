//
//  MFUFileResponseObject.h
//  TFMultiFileUploader
//
//  Created by LiTengFei on 2019/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MFUFileObject;
@interface MFUFileResponseObject : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *responseObject;
@property (nonatomic, strong) MFUFileObject * fileObject;

@end

NS_ASSUME_NONNULL_END
