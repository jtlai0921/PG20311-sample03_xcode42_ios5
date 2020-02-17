//
//  Model.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

#import "Common.h"
#import "Model.h"
#import "Matrix.h"

// モデルクラス（頂点バッファオブジェクトを使って描画する場合）
@implementation HPModel

// 初期化（配列を使って3Dモデルを初期化する）
-(id)initWithPositions:(GLfloat*)p positionsSize:(GLsizei)ps 
	texCoords:(GLfloat*)t texCoordsSize:(GLsizei)ts 
	indices:(GLushort*)i indicesSize:(GLsizei)is 
	texFile:(NSString*)file
{
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		
		// テクスチャ
		hpTexture=[[HPTexture alloc] initWithFile:file];
		
		// 頂点番号数
		indicesCount=is/sizeof(GLushort);
		
		// 頂点座標
		glGenBuffers(1, &positionsBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, positionsBuffer);
		glBufferData(GL_ARRAY_BUFFER, ps, p, GL_STATIC_DRAW);
		
		// テクスチャ座標
		glGenBuffers(1, &texCoordsBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordsBuffer);
		glBufferData(GL_ARRAY_BUFFER, ts, t, GL_STATIC_DRAW);
		
		// 頂点番号
		glGenBuffers(1, &indicesBuffer);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER, is, i, GL_STATIC_DRAW);
		
		// バッファのバインド
		glBindBuffer(GL_ARRAY_BUFFER, 0);
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	}
	return self;
}

// 破棄
-(void)dealloc {
	[hpTexture release];
	glDeleteBuffers(1, &positionsBuffer);
	glDeleteBuffers(1, &texCoordsBuffer);
	glDeleteBuffers(1, &indicesBuffer);
	[super dealloc];
}

// 描画
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz 
{
	// 視点、前方クリップ面、後方クリップ面の各Z座標
	const GLfloat eye=10, nearZ=5, farZ=100;
	
	// 行列の計算
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	s*=eye/nearZ;
	hpMatrixScale(matrix, s, s, s);
	hpMatrixRotateX(matrix, rx);
	hpMatrixRotateY(matrix, ry);
	hpMatrixRotateZ(matrix, rz);
	hpMatrixTranslate(matrix, x, y, z-eye);
	hpMatrixTranslate(matrix, x, y, z);
	hpMatrixProjection(matrix, screenWidth, screenHeight, nearZ, farZ);

	// 以下の拡大縮小は上記の射影変換と一緒に行うので省略できる
	// hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, -1);
	
	
	// OpenGL ES 2.0の処理
	if (glContext.API==kEAGLRenderingAPIOpenGLES2) {
		
		// シェーダ、テクスチャ、行列、色の設定
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glUniform4f(glUniformColor, r, g, b, a);
		
		// 頂点座標、テクスチャ座標の設定
		glBindBuffer(GL_ARRAY_BUFFER, positionsBuffer);
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, 0);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordsBuffer);
		glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, 0);
		
		// シェーダの検証
		glValidateProgram(glProgram);
	} else 
	
	// OpenGL ES 1.1の処理
	{
		// 色の設定
		glColor4f(r, g, b, a);
		glBindBuffer(GL_ARRAY_BUFFER, positionsBuffer);
		
		// 頂点座標、テクスチャ座標の設定
		glVertexPointer(3, GL_FLOAT, 0, 0);
		glBindBuffer(GL_ARRAY_BUFFER, texCoordsBuffer);
		glTexCoordPointer(2, GL_FLOAT, 0, 0);
		
		// 行列の設定
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }
	
	// 深度テストの有効化
	glEnable(GL_DEPTH_TEST);
	
	// カリングの有効化
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	
	// テクスチャの設定
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, [hpTexture glTexture]);
	
	// ポリゴンの描画
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indicesBuffer);
	glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_SHORT, 0);
	
	// バッファの解放
	glBindBuffer(GL_ARRAY_BUFFER, 0);	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
	
	// 深度テストとカリングの無効化
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);
}

@end

//-------------------------------------------------------------------------

// モデルクラス（配列を使って描画する場合）
/*
@implementation HPModel

// 初期化
-(id)initWithPositions:(GLfloat*)p texCoords:(GLfloat*)t 
	indices:(GLushort*)i indicesCount:(GLsizei)c texFile:(NSString*)file
{
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		
		// テクスチャ
		hpTexture=[[HPTexture alloc] initWithFile:file];
		
		// 頂点座標、テクスチャ座標、頂点番号
		positions=p;
		texCoords=t;
		indices=i;
		
		// 頂点番号数
		indicesCount=c;
	}
	return self;
}

// 破棄
-(void)dealloc {
	[hpTexture release];
	[super dealloc];
}

// 描画
-(void)drawWithX:(GLfloat)x y:(GLfloat)y z:(GLfloat)z scale:(GLfloat)s 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a 
	rotationX:(GLfloat)rx rotationY:(GLfloat)ry rotationZ:(GLfloat)rz 
{
	// 視点、前方クリップ面、後方クリップ面の各Z座標
	const GLfloat eye=10, nearZ=5, farZ=15;
	
	// 行列の計算（射影変換を行う場合）
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	s*=eye/nearZ;
	hpMatrixScale(matrix, s, s, s);
	hpMatrixRotateX(matrix, rx);
	hpMatrixRotateY(matrix, ry);
	hpMatrixRotateZ(matrix, rz);
	hpMatrixTranslate(matrix, x, y, z-eye);
	hpMatrixProjection(matrix, screenWidth, screenHeight, nearZ, farZ);
	
	// 行列の計算（射影変換を行わない場合）
	// GLfloat matrix[16];
	// hpMatrixIdentity(matrix);
	// hpMatrixScale(matrix, s, s, s);
	// hpMatrixRotateX(matrix, rx);
	// hpMatrixRotateY(matrix, ry);
	// hpMatrixRotateZ(matrix, rz);
	// hpMatrixTranslate(matrix, x, y, z);
	// hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, -1);
	
	// OpenGL ES 2.0の処理
	if (glContext.API==kEAGLRenderingAPIOpenGLES2) {
		
		// シェーダ、テクスチャ、行列、色の設定
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glUniform4f(glUniformColor, r, g, b, a);
		
		// 頂点座標、テクスチャ座標の設定
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, positions);
		glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
		
		// シェーダの検証
		glValidateProgram(glProgram);
	} else 
	
	// OpenGL ES 1.1の処理
	{
		// 色の設定
		glColor4f(r, g, b, a);
		
		// 頂点座標、テクスチャ座標の設定
		glVertexPointer(3, GL_FLOAT, 0, positions);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		
		// 行列の設定
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }
	
	// 深度テストの有効化
	glEnable(GL_DEPTH_TEST);
	
	// カリングの有効化
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	
	// テクスチャの設定
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, [hpTexture glTexture]);
	
	// ポリゴンの描画
	glDrawElements(GL_TRIANGLES, indicesCount, GL_UNSIGNED_SHORT, indices);
	
	// 深度テストとカリングの無効化
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_CULL_FACE);
}

@end
*/

