//
//  Game.h
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// ゲーム本体のクラス

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/gl.h>

// ビューポート（描画領域）を表す構造体
typedef struct {
    
	// 開始座標
	GLint x, y;
	
	// サイズ（幅と高さ）
	GLsizei w, h;
} HPViewport;

// ゲーム本体のクラス
@interface HPGame : NSObject <UIAccelerometerDelegate> {
	
	// ゲームの状態、描画回数を調整するためのタイマー
	NSInteger state, drawTime;
	
	// スクロールの位置
	float backgroundY;
    
    // ビューポート
    HPViewport viewport;
}

// 初期化
-(id)init;

// 破棄
-(void)dealloc;

// 移動
-(void)move;

// 描画
-(void)draw;

// 設定のロード
-(void)load;

// 設定のセーブ
-(void)save;

// 音声ファイルの読み込み
-(AVAudioPlayer*)playerWithFile:file;

@end
