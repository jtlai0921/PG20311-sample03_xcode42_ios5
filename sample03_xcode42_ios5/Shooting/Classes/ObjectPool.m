//
//  ObjectPool.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "ObjectPool.h"

// オブジェクトプールクラス
@implementation HPObjectPool

// 初期化
-(id)initWithClass:(Class)class {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		objectClass=class;
		activeObjects=[[NSMutableArray alloc] init];
		freeObjects=[[NSMutableArray alloc] init];
	}
	return self;
}

// 破棄
-(void)dealloc {
	[activeObjects release];
	[freeObjects release];
	[super dealloc];
}

// アクティブオブジェクトの追加
-(id)addObject {
	id obj;
	
	// フリーオブジェクトがない場合には、新しいインスタンスを作成する
	if ([freeObjects count]==0) {
		obj=[[[objectClass alloc] init] autorelease];
		[activeObjects addObject:obj];
	} else 
	
	// フリーオブジェクトがある場合には、既存のインスタンスを利用する
	{
		obj=[freeObjects lastObject];
		[activeObjects addObject:obj];
		[freeObjects removeLastObject];
	}
	return obj;
}

// アクティブオブジェクトの削除
-(void)removeObjectAtIndex:(NSUInteger)index {
	
	// アクティブオブジェクトをフリーオブジェクトに変更する
	id obj=[activeObjects objectAtIndex:index];
	[freeObjects addObject:obj];
	[activeObjects removeObjectAtIndex:index];
}

// アクティブオブジェクトの取得
-(id)objectAtIndex:(NSUInteger)index {
	return [activeObjects objectAtIndex:index];
}

// アクティブオブジェクトの個数
-(NSUInteger)objectCount {
	return [activeObjects count];
}

@end

