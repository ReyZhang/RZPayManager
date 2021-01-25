//
//  NSString+Extension.h
//  RZPayManager
//
//  Created by rey zhang on 2021/1/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)
- (BOOL)isNull;
- (BOOL)isEmpty;
- (NSData *)dataValue;
- (id)jsonValueDecoded;
@end

NS_ASSUME_NONNULL_END
