#import <Foundation/Foundation.h>

#define LOG_PREFIX         @"[Kettu]"
#define BunnyLog(fmt, ...) [Logger logWithFormat:LOG_PREFIX @" " fmt, ##__VA_ARGS__]
#define LOG_FILE [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @"Documents/pyoncord/kettu.log"]


@interface Logger : NSObject
+ (void)logWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
@end
