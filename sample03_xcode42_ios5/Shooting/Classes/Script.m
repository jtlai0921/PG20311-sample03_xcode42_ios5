//
//  Script.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Boss.h"
#import "Common.h"
#import "Enemy.h"
#import "Script.h"

// スクリプトコマンドクラス
@implementation HPScriptCommand

// 初期化
-(id)initWithString:s {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		
		// スクリプトの文字列を,で区切る
		NSArray* a=[s componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		// 要素が5個の場合には敵出現コマンドとして解釈する
		if ([a count]==5) {
			wait=0;
			type=[[a objectAtIndex:0] intValue];
			positionX=[[a objectAtIndex:1] floatValue];
			positionY=[[a objectAtIndex:2] floatValue];
			speed=[[a objectAtIndex:3] floatValue];
			angle=[[a objectAtIndex:4] floatValue];
		} else
			
		// 要素が1個の場合には待機コマンドとして解釈する
		if ([a count]==1) {
			type=-1;
			wait=[[a objectAtIndex:0] intValue];
		}
	}
	return self;
}

// 実行
-(NSInteger)run {
	
	// ボス出現コマンドの場合、ボスを出現させる
	if (type==2) {
		[HPBoss launchBoss];
	} else
	
	// 敵出現コマンドの場合、敵を出現させる
	if (type>=0) {
		[HPEnemy launchEnemyWithX:positionX	y:positionY speed:speed angle:angle type:type];
	}
	
	// 待機時間を返す（ランクが高くなると待機時間が短くなる）
	return wait/rank;
}

@end


// スクリプトクラス
@implementation HPScript

// 初期化
-(id)initWithFile:(NSString*)file {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		
		// コマンドの配列を初期化
		command=[[NSMutableArray alloc] init];
		
		// スクリプトのファイルを読み込む
		NSString* path=[[NSBundle mainBundle] pathForResource:file ofType:@"txt"];
		NSString* text=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
		
		// スクリプトを行単位に分割する
		NSArray* lines=[text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		// スクリプトの各行を解釈する
		for (NSString* line in lines) {
			
			// コメント行は飛ばして、コメント以外の行はスクリプトコマンドクラスで解釈する
			if ([line length]>0 && [line rangeOfString:@"//"].location==NSNotFound) {
				[command addObject:[[[HPScriptCommand alloc] initWithString:line] autorelease]];
			}
		}
		
		// for-in文（高速列挙）を使わずに、通常のfor文を使って以下のように書くこともできる
		/*
		for (NSInteger i=0; i<[lines count]; i++) {
			NSString* line=[lines objectAtIndex:i];
		*/		
	}
	return self;
}

// 破棄
-(void)dealloc {
	[command release];
	[super dealloc];
}

// リセット
-(void)reset {
	index=wait=0;
}

// 移動（実行）
-(BOOL)move {
	
	// ボスの出現中はスクリプトを実行しない
	if ([bossPool objectCount]==0) {
		
		// 待機コマンドに達するまで、コマンドを連続して実行する
		while (wait==0 && index<[command count]) {
			wait=[(HPScriptCommand*)[command objectAtIndex:index] run];
			index++;
		}
		
		// 待機時間を減らす
		wait--;
	}
	
	// スクリプトの末尾まで実行したらNOを返す
	return wait>=0;
}

@end
