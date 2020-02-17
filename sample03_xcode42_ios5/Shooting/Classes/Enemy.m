//
//  Enemy.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Bullet.h"
#import "Common.h"
#import "Enemy.h"
#import "Number.h"
#import "Weapon.h"

// 敵クラス
@implementation HPEnemy

// 初期化
-(id)init {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		drawSize=0.25f;
		hitSize=0.2f;
	}
	return self;
}

// 移動
-(BOOL)move {
	
	// 1秒ごとに弾を発射する
	if (time==60) {
		
		// 敵タイプ0は方向n-way弾を発射
		if (type==0) {
			[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
				speed:0.02f angle:0.75f angleRange:0.9f count:10];
		} else 
		
		// 敵タイプ1は狙いn-way弾を発射
		{
			[HPBullet shootAimingNWayBulletsWithX:positionX y:positionY 
				speed:0.02f targetX:[myShip positionX] targetY:[myShip positionY] angleRange:0.1f count:5];
		}
	}
	time=(time+1)%240;
	
	// 武器との当たり判定処理
	for (NSInteger i=[weaponPool objectCount]-1; i>=0; i--) {
		HPWeapon* w=(HPWeapon*)[weaponPool objectAtIndex:i];
		
		// 武器に接触したときの処理
		if ([w doesHitMover:self]) {
			
			// ダメージの加算
			damage=MIN(damage+[w attack], 1.0f);
			
			// スコアの加算と表示
			NSInteger v=(NSInteger)([w attack]*[w attack]*10000*rank);
			[HPNumber launchNumberWithX:positionX+0.08f y:positionY speed:0.01f angle:0.25f value:v drawSize:0.04f timeLimit:30];
			[score addValue:v];
			
			// 武器の消去
			[weaponPool removeObjectAtIndex:i];
		}
	}
	
	// 描画サイズと当たり判定サイズの計算（ダメージに応じて変化）
	drawSize=0.25f*(1.0f+damage);
	hitSize=0.2f*(1.0f+damage);
	
	// 移動可能範囲内から移動可能範囲外に出たら、スコアを加算する
	if (
		-screenWidth<prevPositionX && prevPositionX<screenWidth &&
		-screenHeight<prevPositionY && prevPositionY<screenHeight &&
		(positionX<=-screenWidth || screenWidth<=positionX ||
		 positionY<=-screenHeight || screenHeight<=positionY)
	) {
		// スコアの加算と表示
		NSInteger v=(NSInteger)(damage*damage*10000*rank);
		[HPNumber launchNumberWithX:positionX+0.35f y:positionY speed:0.02f angle:angle+0.5f value:v drawSize:0.07f timeLimit:60];
		[score addValue:v];
		
		// 効果音の再生
		[enemyPlayer play];
	}
	
	// 現在の座標を前回の座標として記録
	prevPositionX=positionX;
	prevPositionY=positionY;
	
	// 自機との当たり判定処理（接触したら自機を破壊する）
	if ([myShip doesHitMover:self]) {
		[myShip destroy];
	}
	
	return [super move];
}

// 描画
-(void)draw {
	[texture drawWithX:positionX y:positionY 
		width:drawSize height:drawSize
		red:1.0f-damage*0.4f 
		green:1.0f-damage*0.7f
		blue:1.0f-damage*0.9f
	 	alpha:1.0f
		rotation:rotation];
}

// タイプの設定
-(void)setType:(NSInteger)t {
	
	// タイプ、テクスチャ
	type=t;
	texture=enemyTexture[t];
	
	// 回転角度
	rotation=0;
	rotationRate=(t*2-1)*0.01f;
	
	// ダメージ
	damage=0;
	
	// 座標
	prevPositionX=positionX;
	prevPositionY=positionY;
	
	// タイマー
	time=0;
}

// 敵の出現（クラスメソッド）
+(void)launchEnemyWithX:(float)x y:(float)y speed:(float)s angle:(float)a type:(NSInteger)t {
	HPEnemy* e=[enemyPool addObject];
	[e setX:x y:y speed:s angle:a];
	[e setType:t];
}

@end
