//
//  Boss.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// ボスクラス
@interface HPBoss : HPMover {

	// 状態、タイマー、持続時間
	NSInteger state, time, duration;

	// ダメージ、アルファ値、回転角度（X軸、Y軸、Z軸）
	float damage, alpha, rotationX, rotationY, rotationZ;
}

// リセット
-(void)reset;

// 移動
-(BOOL)move;

// 描画
-(void)draw;

// ボスの出現（クラスメソッド）
+(void)launchBoss;

@end

