//
//  MyShip.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "MyShip.h"
#import "Weapon.h"

// 自機クラス
@implementation HPMyShip

// 初期化
-(id)init {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		angle=0;
		speed=0.03f;
		drawSize=0.15f;
	}
	return self;
}

// 破壊
-(void)destroy {
	if (!destroyed) {
		
		// 破壊状態とタイマーの設定
		destroyed=YES;
		destroyTime=0;
		
		// 当たり判定をなくす
		hitSize=-100;
		
		// ランクを下げる
		rank=MAX(rank/2, 1);
		
		// 効果音の再生
		[hitPlayer play];
	}
}

// 描画
-(void)draw {
	
	// 破壊時
	if (destroyed) {
		
		// 自機を次第に消す
		if (destroyTime<=60) {
			float t=MIN(destroyTime/60.0f, 1);
			[myShipDestroyedTexture drawWithX:positionX y:positionY 
				width:drawSize*(1+t) height:drawSize*(1+t) 
				red:1.0f green:1.0f blue:1.0f alpha:1-t rotation:0.0f];
		} else 
		
		// 自機を次第に出現させる（復活時）	
		if (destroyTime>=120) {
			float t=MIN((destroyTime-120)/60.0f, 1);
			[texture drawWithX:positionX y:positionY 
				width:drawSize height:drawSize 
				red:1.0f green:1.0f blue:1.0f alpha:t rotation:0.0f];
		}
	} else 
	
	// 通常時
	{
		[super draw];
	}
}

// 移動
-(BOOL)move {
	
	// 破壊時
	if (destroyed) {
		
		// タイマーの更新
		destroyTime++;
		
		// 1秒後に自機を消去する（自機を復活させない場合の処理）
		if (destroyTime==60) {
			return NO;
		}
		
		// 3秒後に自機を復活させる（自機を復活させる場合の処理）
		/*
		if (destroyTime==180) {
			destroyed=NO;
			hitSize=0.05f;
		}
		*/
		
		// 2秒後までは自機を操作させない
		if (destroyTime<120) {
			return YES;
		}
	}
	
	// アニメーション
	texture=myShipTexture[animationTime/10];
	animationTime=(animationTime+1)%20;
	
	// 武器
	if (weaponTime==0) {
		[HPWeapon shootWeaponWithX:positionX y:positionY+0.15f 
			speed:0.05f angle:0.25f];
	}
	weaponTime=(weaponTime+1)%5;
	
	// タッチ＆スライド
	if (controlType==0) {
		
		// タッチを開始した位置からの相対的なスライド量に応じて自機を動かす場合
		if (!previousTouched && touched) {
			beganX=positionX;
			beganY=positionY;
			beganTouchX=touchX;
			beganTouchY=touchY;
		}
		float tx=beganX+touchX-beganTouchX, ty=beganY+touchY-beganTouchY;
		float vx=tx-positionX, vy=ty-positionY, l=sqrtf(vx*vx+vy*vy);
		if (l>speed) {
			positionX+=vx/l*speed;
			positionY+=vy/l*speed;
		} else {
			positionX=tx;
			positionY=ty;
		}

		// タッチした位置に自機を直接移動する場合
		/*
			positionX=touchX;
			positionY=touchY;
		*/
		
		// タッチした位置に自機を次第に移動する場合
		/*
			float vx=touchX-positionX, vy=touchY-positionY, l=sqrtf(vx*vx+vy*vy);
			if (l>speed) {
				positionX+=vx/l*speed;
				positionY+=vy/l*speed;
			} else {
				positionX=touchX;
				positionY=touchY;
			}
		*/
	}
	
	// 加速度センサー
	if (controlType==1) {
		
		// iOSデバイスを適度に傾ければ最大の速度が出るように調整する場合
		float vx=accelerationX, vy=accelerationY, l=sqrtf(vx*vx+vy*vy);
		float s=MIN(MAX((l-minAcceleration)/(maxAcceleration-minAcceleration), 0), 1)*speed;
		if (l>0) {
			positionX+=vx/l*s;
			positionY+=vy/l*s;
		}
		
		// 加速度から単純に速度を計算する場合
		/*
			positionX+=accelerationX*speed;
			positionY+=accelerationY*speed;
		*/
	}

	// 仮想パッド
	if (controlType==2) {
		
		// 仮想パッドの中心からの距離に応じて、自機の速度の大きさを調整する場合
		if (touched) {
			float vx=touchX-padX, vy=touchY-padY, l=sqrtf(vx*vx+vy*vy);
			if (l<=padSize) {
				float s=MIN(MAX((l-padMargin)/(padSize-padMargin*2), 0), 1)*speed;
				positionX+=vx/l*s;
				positionY+=vy/l*s;
			}
		}

		// 速度の大きさは一定で、仮想パッドをタッチした方向に自機を移動する場合
		/*
		if (touched) {
			float vx=touchX-padX, vy=touchY-padY, l=sqrtf(vx*vx+vy*vy);
			if (l<=padSize) {
				positionX+=vx/l*speed;
				positionY+=vy/l*speed;
			}
		}
		*/
	}
	
	// 自機の座標を更新
	float sx=screenWidth-drawSize, sy=screenHeight-drawSize;
	positionX=MIN(MAX(positionX, -sx), sx);
	positionY=MIN(MAX(positionY, -sy), sy);	
	
	return YES;
}

// リセット
// 自機の出現時に各種の変数を初期化
-(void)reset {
	
	// 当たり判定
	hitSize=0.02f;

	// 座標、移動開始座標、タッチ開始座標、加速度
	positionX=beganX=0;
	positionY=beganY=-1;
	beganTouchX=touchX;
	beganTouchY=touchY;
	accelerationX=accelerationY=0;	

	// テクスチャ、破壊状態、アニメーションのタイマー、武器のタイマー
	texture=myShipTexture[0];
	destroyed=NO;
	animationTime=0;
	weaponTime=0;
}

// 自機の出現（クラスメソッド）
+(void)launchMyShip {
	myShip=[myShipPool addObject];
	[myShip reset];
}

@end

