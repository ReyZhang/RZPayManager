//
//  NSString+Extension.m
//  RZPayManager
//
//  Created by rey zhang on 2021/1/23.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)isNull {
    if(self == nil || [self isKindOfClass:[NSNull class]] || [self isEmpty]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmpty {
    return [[self trimWhitespace] isEqualToString:@""];
}

- (NSString *)trimWhitespace {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSData *)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)jsonValueDecoded {
    NSData *data = [self dataValue];
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}
@end
