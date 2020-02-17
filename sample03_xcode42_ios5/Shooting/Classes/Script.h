//
//  Script.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import <Foundation/Foundation.h>

// スクリプトコマンドクラス
@interface HPScriptCommand : NSObject {
	
	// タイプ、待機時間
	NSInteger type, wait;
	
	// 座標、速度（大きさと角度）
	float positionX, positionY, speed, angle;
}

// 初期化
-(id)initWithString:(NSString*)s;

// 実行
-(NSInteger)run;

@end

//-------------------------------------------------------------------------

// スクリプトクラス
@interface HPScript : NSObject {
	
	// コマンドの配列
	NSMutableArray* command;
	
	// 実行中の位置、待機時間
	NSInteger index, wait;
}

// 初期化
-(id)initWithFile:(NSString*)file;

// 破棄
-(void)dealloc;

// リセット
-(void)reset;

// 移動（実行）
-(BOOL)move;

@end

