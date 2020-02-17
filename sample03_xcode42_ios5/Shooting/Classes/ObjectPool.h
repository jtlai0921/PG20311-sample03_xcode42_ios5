//
//  ObjectPool.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// オブジェクトプールクラス
@interface HPObjectPool : NSObject
{
	// アクティブオブジェクト
	NSMutableArray* activeObjects;
	
	// フリーオブジェクト
	NSMutableArray* freeObjects;
	
	// オブジェクトのクラス
	Class objectClass;
}

// 初期化
-(id)initWithClass:(Class)class;

// 破棄
-(void)dealloc;

// アクティブオブジェクトの追加
-(id)addObject;

// アクティブオブジェクトの削除
-(void)removeObjectAtIndex:(NSUInteger)index;

// アクティブオブジェクトの取得
-(id)objectAtIndex:(NSUInteger)index;

// アクティブオブジェクトの個数
-(NSUInteger)objectCount;

@end

