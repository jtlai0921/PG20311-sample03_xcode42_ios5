//
//  Button.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Button.h"
#import "Common.h"

// ボタンクラス
@implementation HPButton

// テクスチャ、サイズ、ボタン番号の設定
-(void)setTexture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i {
	
	// テクスチャ、サイズ、ボタン番号
	texture=t;
	width=w;
	height=h;
	index=i;
	
	// アルファ値、色、拡大縮小率、状態
	alpha=0.9f;
	color=1;
	scale=0;
	state=1;
}

// 色、アルファ値、拡大縮小率の補間
-(void)interpolateColor:(GLfloat)c alpha:(GLfloat)a scale:(GLfloat)s {
	const float f=0.05f;
	if (fabs(c-color)<f) color=c; else color+=(c<color)?-f:f;
	if (fabs(a-alpha)<f) alpha=a; else alpha+=(a<alpha)?-f:f;
	if (fabs(s-scale)<f) scale=s; else scale+=(s<scale)?-f:f;
}

// 移動
-(BOOL)move {
	
	// 状態に応じて分岐
	switch (state) {
		
		// 状態１（出現）
		case 1:
			
			// 少し暗めで、完全に不透明で、本来のサイズにする
			[self interpolateColor:0.9f alpha:1 scale:1];
			
			// ボタンをタッチしたら状態２へ移行
			if (!previousTouched && touched && 
				fabs(touchX-positionX)<width && fabs(touchY-positionY)<height
			) {
				state=2;
			}
			break;
		
		// 状態２（押下）
		case 2:
			
			// 少し明るめで、完全に不透明で、少し大きめにする
			[self interpolateColor:1.2f alpha:1 scale:1.2f];
			
			// ボタンの内側でタッチを離したら状態３へ移行
			if (fabs(touchX-positionX)<width && fabs(touchY-positionY)<height) {
				if (!touched) {
					buttonIndex=index;
					[buttonPlayer play];
					state=3;
				}
			} else 
			
			// ボタンの外側に指が出たら状態１へ移行
			{
				state=1;
			}
			break;
		
		// 状態３（消滅）
		case 3:
			
			// 少し明るめで、完全に透明で、サイズを0にする
			[self interpolateColor:1.2f alpha:0 scale:0];
			
			// 完全に透明になったら状態-1へ移行
			if (alpha==0) {
				state=-1;
			}
			break;
	}
	
	// 状態-1のときはNO、それ以外のときはYESを返す
	return state!=-1;
}

// 描画
-(void)draw {
	[texture drawWithX:positionX y:positionY 
		width:width*scale height:height*scale 
		red:color green:color blue:color alpha:alpha 
		rotation:0];
}

// ボタンの出現（クラスメソッド）
+(void)launchButtonWithX:(float)x y:(float)y texture:(HPTexture*)t width:(GLfloat)w height:(GLfloat)h index:(NSInteger)i {
	HPButton* b=[buttonPool addObject];
	[b setX:x y:y speed:0 angle:0];
	[b setTexture:t width:w height:h index:i];
}

@end
