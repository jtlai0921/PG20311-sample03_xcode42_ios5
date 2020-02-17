//
//  Common.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// ゲーム内で使うグローバル変数

#import <GLKit/GLKit.h>
#import "Game.h"
#import "Model.h"
#import "Mover.h"
#import "MyShip.h"
#import "Number.h"
#import "ObjectPool.h"
#import "Script.h"
#import "Texture.h"

// OpenGL ES関連
extern EAGLContext* glContext;
extern GLuint glProgram;
extern GLuint glUniformTexture, glUniformMatrix, glUniformColor;

// ゲーム本体
extern HPGame* game;

// オブジェクトプール
extern HPObjectPool *myShipPool, *bulletPool, *enemyPool, *weaponPool, *numberPool, *bossPool, *buttonPool;

// 自機
extern HPMyShip* myShip;

// スコア
extern HPNumber* score;

// テクスチャ
extern HPTexture 
	*bulletTexture, *myShipTexture[2], *myShipDestroyedTexture, *enemyTexture[], *weaponTexture, *padTexture, *numberTexture[10], *backgroundTexture, 
	*titleTexture, *controlTexture[4], *newRecordTexture, *gameOverTexture;

// 画面の座標
extern float screenWidth, screenHeight, movableWidth, movableHeight, originalWidth, originalHeight;

// 仮想パッド
extern float padX, padY, padSize, padMargin;

// 加速度
extern float minAcceleration, maxAcceleration;
extern float accelerationX, accelerationY, accelerationZ;

// タッチ
extern float touchX, touchY;
extern BOOL touched, previousTouched;

// スクリプト
extern HPScript* script;

// ランク
extern float rank;

// モデル
extern HPModel* bossModel;

// ボタン
extern NSInteger buttonIndex;

// 操作タイプ、ハイスコア
extern NSInteger controlType, topScore;

// 効果音
extern AVAudioPlayer *buttonPlayer, *hitPlayer, *enemyPlayer, *bossPlayer;

// BGM
extern MPMusicPlayerController* musicPlayer;

