//
//  Enemy.h
//  Shooting
//
//  Copyright 2010 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 敵クラス
@interface HPEnemy : HPMover {
	
	// タイプ、タイマー
	NSInteger type, time;
	
	// ダメージ
	float damage;
	
	// 前回の座標
	float prevPositionX, prevPositionY;
}

// 初期化
-(id)init;

// 移動
-(BOOL)move;

// タイプの設定
-(void)setType:(NSInteger)t;

// 敵の出現（クラスメソッド）
+(void)launchEnemyWithX:(float)x y:(float)y speed:(float)s angle:(float)a type:(NSInteger)t;

@end

