//
//  Common.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// ゲーム内で使うグローバル変数

#import "Common.h"

// OpenGL ES関連
EAGLContext* glContext;
GLuint glProgram;
GLuint glUniformTexture, glUniformMatrix, glUniformColor;

// ゲーム本体
HPGame* game;

// オブジェクトプール
HPObjectPool *myShipPool, *bulletPool, *enemyPool, *weaponPool, *numberPool, *bossPool, *buttonPool;

// 自機
HPMyShip* myShip;

// スコア
HPNumber* score;

// テクスチャ
HPTexture 
	*bulletTexture, *myShipTexture[2], *myShipDestroyedTexture, *enemyTexture[2], *weaponTexture, *padTexture, *numberTexture[10], *backgroundTexture, 
	*titleTexture, *controlTexture[4], *newRecordTexture, *gameOverTexture;

// 画面の座標
float screenWidth=1.0f, screenHeight=1.5f, movableWidth=1.1f, movableHeight=1.6f, originalWidth=1.0f, originalHeight=1.5f;

// 仮想パッド
float padX=-0.7, padY=-1.2, padSize=0.25, padMargin=0.05;

// 加速度
float minAcceleration=0.1, maxAcceleration=0.3;
float accelerationX, accelerationY, accelerationZ;

// タッチ
float touchX, touchY;
BOOL touched, previousTouched;

// スクリプト
HPScript* script;

// ランク
float rank;

// モデル
HPModel* bossModel;

// ボタン
NSInteger buttonIndex;

// 操作タイプ、ハイスコア
NSInteger controlType, topScore;

// 効果音
AVAudioPlayer *buttonPlayer, *hitPlayer, *enemyPlayer, *bossPlayer;

// BGM
MPMusicPlayerController* musicPlayer;


