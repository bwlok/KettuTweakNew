#import "Logger.h"

@implementation Logger

+ (void)logWithFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    NSString *logLine = [NSString stringWithFormat:@"%@ %@\n", timestamp, message];

    NSLog(@"%@", logLine);

    [self writeToLogFile:logLine];
}

+ (void)writeToLogFile:(NSString *)logLine {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:LOG_FILE];
    if (!handle) {
        [logLine writeToFile:LOG_FILE atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else {
        [handle seekToEndOfFile];
        [handle writeData:[logLine dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    }

    [self trimLogFile:LOG_FILE toMaxLines:500];
}

+ (void)trimLogFile:(NSString *)filePath toMaxLines:(NSUInteger)maxLines {
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (!content) return;

    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSMutableArray *nonEmptyLines = [NSMutableArray array];
    for (NSString *line in lines) {
        if (line.length > 0) [nonEmptyLines addObject:line];
    }

    if (nonEmptyLines.count <= maxLines) return;

    NSRange range = NSMakeRange(nonEmptyLines.count - maxLines, maxLines);
    NSArray *lastLines = [nonEmptyLines subarrayWithRange:range];
    NSString *trimmed = [[lastLines componentsJoinedByString:@"\n"] stringByAppendingString:@"\n"];

    [trimmed writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
