//
//  Bullet.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Bullet.h"
#import "Common.h"

// 弾クラス
@implementation HPBullet

// 初期化
-(id)init {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		positionX=positionY=speed=angle=0;
		texture=bulletTexture;		
		drawSize=0.025f;
		hitSize=0.02f;
	}
	return self;
}

// 移動
-(BOOL)move {
	
	// 自機との当たり判定処理
	if ([myShip doesHitMover:self]) {
		[myShip destroy];
		return NO;
	}
	return [super move];
}

// 方向弾の発射（クラスメソッド）
+(void)shootDirectionalBulletWithX:(float)x y:(float)y speed:(float)s angle:(float)a {
	[[bulletPool addObject] setX:x y:y speed:s angle:a];
}

// 狙い弾の発射（クラスメソッド）
+(void)shootAimingBulletWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty {
	[[bulletPool addObject] setX:x y:y speed:s angle:atan2f(ty-y, tx-x)/(float)M_PI/2];
}

// 方向n-way弾の発射（クラスメソッド）
+(void)shootDirectionalNWayBulletsWithX:(float)x y:(float)y speed:(float)s angle:(float)a angleRange:(float)ar count:(NSUInteger)c {
	for (int i=0; i<c; i++) {
		[HPBullet shootDirectionalBulletWithX:x y:y speed:s angle:a-ar/2+ar*i/(c-1)];
	}
}

// 狙いn-way弾の発射（クラスメソッド）
+(void)shootAimingNWayBulletsWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty angleRange:(float)ar count:(NSUInteger)c {
	[HPBullet shootDirectionalNWayBulletsWithX:x y:y speed:s angle:atan2f(ty-y, tx-x)/(float)M_PI/2 angleRange:ar count:c];
}

@end

