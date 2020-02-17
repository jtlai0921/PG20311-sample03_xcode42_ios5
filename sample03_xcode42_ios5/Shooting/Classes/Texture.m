//
//  Texture.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// テクスチャのクラス

#import "Common.h"
#import "Texture.h"
#import "Matrix.h"

@implementation HPTexture

// ファイルの読み込み
-(id)initWithFile:(NSString*)file {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		
		// 画像の読み込み
		CGImageRef image=[UIImage imageNamed:file].CGImage;
		if (!image) {
			NSLog(@"Error: %@ is not found.", file);
			return 0;
		}
		
		// ピクセルをメモリ上に描画する
		size_t w=CGImageGetWidth(image), h=CGImageGetHeight(image);
		GLubyte* data=(GLubyte*)calloc(1, w*h*4);
		CGContextRef context=CGBitmapContextCreate(data, w, h, 8, w*4, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);
		CGContextDrawImage(context, CGRectMake(0, 0, (CGFloat)w, (CGFloat)h), image);
		CGContextRelease(context);
		
		// テクスチャの作成
		glGenTextures(1, &texture);
		glBindTexture(GL_TEXTURE_2D, texture);
		
		// テクスチャのフィルタを設定（線形補間を行う場合）
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

		// テクスチャのフィルタを設定（近傍点を取得する場合）
		// glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		// glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		
		// テクスチャにピクセルを設定
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
		
		// 作業用メモリの解放
		free(data);
	}
	return self;
}

// 破棄
-(void)dealloc {
	if (texture) {
		glDeleteTextures(1, &texture);
	}
	[super dealloc];
}

// テクスチャ名の取得
-(GLuint)glTexture {
	return texture;
}

// 描画（テクスチャ座標の設定なし）
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
{
	// テクスチャ座標ありの描画処理を呼び出す
	[self drawWithX:x y:y width:w height:h red:r green:g blue:b alpha:a rotation:rot fromU:0.0f fromV:0.0f toU:1.0f toV:1.0f];
}

// 描画（テクスチャ座標の設定あり）
// 頂点色を使わない場合
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
	fromU:(GLfloat)fu fromV:(GLfloat)fv toU:(GLfloat)tu toV:(GLfloat)tv 
{
	// 頂点座標
	const GLfloat positions[]={
		-1, -1, 1, -1, -1, 1, 1, 1
	};
	
	// テクスチャ座標
	const GLfloat texCoords[]={
		fu, tv, tu, tv, fu, fv, tu, fv
	};
	
	// 行列（高速化のため、最終的な行列を直接計算する場合）
	GLfloat c=cosf(rot*M_PI*2), s=sinf(rot*M_PI*2);
	GLfloat matrix[16]={
		c*w/screenWidth, s*w/screenHeight, 0, 0,
		-s*h/screenWidth, c*h/screenHeight, 0, 0,
		0, 0, 1, 0, 
		x/screenWidth, y/screenHeight, 0, 1
	};
		
	// 行列（行列用の関数群を使う場合）
	/*
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	hpMatrixScale(matrix, w, h, 1);
	hpMatrixRotateZ(matrix, rot);
	hpMatrixTranslate(matrix, x, y, 0);
	hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, 1);
	*/
	
	// OpenGL ES 2.0の処理
	if (glContext.API==kEAGLRenderingAPIOpenGLES2) {
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glUniform4f(glUniformColor, r, g, b, a);
		glVertexAttribPointer(0, 2, GL_FLOAT, 0, 0, positions);
		glVertexAttribPointer(1, 2, GL_FLOAT, 0, 0, texCoords);
		glValidateProgram(glProgram);
	} else 
	
	// OpenGL ES 1.1の処理
	{
		glVertexPointer(2, GL_FLOAT, 0, positions);
		glColor4f(r, g, b, a);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }

	// OpenGL ES 2.0/1.1に共通の処理
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

//-------------------------------------------------------------------------

// 描画（テクスチャ座標の設定あり）
// 頂点色を使う場合
/*
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
			 red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
		   fromU:(GLfloat)fu fromV:(GLfloat)fv toU:(GLfloat)tu toV:(GLfloat)tv 
{
 	// 頂点座標
	const GLfloat positions[]={
		-1, -1, 1, -1, -1, 1, 1, 1
	};

	// 頂点色
	const GLfloat colors[]={
		r, g, b, a, r, g, b, a, r, g, b, a, r, g, b, a
	};

	// テクスチャ座標
	const GLfloat texCoords[]={
		fu, tv, tu, tv, fu, fv, tu, fv
	};
	
	// 行列
	GLfloat matrix[16];
	hpMatrixIdentity(matrix);
	hpMatrixScale(matrix, w, h, 1);
	hpMatrixRotateZ(matrix, rot);
	hpMatrixTranslate(matrix, x, y, 0);
	hpMatrixScale(matrix, 1/screenWidth, 1/screenHeight, 1);
	
	// OpenGL ES 2.0の処理
	if ([glContext API]==kEAGLRenderingAPIOpenGLES2) {
		glUseProgram(glProgram);
		glUniform1i(glUniformTexture, 0);
		glUniformMatrix4fv(glUniformMatrix, 1, GL_FALSE, matrix);
		glVertexAttribPointer(0, 2, GL_FLOAT, 0, 0, positions);
		glVertexAttribPointer(1, 4, GL_FLOAT, 0, 0, colors);
		glVertexAttribPointer(2, 2, GL_FLOAT, 0, 0, texCoords);
		glValidateProgram(glProgram);
	} else 
 
	// OpenGL ES 1.1の処理
	{
		glVertexPointer(2, GL_FLOAT, 0, positions);
		glColorPointer(4, GL_FLOAT, 0, colors);
		glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
		glMatrixMode(GL_MODELVIEW);
		glLoadMatrixf(matrix);
    }
	
	// OpenGL ES 2.0/1.1に共通の処理
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texture);	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
*/

@end

