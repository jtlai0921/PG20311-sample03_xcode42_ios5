//
//  Model.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "Texture.h"

// モデルクラス（頂点バッファオブジェクトを使って描画する場合）
@interface HPModel : NSObject {
	
	// テクスチャ
	HPTexture* hpTexture;
	
	// 頂点座標、テクスチャ座標、頂点番号
	GLuint positionsBuffer, texCoordsBuffer, indicesBuffer;
	
	// 頂点番号数
	GLsizei indicesCount;
}

// 初期化
-(id)initWithPositions:(GLfloat*)p positionsSize:(GLsizei)ps 
	texCoords:(GLfloat*)t texCoordsSize:(GLsizei)ts 
	indices:(GLushort*)i indicesSize:(GLsizei)is 
	texFile:(NSString*)file;

// 破棄
-(void)dealloc;

// 描画
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz;

@end

//-------------------------------------------------------------------------

// モデルクラス（配列を使って描画する場合）
/*
@interface HPModel : NSObject {
	
	// テクスチャ
	HPTexture* hpTexture;
	
	// 頂点座標、テクスチャ座標
	GLfloat *positions, *texCoords;
	
	// 頂点番号
	GLushort* indices;
	
	// 頂点番号数
	GLsizei indicesCount;
}

// 初期化
-(id)initWithPositions:(GLfloat*)p texCoords:(GLfloat*)t 
	indices:(GLushort*)i indicesCount:(GLsizei)c texFile:(NSString*)file;

// 破棄
-(void)dealloc;

// 描画
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz;

@end
*/

