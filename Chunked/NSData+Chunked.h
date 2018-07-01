//
//  NSData+Chunked.h
//  Chunked
//
//  Created by lpc on 2018/7/2.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSData+Http
@interface NSData (Http)

///简单获取第一次接收的data的headLength
- (NSInteger)getReadDataHeadLength;

///获取第一次接收的data的headLength,并返回bodyLength
- (NSInteger)getReadDataBodyAndHeadlength:(NSInteger *)headLen;

@end


#pragma mark - NSData+Chunked
@interface NSData (Chunked)

///是否为chunked编码
- (BOOL)isChunkedData;

///chunked编码是否接收完毕
- (BOOL)isChunkedDataReadEnd;

///获取每一次接收到的chunked编码的bodyString,isFirst=是否为第一次接收数据(YES是,NO否)
- (NSString *)getChunkedBodyStringWithIsFirst:(BOOL)isFirst;

@end

