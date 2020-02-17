//
//  Number.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 数値クラス
@interface HPNumber : HPMover {
	
	// 数値、タイマー、制限時間
	NSInteger value, time, timeLimit;
}

// 初期化
-(id)init;

// 破棄
-(void)dealloc;

// 数値の取得
-(NSInteger)value;

// 数値の加算
-(void)addValue:(NSInteger)v;

// 数値、描画サイズ、制限時間の設定
-(void)setValue:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t;

// 移動
-(BOOL)move;

// 描画
-(void)draw;

// 数値の出現（クラスメソッド）
+(void)launchNumberWithX:(float)x y:(float)y speed:(float)s angle:(float)a value:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t;

@end
