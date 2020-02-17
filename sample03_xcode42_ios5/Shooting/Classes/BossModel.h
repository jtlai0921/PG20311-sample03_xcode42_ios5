//
//  BossModel.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// ボスの3Dモデル

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>

// 頂点座標
extern GLfloat bossPositions[];

// 頂点番号
extern GLushort bossIndices[];

// テクスチャ座標
extern GLfloat bossTexCoords[];

// 頂点番号数
extern GLsizei bossIndicesCount;

// 頂点座標、テクスチャ座標、頂点番号のバイト数
extern GLsizei bossPositionsSize, bossTexCoordsSize, bossIndicesSize;

