//
//  Matrix.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// 行列計算用の関数群

#import "Matrix.h"

// 単位行列
// mに単位行列を設定する
void hpMatrixIdentity(GLfloat* m) {
	m[0]=1; m[4]=0; m[8]=0; m[12]=0; 
	m[1]=0; m[5]=1; m[9]=0; m[13]=0; 
	m[2]=0; m[6]=0; m[10]=1; m[14]=0; 
	m[3]=0; m[7]=0;m[11]=0; m[15]=1;
}

// 行列積
// mの左からnを乗算し、結果をmに格納する
void hpMatrixMultiply(GLfloat* m, const GLfloat* n) {
	
	// mの内容をtに保存する
	GLfloat t[16];
	for (NSInteger i=0; i<16; i++) {
		t[i]=m[i];
	}
	
	// nとtを乗算し、結果をmに格納する
	m[0]=n[0]*t[0]+n[4]*t[1]+n[8]*t[2]+n[12]*t[3];
	m[1]=n[1]*t[0]+n[5]*t[1]+n[9]*t[2]+n[13]*t[3];
	m[2]=n[2]*t[0]+n[6]*t[1]+n[10]*t[2]+n[14]*t[3];
	m[3]=n[3]*t[0]+n[7]*t[1]+n[11]*t[2]+n[15]*t[3];
	m[4]=n[0]*t[4]+n[4]*t[5]+n[8]*t[6]+n[12]*t[7];
	m[5]=n[1]*t[4]+n[5]*t[5]+n[9]*t[6]+n[13]*t[7];
	m[6]=n[2]*t[4]+n[6]*t[5]+n[10]*t[6]+n[14]*t[7];
	m[7]=n[3]*t[4]+n[7]*t[5]+n[11]*t[6]+n[15]*t[7];
	m[8]=n[0]*t[8]+n[4]*t[9]+n[8]*t[10]+n[12]*t[11];
	m[9]=n[1]*t[8]+n[5]*t[9]+n[9]*t[10]+n[13]*t[11];
	m[10]=n[2]*t[8]+n[6]*t[9]+n[10]*t[10]+n[14]*t[11];
	m[11]=n[3]*t[8]+n[7]*t[9]+n[11]*t[10]+n[15]*t[11];
	m[12]=n[0]*t[12]+n[4]*t[13]+n[8]*t[14]+n[12]*t[15];
	m[13]=n[1]*t[12]+n[5]*t[13]+n[9]*t[14]+n[13]*t[15];
	m[14]=n[2]*t[12]+n[6]*t[13]+n[10]*t[14]+n[14]*t[15];
	m[15]=n[3]*t[12]+n[7]*t[13]+n[11]*t[14]+n[15]*t[15];
}

// 拡大縮小
// mの左から拡大縮小の行列を乗算する
void hpMatrixScale(GLfloat* m, GLfloat x, GLfloat y, GLfloat z) {
	GLfloat n[16];
	n[0]=x; n[4]=0; n[8]=0; n[12]=0; 
	n[1]=0; n[5]=y; n[9]=0; n[13]=0; 
	n[2]=0; n[6]=0; n[10]=z; n[14]=0; 
	n[3]=0; n[7]=0; n[11]=0; n[15]=1;
	hpMatrixMultiply(m, n);
}

// 回転（X軸）
// mの左から回転の行列を乗算する
void hpMatrixRotateX(GLfloat* m, GLfloat r) {
	GLfloat n[16];
	GLfloat rad=r*M_PI*2, c=cosf(rad), s=sinf(rad);
	n[0]=1; n[4]=0; n[8]=0; n[12]=0; 
	n[1]=0; n[5]=c; n[9]=-s; n[13]=0; 
	n[2]=0; n[6]=s; n[10]=c; n[14]=0; 
	n[3]=0; n[7]=0; n[11]=0; n[15]=1;
	hpMatrixMultiply(m, n);
}

// 回転（Y軸）
// mの左から回転の行列を乗算する
void hpMatrixRotateY(GLfloat* m, GLfloat r) {
	GLfloat n[16];
	GLfloat rad=r*M_PI*2, c=cosf(rad), s=sinf(rad);
	n[0]=c; n[4]=0; n[8]=s; n[12]=0; 
	n[1]=0; n[5]=1; n[9]=0; n[13]=0; 
	n[2]=-s; n[6]=0; n[10]=c; n[14]=0; 
	n[3]=0; n[7]=0; n[11]=0; n[15]=1;
	hpMatrixMultiply(m, n);
}

// 回転（Z軸）
// mの左から回転の行列を乗算する
void hpMatrixRotateZ(GLfloat* m, GLfloat r) {
	GLfloat n[16];
	GLfloat rad=r*M_PI*2, c=cosf(rad), s=sinf(rad);
	n[0]=c; n[4]=-s; n[8]=0; n[12]=0; 
	n[1]=s; n[5]=c; n[9]=0; n[13]=0; 
	n[2]=0; n[6]=0; n[10]=1; n[14]=0; 
	n[3]=0; n[7]=0; n[11]=0; n[15]=1;
	hpMatrixMultiply(m, n);
}

// 平行移動
// mの左から平行移動の行列を乗算する
void hpMatrixTranslate(GLfloat* m, GLfloat x, GLfloat y, GLfloat z) {
	GLfloat n[16];
	n[0]=1; n[4]=0; n[8]=0; n[12]=x; 
	n[1]=0; n[5]=1; n[9]=0; n[13]=y; 
	n[2]=0; n[6]=0; n[10]=1; n[14]=z; 
	n[3]=0; n[7]=0; n[11]=0; n[15]=1;
	hpMatrixMultiply(m, n);
}

// 射影変換
// mの左から射影変換の行列を乗算する
void hpMatrixProjection(GLfloat* m, GLfloat nx, GLfloat ny, GLfloat nz, GLfloat fz) {
	if (nx!=0 && ny!=0 && nz!=fz) {
		GLfloat n[16];
		n[0]=nz/nx; n[4]=0; n[8]=0; n[12]=0; 
		n[1]=0; n[5]=nz/ny; n[9]=0; n[13]=0; 
		n[2]=0; n[6]=0; n[10]=-fz/(fz-nz); n[14]=-fz*nz/(fz-nz); 
		n[3]=0; n[7]=0; n[11]=-1; n[15]=0;
		hpMatrixMultiply(m, n);
	}
}

