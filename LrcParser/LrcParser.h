//
//  LrcParser.h
//  Pods
//
//  Created by 张昌伟 on 16/2/22.
//
//

#import <Foundation/Foundation.h>

@interface LrcParser : NSObject

//时间
@property (nonatomic,strong) NSMutableArray *timerArray;
//歌词
@property (nonatomic,strong) NSMutableArray *wordArray;


//解析歌词
-(void) parseLrc;
//解析歌词
-(void) parseLrc:(NSString*)lrc;
@end
