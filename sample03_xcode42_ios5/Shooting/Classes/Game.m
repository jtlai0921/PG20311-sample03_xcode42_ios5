//
//  Game.m
//  Shooting
//
//  Copyright 2011 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// ゲーム本体のクラス

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "Boss.h"
#import "Bullet.h"
#import "Button.h"
#import "BossModel.h"
#import "Common.h"
#import "Game.h"
#import "Mover.h"
#import "Enemy.h"
#import "Weapon.h"
#import "Number.h"
#import "Script.h"
#import "Texture.h"

// ゲーム本体のクラス
@implementation HPGame

// 加速度を検出するためのデリゲートメソッド
-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	accelerationX=[acceleration x];
	accelerationY=[acceleration y];
	accelerationZ=[acceleration z];
}

// 設定のセーブ
-(void)save {
	
	// ハイスコアと操作タイプの設定を保存
	NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
	[def setInteger:topScore forKey:@"topScore"];
	[def setInteger:controlType forKey:@"controlType"];
	[def synchronize];
}

// 設定のロード
-(void)load {
	
	// ハイスコアと操作タイプの初期値を作成
	NSDictionary* dic=[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:0], @"topScore",
		[NSNumber numberWithInt:0], @"controlType", 
		nil];

	// ハイスコアと操作タイプの設定を読み込み
	NSUserDefaults* def=[NSUserDefaults standardUserDefaults];
	[def registerDefaults:dic];
	topScore=[def integerForKey:@"topScore"];
	controlType=[def integerForKey:@"controlType"];
}

// 音声ファイルの読み込み
-(AVAudioPlayer*)playerWithFile:file {
	
	// ファイルのパスとURLを作成
	NSString* path=[[NSBundle mainBundle] pathForResource:file ofType:@"caf"];
	NSURL* url=[NSURL fileURLWithPath:path];
	
	// ファイルからプレイヤーを作成
	AVAudioPlayer* player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[player prepareToPlay];
	
	// プレイヤーのインスタンスを返す
	return [player autorelease];
}

// 初期化
-(id)init {
	
	// スーパークラス部分の初期化
	self=[super init];
	
	// サブクラス部分の初期化
	if (self!=nil) {
		
		// テクスチャの読み込み
		bulletTexture=[[HPTexture alloc] initWithFile:@"Bullet.png"];
		myShipTexture[0]=[[HPTexture alloc] initWithFile:@"MyShip0.png"];
		myShipTexture[1]=[[HPTexture alloc] initWithFile:@"MyShip1.png"];
		myShipDestroyedTexture=[[HPTexture alloc] initWithFile:@"MyShipDestroyed.png"];
		enemyTexture[0]=[[HPTexture alloc] initWithFile:@"Enemy0.png"];
		enemyTexture[1]=[[HPTexture alloc] initWithFile:@"Enemy1.png"];
		weaponTexture=[[HPTexture alloc] initWithFile:@"Weapon.png"];
		padTexture=[[HPTexture alloc] initWithFile:@"Pad.png"];
		for (NSInteger i=0; i<10; i++) {
			numberTexture[i]=[[HPTexture alloc] initWithFile:[NSString stringWithFormat:@"Number%d.png",i]];
		}
		backgroundTexture=[[HPTexture alloc] initWithFile:@"Background.jpg"];
		titleTexture=[[HPTexture alloc] initWithFile:@"Title.png"];
		for (NSInteger i=0; i<3; i++) {
			controlTexture[i]=[[HPTexture alloc] initWithFile:[NSString stringWithFormat:@"Control%d.png",i]];
		}
		newRecordTexture=[[HPTexture alloc] initWithFile:@"NewRecord.png"];
		gameOverTexture=[[HPTexture alloc] initWithFile:@"GameOver.png"];
		
		// モデルの読み込み
		bossModel=[[HPModel alloc] initWithPositions:bossPositions positionsSize:bossPositionsSize 
			texCoords:bossTexCoords texCoordsSize:bossTexCoordsSize 
			indices:bossIndices indicesSize:bossIndicesSize texFile:@"Boss.jpg"];
		
		
		// オブジェクトプールの作成
		myShipPool=[[HPObjectPool alloc] initWithClass:HPMyShip.class];
		bulletPool=[[HPObjectPool alloc] initWithClass:HPBullet.class];
		enemyPool=[[HPObjectPool alloc] initWithClass:HPEnemy.class];
		weaponPool=[[HPObjectPool alloc] initWithClass:HPWeapon.class];
		numberPool=[[HPObjectPool alloc] initWithClass:HPNumber.class];
		bossPool=[[HPObjectPool alloc] initWithClass:HPBoss.class];
		buttonPool=[[HPObjectPool alloc] initWithClass:HPButton.class];
		
		// スクリプトの読み込み
		script=[[HPScript alloc] initWithFile:@"Script"];
		
		// 加速度を検出するための準備（デリゲートの登録、通知間隔の設定）
		[UIAccelerometer sharedAccelerometer].delegate=self;
		[UIAccelerometer sharedAccelerometer].updateInterval=1.0/60;
			
		// OpenGL ESの初期化（2.0, 1.1に共通の初期化）
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		if (glContext.API==kEAGLRenderingAPIOpenGLES2) {

			// OpenGL ES 2.0の初期化
			glUniformTexture=glGetUniformLocation(glProgram, "texture");
			glUniformMatrix=glGetUniformLocation(glProgram, "matrix");
			glUniformColor=glGetUniformLocation(glProgram, "color");

            // アトリビュートの設定はViewControllerクラスに移動
            // This code is moved to ViewController class.
//			glBindAttribLocation(glProgram, 0, "position");
//			glBindAttribLocation(glProgram, 1, "coord");

 			glEnableVertexAttribArray(0);
			glEnableVertexAttribArray(1);
		} else {

			// OpenGL ES 1.1の初期化
			glEnable(GL_TEXTURE_2D);
			glEnableClientState(GL_VERTEX_ARRAY);
			glEnableClientState(GL_TEXTURE_COORD_ARRAY);			
		}

		// サウンドの初期化
		// カテゴリを設定することにより、効果音とBGMが同時に再生されるようにする
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

		// 音声ファイルの読み込み
		buttonPlayer=[[self playerWithFile:@"Button"] retain];
		hitPlayer=[[self playerWithFile:@"Hit"] retain];
		enemyPlayer=[[self playerWithFile:@"Enemy"] retain];
		bossPlayer=[[self playerWithFile:@"Boss"] retain];

		// BGMの初期化
		// iOSデバイスの実機の場合だけ、この処理を含めてコンパイルする
		#if !TARGET_IPHONE_SIMULATOR
		musicPlayer=[MPMusicPlayerController applicationMusicPlayer];
		[musicPlayer setQueueWithQuery:[MPMediaQuery albumsQuery]];		
		musicPlayer.repeatMode=MPMusicRepeatModeAll;
		musicPlayer.shuffleMode=MPMusicShuffleModeSongs;
		#endif
		
		// ゲームの状態を初期化（タッチの状態、ゲームの状態、スクロール位置、描画回数）
		touched=NO;		
		state=1;
		backgroundY=0;
		drawTime=0;
		
		// 設定のロード
		[self load];
		
        // iPadに関するコードはdraw関数に移動
        // Codes for iPad are moved to draw function.
	}
	return self;
}

// 破棄
-(void)dealloc {
	
	// スクリプト
	[script release];

	// オブジェクトプール
	[myShip release];
	[bulletPool release];
	[enemyPool release];
	[weaponPool release];
	[numberPool release];
	[bossPool release];
	[buttonPool release];

	// テクスチャ
	[bulletTexture release];
	[myShipTexture[0] release];
	[myShipTexture[1] release];
	[myShipDestroyedTexture release];
	[enemyTexture[0] release];
	[enemyTexture[1] release];
	[weaponTexture release];
	[padTexture release];
	for (NSInteger i=0; i<10; i++) {
		[numberTexture[i] release];
	}
	[titleTexture release];
	for (NSInteger i=0; i<3; i++) {
		[controlTexture[i] release];
	}
	[newRecordTexture release];
	[gameOverTexture release];

	// モデル
	[bossModel release];

	// サウンド
	[buttonPlayer release];
	[hitPlayer release];
	[enemyPlayer release];
	[bossPlayer release];
	
	[super dealloc];
}

// 移動
-(void)move {
    
	// ゲームの状態に応じて分岐
	switch (state) {
			
		// タイトル準備
		case 1:
			
			// タイトル、操作タイプ、ハイスコアを表示
			if ([buttonPool objectCount]==0) {
				buttonIndex=-1;
				[HPButton launchButtonWithX:0 y:0.25f texture:titleTexture width:1 height:1 index:0];
				[HPButton launchButtonWithX:0 y:-1 texture:controlTexture[controlType] width:1 height:0.25f index:1];
				[HPNumber launchNumberWithX:screenWidth-0.1f y:screenHeight-0.1f speed:0 angle:0 value:topScore drawSize:0.1f timeLimit:0];
				state=2;
			}
			break;
		
		// タイトル
		case 2:
			switch (buttonIndex) {
				
				// タイトルボタンを選択したらゲームを開始
				case 0:
					[buttonPool removeObjectAtIndex:1];
					[HPMover clearObjectPool:numberPool];
					state=3;
					break;
				
				// 操作タイプボタンを選択したら操作タイプを変更
				case 1:
					controlType=(controlType+1)%3;
					[self save];
					buttonIndex=-1;
					[HPButton launchButtonWithX:0 y:-1 texture:controlTexture[controlType] width:1 height:0.25f index:1];
					break;
			}
			break;
			
		// ゲーム準備
		case 3:			
			if ([buttonPool objectCount]==0) {
				
				// スコアの表示
				[HPNumber launchNumberWithX:screenWidth-0.1f y:screenHeight-0.1f speed:0 angle:0 value:0 drawSize:0.1f timeLimit:0];
				score=[numberPool objectAtIndex:0];
				
				// 自機の出現
				[HPMyShip launchMyShip];
				
				// スクリプトの開始
				[script reset];
				
				// ランクの設定
				rank=1;
				
				// iOSデバイスの実機の場合には、BGMを再生
				#if !TARGET_IPHONE_SIMULATOR
				[musicPlayer play];
				#endif

				state=4;
			}
			break;
			
		// ゲーム
		case 4:
			
			// スクリプトの実行
			if (![script move]) {
				[script reset];
			}
			
			// 自機、弾、敵などの移動
			[HPMover moveObjectPool:myShipPool];
			[HPMover moveObjectPool:bulletPool];
			[HPMover moveObjectPool:enemyPool];
			[HPMover moveObjectPool:weaponPool];
			[HPMover moveObjectPool:numberPool];
			[HPMover moveObjectPool:bossPool];
			
			// ランクの上昇
			rank+=0.001f;
			
			// 自機が破壊されたらゲームオーバーへ移行
			if ([myShipPool objectCount]==0) {
				
				// ハイスコアが出なかったらGame Over、ハイスコアが出たらNew Recordと表示
				buttonIndex=-1;
				if (topScore<[score value]) {
					topScore=[score value];
					[self save];
					[HPButton launchButtonWithX:0 y:0 texture:newRecordTexture width:1 height:0.25f index:0];
				} else {
					[HPButton launchButtonWithX:0 y:0 texture:gameOverTexture width:1 height:0.25f index:0];
				}
				
				// iOSデバイスの実機の場合には、BGMを中断して次の曲に進む
				#if !TARGET_IPHONE_SIMULATOR
				[musicPlayer pause];
				[musicPlayer skipToNextItem];
				#endif

				state=5;
			}
			break;
		
		// ゲームオーバー
		case 5:
			
			// ゲームオーバーボタンを選択したら、弾、敵、武器などを消去
			if (buttonIndex==0) {
				[HPMover clearObjectPool:bulletPool];
				[HPMover clearObjectPool:enemyPool];
				[HPMover clearObjectPool:weaponPool];
				[HPMover clearObjectPool:numberPool];
				[HPMover clearObjectPool:bossPool];
				state=1;
			}
			break;
			
	}
	
	// ボタンを動かす
	[HPMover moveObjectPool:buttonPool];
	
	// 背景のスクロール
	backgroundY-=0.002f;
	backgroundY-=(NSInteger)backgroundY;
}

// 描画
-(void)draw {

	// 描画回数を半分（秒間30フレーム）にするには、次のような処理を行う
//	drawTime=1-drawTime;
//	if (drawTime!=0) return;
    
    // アスペクト比の調整
    glGetIntegerv(GL_VIEWPORT, (GLint*)&viewport);
    
    // 仮想パッドの設定
    // Initialize variables for the virtual pad.
    padX=-0.7, padY=-1.2, padSize=0.25;
    
    // iPadにおいて、画面の横方向をiPhoneに合わせて表示する場合には以下の処理を行う
//    float sh=screenHeight;
//    screenHeight=screenWidth*viewport.h/viewport.w;
//    padY*=screenHeight/sh;
    
    // iPadにおいて、画面の縦方向をiPhoneに合わせて表示する場合には以下の処理を行う
//    float sw=screenWidth;
//    screenWidth=screenHeight*viewport.w/viewport.h;
//    padX*=screenWidth/sw;
    
    // iPadの場合には、仮想パッドの表示サイズを小さくする
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        padSize/=2;
        padX-=padSize;
        padY-=padSize;
    }
	
	// iPadにおいて、画面の両側に余白を設けるためにビューポートを設定する処理
//    GLsizei w=viewport.h*screenWidth/screenHeight;
//    glViewport((viewport.w-w)/2, 0, w, viewport.h);
//    glGetIntegerv(GL_VIEWPORT, (GLint*)&viewport);

    //  次のように書くと、画面の右側が余白になる
//    GLsizei w=viewport.h*screenWidth/screenHeight;
//    glViewport(0, 0, w, viewport.h);    
//    glGetIntegerv(GL_VIEWPORT, (GLint*)&viewport);

	// 背景を表示する場合には次の処理を行う
	// 深度バッファをクリアし、背景のテクスチャを描画する
	glClear(GL_DEPTH_BUFFER_BIT);
	[backgroundTexture drawWithX:0.0f y:0.0f width:screenWidth height:screenHeight 
		red:1.0f green:1.0f blue:1.0f alpha:1.0f 
		rotation:0.0f fromU:0.0f fromV:backgroundY toU:1.0f toV:backgroundY+screenHeight];

 	// 背景を表示しない場合には次の処理を行う
	// カラーバッファと深度バッファをクリアする
//	glClearColor(1, 1, 1, 1);
//	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

	// ボス、敵、自機などの描画
	[HPMover drawObjectPool:bossPool];
	[HPMover drawObjectPool:enemyPool];
	[HPMover drawObjectPool:myShipPool];
	[HPMover drawObjectPool:weaponPool];
	[HPMover drawObjectPool:bulletPool];
	[HPMover drawObjectPool:numberPool];
	[HPMover drawObjectPool:buttonPool];

	// 仮想パッドの表示
	if ([myShipPool objectCount]>0 && controlType==2) {
		[padTexture drawWithX:padX y:padY width:padSize height:padSize 
			red:1.0f green:1.0f blue:1.0f alpha:0.4f rotation:0.0f];
	}
}

@end
