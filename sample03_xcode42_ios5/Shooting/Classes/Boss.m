//
//  Boss.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Boss.h"
#import "Bullet.h"
#import "Common.h"
#import "Number.h"
#import "Weapon.h"

// ボスクラス
@implementation HPBoss

// リセット
-(void)reset {
	
	// 座標
	positionX=0;
	positionY=0.5f;
	
	// 角度
	rotationX=rotationY=rotationZ=0;
	
	// 描画サイズ、当たり判定サイズ、ダメージ
	drawSize=hitSize=damage=0;
	
	// 状態、タイマー、持続時間
	state=1;
	time=0;
	duration=120;
}

// 移動
-(BOOL)move {
	
	// 角度などの変化に使う値をタイマーと持続時間から計算
	float t=(float)time/duration;
	
	// 状態に応じて分岐
	switch (state) {
			
		// 状態１（出現）
		case 1:
			
			// Z軸周りを回転し、次第に大きく濃くなりながら出現
			drawSize=0.5f*t;
			rotationZ=2.0f*t;
			alpha=t;
			
			// 一定時間後に状態２へ移行
			time++;
			if (time==duration) {
				drawSize=0.5f;
				hitSize=0.4f;
				rotationZ=0;
				alpha=1;
				state=2;
				time=0;
				duration=240/rank;
			}
			break;
			
		// 状態２（渦巻き弾＋Y軸回転）
		case 2:
			
			// 約0.16秒ごとに方向n-way弾を発射
			if (time%10==0) {
				[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
					speed:0.02f angle:t*0.5f angleRange:0.8f count:5];
			}
			
			// 0.5秒ごとに狙い弾を発射
			if (time%30==0) {
				[HPBullet shootAimingBulletWithX:positionX y:positionY 
					speed:0.03f targetX:[myShip positionX] targetY:[myShip positionY]];
			}
			
			// Y軸周りを回転
			rotationY=t;
			
			// 一定時間後に状態３へ移行
			time++;
			if (time==duration) {
				rotationY=0;
				state=3;
				time=0;
				duration=240/rank;
			}
			break;
		
		// 状態３（拡散n-way弾＋X軸回転）
		case 3:
			
			// 0.5秒ごとに拡散n-way弾を発射
			if (time%30==0) {
				for (NSInteger i=0; i<3; i++) {
					for (NSInteger j=0; j<3; j++) {
						[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
							speed:0.02f+i*0.005f angle:t*2+j*0.02f angleRange:0.8f count:5];
					}
				}
			}
			
			// X軸周りを回転
			rotationX=t;
			
			// 一定時間後に状態４へ移行
			time++;
			if (time==duration) {
				rotationX=0;
				state=4;
				time=0;
				duration=240/rank;
			}
			break;

		// 状態４（渦巻き弾＋Y軸回転）
		case 4:
			
			// 約0.16秒ごとに方向n-way弾を発射
			if (time%10==0) {
				[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
					speed:0.02f angle:-t*0.5f angleRange:0.8f count:5];
			}
			
			// 0.5秒ごとに狙い弾を発射
			if (time%30==0) {
				[HPBullet shootAimingBulletWithX:positionX y:positionY 
					speed:0.03f targetX:[myShip positionX] targetY:[myShip positionY]];
			}
			
			// Y軸周りを回転
			rotationY=-t;
			
			// 一定時間後に状態５へ移行
			time++;
			if (time==duration) {
				rotationY=0;
				state=5;
				time=0;
				duration=240/rank;
			}
			break;

		// 状態５（波状n-way弾＋X軸回転）
		case 5:
			
			// 約0.08秒ごとに波状n-way弾を発射
			if (time%5==0) {
				[HPBullet shootDirectionalNWayBulletsWithX:positionX y:positionY 
					speed:0.02f angle:sinf(t*M_PI*3)*0.1f angleRange:0.8f count:5];
			}
			
			// X軸周りを回転
			rotationX=-t;
			
			// 一定時間後に状態２へ移行
			time++;
			if (time==duration) {
				rotationX=0;
				state=2;
				time=0;
				duration=240/rank;
			}
			break;

		// 状態６（破壊）
		case 6:
			
			// Z軸周りを回転し、次第に小さく薄くなりながら消失
			drawSize=1-t;
			rotationZ=4.0f*(1-t);
			alpha=1-t;
			
			// 一定時間後に状態-1（消失）へ移行
			time++;
			if (time==duration) {
				state=-1;
			}
			break;
	}
	
	// 当たり判定処理
	if (hitSize>0) {
		
		// 武器との当たり判定処理
		for (NSInteger i=[weaponPool objectCount]-1; i>=0; i--) {
			HPWeapon* w=(HPWeapon*)[weaponPool objectAtIndex:i];
			
			// 武器に接触したとき
			if ([w doesHitMover:self]) {
				
				// ダメージの加算
				damage+=[w attack]*0.1f;
				
				// スコアの計算と表示
				NSInteger v=(NSInteger)([w attack]*[w attack]*10000*rank);
				[HPNumber launchNumberWithX:[w positionX]+0.08f y:[w positionY] 
					speed:0.01f angle:0.25f value:v drawSize:0.04f timeLimit:30];
				[score addValue:v];
				
				// 武器の削除
				[weaponPool removeObjectAtIndex:i];
			}
		}
		
		// 描画サイズと当たり判定サイズをダメージに応じて更新
		drawSize=0.5f*(1.0f+damage);
		hitSize=0.4f*(1.0f+damage);
		
		// 破壊されたとき
		if (damage>=1) {
			
			// スコアの計算と表示
			NSInteger v=(NSInteger)(100000*rank*rank);
			[HPNumber launchNumberWithX:positionX+0.7f y:positionY 
				speed:0.005f angle:0.25f value:v drawSize:0.14f timeLimit:120];
			[score addValue:v];
			
			// 効果音の再生
			[bossPlayer play];
			
			// 状態６（破壊）に移行
			hitSize=0;
			state=6;
			time=0;
			duration=120;
		}
	}
	
	// 状態-1（消失）の場合はNO、それ以外はYESを返す
	return state!=-1;
}

// 描画
-(void)draw {
	[bossModel drawWithX:positionX y:positionY z:0 
		scale:drawSize
		red:1.0f-damage*0.4f 
		green:1.0f-damage*0.7f
		blue:1.0f-damage*0.9f
		alpha:alpha
		rotationX:rotationX rotationY:rotationY rotationZ:rotationZ];
}

// ボスの出現（クラスメソッド）
+(void)launchBoss {
	[[bossPool addObject] reset];
}

@end
