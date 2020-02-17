//
//  Mover.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Texture.h"

// 移動物体クラス
@interface HPMover : NSObject {
	
	// 座標
	float positionX, positionY;
	
	// 速度の大きさ、角度
	float speed, angle;
	
	// テクスチャ
	HPTexture* texture;
	
	// 描画サイズ、当たり判定のサイズ
	float drawSize, hitSize;
	
	// 回転角度、回転速度
	float rotation, rotationRate;
}

// 座標の取得
-(float)positionX;
-(float)positionY;

// 座標と速度の設定
-(void)setX:(float)x y:(float)y speed:(float)s angle:(float)a;

// 移動
-(BOOL)move;

// 描画
-(void)draw;

// 他の移動物体との当たり判定処理
-(BOOL)doesHitMover:(HPMover*)m;

// オブジェクトプールにある全ての移動物体を移動（クラスメソッド）
+(void)moveObjectPool:op;

// オブジェクトプールにある全ての移動物体を描画（クラスメソッド）
+(void)drawObjectPool:op;

// オブジェクトプールにある全ての移動物体を削除（クラスメソッド）
+(void)clearObjectPool:op;

@end
