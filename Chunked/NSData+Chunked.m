//
//  NSData+Chunked.m
//  Chunked
//
//  Created by lpc on 2018/7/2.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import "NSData+Chunked.h"

#pragma mark - NSData+Http
@implementation NSData (Http)

- (NSInteger)getReadDataHeadLength
{
    NSData *data = [self copy];
    NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *seperate = @"\r\n\r\n";
    NSInteger seperateLen = [seperate length];
    NSArray *components = [resString componentsSeparatedByString:seperate];
    NSString *firstString = [components firstObject];
    NSInteger headLength = seperateLen + [firstString length];

    return headLength;
}

- (NSInteger)getReadDataBodyAndHeadlength:(NSInteger *)headLen
{
    NSData *data = [self copy];
    NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *seperate = @"\r\n\r\n";
    NSInteger seperateLen = [seperate length];
    NSArray *components = [resString componentsSeparatedByString:seperate];
    NSString *firstString = [components firstObject];
    NSInteger headLength = seperateLen + [firstString length];
    (*headLen) = headLength;

    NSArray *headers = [firstString componentsSeparatedByString:@"\n"];
    NSInteger bodyLength = 0;
    for (NSString *head in headers)
    {
        if ([head rangeOfString:@"Content-Length:"].location != NSNotFound)
        {
            NSString * bodyLenStr = [head stringByReplacingOccurrencesOfString:@"Content-Length: " withString:@""];
            bodyLength = [bodyLenStr integerValue];
            break ;
        }
    }
    return bodyLength;
}

@end


#pragma mark - NSData+Chunked
@implementation NSData (Chunked)

- (BOOL)isChunkedData
{
    NSData *data = [self copy];
    NSString *newMessage = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    if([newMessage rangeOfString:@"Transfer-Encoding: chunked"].location != NSNotFound){
        return YES;
    }
    return NO;
}

- (BOOL)isChunkedDataReadEnd
{
    NSData *data = [self copy];
    NSString *readDataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *endString = @"\r\n0\r\n\r\n";
    if ([readDataString hasSuffix:endString]) {
        return YES;
    }
    return NO;
}

- (NSString *)getChunkedBodyStringWithIsFirst:(BOOL)isFirst
{
    NSData *data = [self copy];
    NSString *readDataString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    NSString *chunkedStr = [readDataString copy];
    if (isFirst)
    {
        NSString *seperate = @"\r\n\r\n";
        NSArray *components = [readDataString componentsSeparatedByString:seperate];
        NSString *headStr = components[0];
        NSString *replaceHeadString = [headStr stringByAppendingString:@"\r\n"];
        chunkedStr = [readDataString stringByReplacingOccurrencesOfString:replaceHeadString withString:@""];
    }
    //获取body长度
    NSArray *bodyComponents = [chunkedStr componentsSeparatedByString:@"\r\n"];

    NSString *lenStr = bodyComponents[1]; //取出表示长度的16进制
    NSInteger length = strtoul([lenStr UTF8String], 0, 16); //16->10进制

    NSString *startString = [NSString stringWithFormat:@"\r\n%@\r\n",lenStr];
    NSRange startRange = [chunkedStr rangeOfString:startString];
    NSRange bodyRange = NSMakeRange(startRange.location + startRange.length, length);

    NSString *targetBodyString = [chunkedStr substringWithRange:bodyRange];

    return targetBodyString;
}

@end

