//
//  Number.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Number.h"

// 数値クラス
@implementation HPNumber

// 初期化
-(id)init {
	self=[super init];
	if (self!=nil) {
		hitSize=0;
	}
	return self;
}

// 破棄
-(void)dealloc {
	[super dealloc];
}

// 数値の取得
-(NSInteger)value {
	return value;
}

// 数値の加算
-(void)addValue:(NSInteger)v {
	value+=v;
}

// 数値、描画サイズ、制限時間の設定
-(void)setValue:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t {
	value=v;
	drawSize=d;
	time=0;
	timeLimit=t;
	if (timeLimit<=0) timeLimit=-1;
}

// 移動
-(BOOL)move {
	
	// 制限時間が有効（正の値）の場合には、制限時間になったら数値を消去する
	if (timeLimit>0) {
		if (time==timeLimit) {
			return FALSE;
		}
		time++;
	}
	return [super move];
}

// 描画
-(void)draw {
	float x=positionX;
	NSInteger v=value;
	
	// 数値を下位から1桁ずつ、右から左に描画する
	do {
		[numberTexture[v%10] drawWithX:x y:positionY width:drawSize height:drawSize 
			red:1.0f green:1.0f blue:1.0f 
			alpha:MIN((float)(timeLimit-time)/timeLimit*5, 1.0f) rotation:rotation];
		v/=10;
		x-=drawSize*2;
	} while (v>0);
}

// 数値の出現（クラスメソッド）
+(void)launchNumberWithX:(float)x y:(float)y speed:(float)s angle:(float)a value:(NSInteger)v drawSize:(float)d timeLimit:(NSInteger)t {
	HPNumber* n=[numberPool addObject];
	[n setX:x y:y speed:s angle:a];
	[n setValue:v drawSize:d timeLimit:t];
}

@end
