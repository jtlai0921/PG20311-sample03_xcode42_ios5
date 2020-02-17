//
//  Button.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Mover.h"

// ボタンクラス
@interface HPButton : HPMover {
	
	// 状態、ボタン番号
	NSInteger state, index;
	
	// 幅、高さ、色、アルファ値、拡大縮小率
	float width, height, color, alpha, scale;
}

// 移動
-(BOOL)move;

// 描画
-(void)draw;

// テクスチャ、サイズ、ボタン番号の設定
-(void)setTexture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i;

// 色、アルファ値、拡大縮小率の補間
-(void)interpolateColor:(GLfloat)c alpha:(GLfloat)a scale:(GLfloat)s;

// ボタンの出現（クラスメソッド）
+(void)launchButtonWithX:(float)x y:(float)y texture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i;

@end
