//
//  main.m
//  Chunked
//
//  Created by lpc on 2018/7/2.
//  Copyright © 2018年 lpc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Chunked.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        NSMutableString *target = [NSMutableString string];

        NSString *chunkedString_1 = @"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nTransfer-Encoding: chunked\r\nConnection:keep-Alive\r\n\r\n25\r\nThis is the data in the first chunk\r\n";
        NSData *chunkedData_1 = [chunkedString_1 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *string_1 = [chunkedData_1 getChunkedBodyStringWithIsFirst:YES];
        [target appendString:string_1];

        NSString *chunkedString_2 = @"\r\n1A\r\nand this is the second one\r\n0\r\n\r\n";
        NSData *chunkedData_2 = [chunkedString_2 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *string_2 = [chunkedData_2 getChunkedBodyStringWithIsFirst:NO];
        [target appendString:string_2];

        NSLog(@"%@",target);
    }
    return 0;
}

/*
 http://wuhua.iteye.com/blog/673841
 NSString *chunkedString = @"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nTransfer-Encoding: chunked\r\nConnection:keep-Alive\r\n\r\n25\r\nThis is the data in the first chunk\r\n\r\n1A\r\nand this is the second one\r\n0\r\n\r\n";

 HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nTransfer-Encoding: chunked\r\nConnection:keep-Alive\r\n

 \r\n25\r\nThis is the data in the first chunk\r\n

 \r\n1A\r\nand this is the second one\r\n0\r\n\r\n

 */
