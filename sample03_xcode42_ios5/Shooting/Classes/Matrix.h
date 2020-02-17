//
//  Matrix.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 行列計算用の関数群

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>

// 単位行列
extern void hpMatrixIdentity(GLfloat* m);

// 行列積
extern void hpMatrixMultiply(GLfloat* m, const GLfloat* n);

// 拡大縮小
extern void hpMatrixScale(GLfloat* m, GLfloat x, GLfloat y, GLfloat z);

// 回転（X軸、Y軸、Z軸）
extern void hpMatrixRotateX(GLfloat* m, GLfloat r);
extern void hpMatrixRotateY(GLfloat* m, GLfloat r);
extern void hpMatrixRotateZ(GLfloat* m, GLfloat r);

// 平行移動
extern void hpMatrixTranslate(GLfloat* m, GLfloat x, GLfloat y, GLfloat z);

// 射影変換
extern void hpMatrixProjection(GLfloat* m, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat fz);
