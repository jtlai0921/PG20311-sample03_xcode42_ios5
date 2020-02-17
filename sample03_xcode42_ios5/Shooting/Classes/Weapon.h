//
//  Weapon.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 武器クラス
@interface HPWeapon : HPMover {
	
	// 攻撃力
	float attack;
}

// 初期化
-(id)init;

// 移動
-(BOOL)move;

// サイズの設定
-(void)setSizes;

// 攻撃力の取得
-(float)attack;

// 武器の発射（クラスメソッド）
+(void)shootWeaponWithX:(float)x y:(float)y speed:(float)s angle:(float)a;

@end
