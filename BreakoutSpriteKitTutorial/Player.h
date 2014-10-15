//
//  Player.h
//  Soccer
//
//  Created by Finguitar on 10/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Player :NSObject{
}
- (id) initWithPostion :(float)positionX positionY:(float)positionY;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) float positionX;
@property (nonatomic, assign) float positionY;
@property (nonatomic, assign) BOOL receivedResponse;
- (int)count;

@end
