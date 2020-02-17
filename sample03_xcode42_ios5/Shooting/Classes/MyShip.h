//
//  MyShip.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 自機クラス
@interface HPMyShip : HPMover {
	
	// 移動開始座標、タッチ開始座標
	float beganX, beganY, beganTouchX, beganTouchY;
	
	// 破壊状態（破壊されていたらYES）
	BOOL destroyed;
	
	// タイマー（アニメーション、破壊、武器の発射）
	NSInteger animationTime, destroyTime, weaponTime;
}

// 初期化
-(id)init;

// 移動
-(BOOL)move;

// 描画
-(void)draw;

// 破壊
-(void)destroy;

// リセット
-(void)reset;

// 自機の出現（クラスメソッド）
+(void)launchMyShip;

@end

