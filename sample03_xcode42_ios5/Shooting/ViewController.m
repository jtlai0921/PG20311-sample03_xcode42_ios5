//
//  ViewController.m
//  Shooting
//
//  Copyright 2012 Ken-ichiro Matsuura & Yuki Tsukasa (HigPen Works). All rights reserved.
//

// OpenGLに対応したビューのクラス（自動生成）

// ゲーム用のヘッダファイルを追加
#import "Common.h"

#import "ViewController.h"

@interface ViewController () {
    GLuint _program;
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ViewController

@synthesize context = _context;

// タッチを検出するための処理を追加

// タッチしたままスライドしたときに呼び出されるメソッド
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// 前回タッチしていたかどうかの状態を保存
	previousTouched=touched;
	
	// ビューの中でタッチした座標を取得
	CGPoint p=[[touches anyObject] locationInView:[self view]];
	
	// ゲームの座標系（X方向は-1から1、Y方向は-1.5から1.5など）に変換
	CGRect r=[[self view] bounds];
	touchX=(p.x*2/r.size.width-1)*screenWidth;
	touchY=(1-p.y*2/r.size.height)*screenHeight;
	
	// iPadでビューポートを変更したときのための座標の補正
//	touchX*=r.size.width/r.size.height*screenHeight;
}

// タッチを開始したときに呼び出されるメソッド
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// 共通の処理（スライド時の処理）を呼び出す
	[self touchesMoved:touches withEvent:event];
	
	// 状態を「タッチしている」にする
	touched=YES;
}

// タッチを終了した（指を離した）ときに呼び出されるメソッド
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
	// 共通の処理（スライド時の処理）を呼び出す
	[self touchesMoved:touches withEvent:event];
    
	// 状態を「タッチしていない」にする
	touched=NO;
}

// タッチが中断された（電話がかかってきたなど）ときに呼び出されるメソッド
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    
	// 共通の処理（スライド時の処理）を呼び出す
	[self touchesMoved:touches withEvent:event];
    
	// 状態を「タッチしていない」にする
	touched=NO;
}

// ビューコントローラの破棄
- (void)dealloc
{
	// ゲーム本体のインスタンスを破棄
	[game release];
    
    [_context release];
    [super dealloc];
}

// ビューコントローラの初期化時に呼び出されるメソッド
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// 以下のように書くと、iOSシミュレータではOpenGL ES 2.0が動作する
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];

	// iOSシミュレータでOpenGL ES 1.1のデバッグを行うときには、以下のような処理にする
//    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1] autorelease];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
	// OpenGL ESのコンテキスト（context）、シェーダ（program）をゲーム本体のプログラムから使うために、
	// グローバル変数（glContext, glProgram）に代入しておく
	glContext=_context;
	glProgram=_program;
	
	// ゲーム本体のクラス（HPGame）のインスタンスを作成する
	game=[[HPGame alloc] init];
    
    // 秒間60フレームに設定する
    // Set the frame rate to 60 frames per second.
    self.preferredFramesPerSecond=60;
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation==UIInterfaceOrientationPortrait;
    // Return YES for supported orientations
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];    
    [self loadShaders];
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
	[game move];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	[game draw];    
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // アトリビュートの指定（シェーダを結合する前に行うように変更）
    // Bind attributes. Need to be done before link shaders.
    glBindAttribLocation(_program, 0, "position");
    glBindAttribLocation(_program, 1, "coord");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
//    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
//    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
