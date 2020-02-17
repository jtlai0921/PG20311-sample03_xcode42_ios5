//
//  Shader.vsh
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// バーテックスシェーダ（頂点色を使わない場合）

// 行列
uniform mat4 matrix;

// 頂点座標
attribute vec4 position;

// テクスチャ座標
attribute vec2 texCoord;

// テクスチャ座標（フラグメントシェーダへの出力）
varying vec2 vTexCoord;

// シェーダ本体
void main() {

	// 頂点座標を行列で変換して出力
	gl_Position=matrix*position;

	// テクスチャ座標はそのまま出力
	vTexCoord=texCoord;
}

//-------------------------------------------------------------------------

// バーテックスシェーダ（頂点色を使う場合）
/*

// 行列
uniform mat4 matrix;

// 頂点座標
attribute vec4 position;

// 頂点色（頂点ごとに異なる）
attribute vec4 color;

// テクスチャ座標
attribute vec2 texCoord;

// 頂点色（フラグメントシェーダへの出力用）
varying vec4 vColor;

// テクスチャ座標（フラグメントシェーダへの出力用）
varying vec2 vTexCoord;

// シェーダ本体
void main() {
	
	// 頂点座標を行列で変換して出力
	gl_Position=matrix*position;

	// 頂点色はそのまま出力
	vColor=color;

	// テクスチャ座標はそのまま出力
	vTexCoord=texCoord;
}

*/
