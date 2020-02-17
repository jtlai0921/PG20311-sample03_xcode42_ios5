//
//  Weapon.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Weapon.h"

// 武器クラス
@implementation HPWeapon

// 初期化
-(id)init {
	self=[super init];
	if (self!=nil) {
		texture=weaponTexture;
	}
	return self;
}

// 移動
-(BOOL)move {
	
	// 描画サイズ、当たり判定サイズ、攻撃力の更新
	drawSize+=0.004f;
	hitSize+=0.004f;
	attack-=0.001f;
	return [super move];
}

// サイズの設定
-(void)setSizes {
	
	// 描画サイズ、当たり判定サイズ、攻撃力の初期化
	drawSize=0.1f;
	hitSize=0.1f;
	attack=0.05f;
}

// 攻撃力の取得
-(float)attack {
	return attack;
}

// 武器の発射（クラスメソッド）
+(void)shootWeaponWithX:(float)x y:(float)y speed:(float)s angle:(float)a {
	HPWeapon* w=[weaponPool addObject];
	[w setX:x y:y speed:s angle:a];
	[w setSizes];
}

@end
