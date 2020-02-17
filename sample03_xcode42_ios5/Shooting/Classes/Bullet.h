//
//  Bullet.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// 弾クラス
@interface HPBullet : HPMover {}

// 初期化
-(id)init;

// 移動
-(BOOL)move;

// 方向弾の発射（クラスメソッド）
+(void)shootDirectionalBulletWithX:(float)x y:(float)y speed:(float)s angle:(float)a;

// 狙い弾の発射（クラスメソッド）
+(void)shootAimingBulletWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty;

// 方向n-way弾の発射（クラスメソッド）
+(void)shootDirectionalNWayBulletsWithX:(float)x y:(float)y speed:(float)s angle:(float)a angleRange:(float)ar count:(NSUInteger)c;

// 狙いn-way弾の発射（クラスメソッド）
+(void)shootAimingNWayBulletsWithX:(float)x y:(float)y speed:(float)s targetX:(float)tx targetY:(float)ty angleRange:(float)ar count:(NSUInteger)c;

@end

