//
//  Shader.fsh
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// フラグメントシェーダ（頂点色を使わない場合）

// テクスチャ
uniform sampler2D texture;

// 全体色（モデル全体で共通）
uniform lowp vec4 color;

// テクスチャ座標
varying lowp vec2 vTexCoord;

// シェーダ本体
void main() {

	// 色とテクスチャ色を乗算して出力
	gl_FragColor=color*texture2D(texture, vTexCoord);
}

//-------------------------------------------------------------------------

// フラグメントシェーダ（頂点色を使う場合）
/*

// テクスチャ
uniform sampler2D texture;

// 頂点色（頂点ごとに異なる）
varying lowp vec4 vColor;

// テクスチャ座標
varying lowp vec2 vTexCoord;

// シェーダ本体
void main() {

	// 頂点色とテクスチャ色を乗算して出力
	gl_FragColor=vColor*texture2D(texture, vTexCoord);
}

*/

