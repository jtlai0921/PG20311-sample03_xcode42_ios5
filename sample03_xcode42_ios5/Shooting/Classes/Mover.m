//
//  Mover.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Mover.h"
#import "Texture.h"

// 移動物体クラス
@implementation HPMover

// 座標の取得
-(float)positionX {
	return positionX;
}
-(float)positionY {
	return positionY;
}

// 座標と速度の設定
-(void)setX:(float)x y:(float)y speed:(float)s angle:(float)a {
	positionX=x;
	positionY=y;
	speed=s;
	angle=a;
	rotation=rotationRate=0;
}

// 移動
-(BOOL)move {
	
	// 座標に速度を加算
	float r=(float)M_PI*2*angle;
	positionX+=cosf(r)*speed;
	positionY+=sinf(r)*speed;
	
	// 回転角度を更新
	rotation+=rotationRate;
	
	// 移動可能範囲内ならばYES、移動可能範囲外ならばNOを返す
	return 
		-movableWidth<positionX+drawSize && positionX-drawSize<movableWidth &&
		-movableHeight<positionY+drawSize && positionY-drawSize<movableHeight;
}

// 描画
-(void)draw {
	[texture drawWithX:positionX y:positionY 
		width:drawSize height:drawSize 
		red:1.0f green:1.0f blue:1.0f alpha:1.0f rotation:rotation];
}

// 他の移動物体との当たり判定処理
-(BOOL)doesHitMover:(HPMover*)m {
	
	// 座標の差分
	float dx=positionX-m->positionX, dy=positionY-m->positionY;
	
	// 当たり判定の半径の和
	float h=hitSize+m->hitSize;
	
	// 中心間の距離が当たり判定の半径の和よりも小さければ、
	// 接触したとしてYESを返す
	return dx*dx+dy*dy<h*h;
	
	// 平方根を求めるsqrtfを使うこともできるが、使わない方がおそらく高速
	// return sqrtf(dx*dx+dy*dy)<h;
}

// オブジェクトプールにある全ての移動物体を移動（クラスメソッド）
+(void)moveObjectPool:op {
	for (NSInteger i=[op objectCount]-1; i>=0; i--) {
		if (![(HPMover*)[op objectAtIndex:i] move]) {
			[op removeObjectAtIndex:i];
		}
	}
}

// オブジェクトプールにある全ての移動物体を描画（クラスメソッド）
+(void)drawObjectPool:op {
	for (NSInteger i=[op objectCount]-1; i>=0; i--) {
		[(HPMover*)[op objectAtIndex:i] draw];
	}	
}

// オブジェクトプールにある全ての移動物体を削除（クラスメソッド）
+(void)clearObjectPool:op {
	for (NSInteger i=[op objectCount]-1; i>=0; i--) {
		[op removeObjectAtIndex:i];
	}
}

@end

