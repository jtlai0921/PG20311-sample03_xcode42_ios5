//
//  Texture.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// テクスチャのクラス

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface HPTexture : NSObject {
	
	// OpenGL ESのテクスチャ名
	GLuint texture;
}

// ファイルの読み込み
-(id)initWithFile:(NSString*)file;

// 破棄
-(void)dealloc;

// 描画（テクスチャ座標の設定あり）
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot 
	fromU:(GLfloat)fu fromV:(GLfloat)fv toU:(GLfloat)tu toV:(GLfloat)tv;

// 描画（テクスチャ座標の設定なし）
-(void)drawWithX:(GLfloat)x y:(GLfloat)y width:(GLfloat)w height:(GLfloat)h 
	red:(GLfloat)r green:(GLfloat)g blue:(GLfloat)b alpha:(GLfloat)a rotation:(GLfloat)rot;

// テクスチャ名の取得
-(GLuint)glTexture;

@end

