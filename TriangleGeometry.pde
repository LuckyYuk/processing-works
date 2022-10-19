int[] x, y;             // x,y 座標
int[] x_s, y_s;         // x,y 配列のコピー用
int[] vx, vy;           // 各頂点から重心を引いたベクトル
int click;              // クリック数
int d1, d2, d3;         // 各頂点と4点目の距離
int max;                // 2点間の距離の最大値 -> 一番遠い
int farPoint;           // 各頂点と4点目の距離と一番遠い点の配列番号
int g_x, g_y;           // 三角形の重心
float penWidth;         // ペンの太さ
float n, ratio, diff;   // 割合
boolean first;          // 最初の三角形描画の判定


void setup() {
  size(1920, 1080); // 画面サイズ
  background(255);

  click = 0;
  x   = new int[4];
  y   = new int[4];
  x_s = new int[4];
  y_s = new int[4];
  vx  = new int[4];
  vy  = new int[4];

  d1 = d2 = d3 = 0;
  max       = 0;
  farPoint  = 0;
  g_x = g_y = 0;
  first = true;

  /* 各種設定 */
  penWidth = 0.5; // ペンの太さ
  n = 1.0;        // 三角形の重心から各頂点へのベクトルの割合 <- 1.0固定がいいかも
  ratio = n;
  diff  = 0.05;   // 細かさ <- 0.01でもいける
}

void draw() {
  // 塗りつぶしなし
  noFill();
  //strokeWeight(3);
  //for(int y = 50; y < height; y+=50)
  //  for(int x = 50; x < width; x+=50)
  //    point(x,y);

  if (click == 3 && first) {
    background(255);
    // 線の太さ
    strokeWeight(penWidth);
    // 線の色の変更 stroke( R, G, B ) <- R( 0~255 )...
    //stroke( random(0,255), random(0,255), random(0,255) );
    stroke(0);

    // 三角形を描画
    FirstTriangle();
    // 重心を出す
    centerOfGravity(g_x, g_y);
    // 複数の三角形を描画
    FirstTriangles(x, y);
    first = false;
  } else if (click == 4) {
    // 各変数リセット
    click = 3;
    g_x = g_y = 0;
    ratio = n;
    // 3つの頂点と4点目の距離を出し、一番遠い点の配列番号を返す
    farPoint = distance(x, y);

    // 線の太さ
    strokeWeight(penWidth);
    // 線の色の変更 stroke( R, G, B ) <- R( 0~255 )...
    //stroke( random(0,255), random(0,255), random(0,255) );
    stroke(0);

    // 三角形を描画
    SecondTriangle();
    // 一番遠い点に4点目の座標を入れる
    x[farPoint] = x[3];
    y[farPoint] = y[3];
    // 重心を出す
    SecondCenterOfGravity(g_x, g_y);
    // 複数の三角形を描画
    SecondTriangles(x, y);
  }

  // コンソール表示
  //if (frameCount % 30 == 0) {
  //  println("\n" + "click: " + click );
  //  for ( int i = 0; i < x.length; i++ )
  //    println( "x" + i + ": " + x[i] + " y" + i + ": " + y[i] );
  //  for ( int i = 0; i < x_s.length; i++ )
  //    println( "x_s" + i + ": " + x_s[i] + " y_s" + i + ": " + y_s[i] );

  //  println( "max: " + max);
  //  println( "farPoint: " + farPoint );
  //  println( "d1:" + d1 + " d2: " + d2 + " d3: " + d3 );
  //  println( "g_x: " + g_x + " g_y: " + g_y );
  //  for( int i = 0; i < vx.length; i++ )
  //     println( "vx" + i  +": " + vx[i] + " vy" + i + ": " + vy[i] );
  //}
}

void mousePressed() {
  // 最初の3点を点で描画し、x,y配列にマウス座標を入れる
  if (click < 4 && first ) {
    strokeWeight(5);
    stroke(255, 0, 0);
    beginShape(POINTS);
    x[click] = mouseX;
    y[click] = mouseY;
    vertex(x[click], y[click]);
    endShape();
  } else {
    // x,y配列にマウス座標を入れる
    x[click] = mouseX;
    y[click] = mouseY;
  }
}

void mouseReleased() {
  click++;
}

void keyPressed() {
  switch(key) {
    case 'c':
      background(255);
      click = 0;
      x   = new int[4];
      y   = new int[4];
      x_s = new int[4];
      y_s = new int[4];
      vx  = new int[4];
      vy  = new int[4];
      d1 = d2 = d3 = 0;
      max       = 0;
      farPoint  = 0;
      g_x = g_y = 0;
      first = true;
      ratio = n;
      break;
  }
}

// 各頂点と4点目の距離を出し、一番遠い点の配列番号を返す
int distance(int[] x, int[] y) {
  for (int i = 0; i < x.length-1; i++) {
    switch(i) {
    case 0:
      d1 = (int)dist( x[i], y[i], x[3], y[3] );
      break;
    case 1:
      d2 = (int)dist( x[i], y[i], x[3], y[3] );
      break;
    case 2:
      d3 = (int)dist( x[i], y[i], x[3], y[3] );
      max = Math.max(d1, d2);
      max = Math.max(max, d3);
      for (int n = 0; n < x.length-1; n++) {
        if (max == d1) {
          return 0;
        } else if (max == d2) {
          return 1;
        } else if (max == d3) {
          return 2;
        }
      }
      break;
    }
  }
  return 0;
}

// (最初)各頂点と重心とのベクトル計算
void centerOfGravity( int g_x, int g_y ) {
  for ( int i = 0; i < x.length; i++ ) {
    switch( i ) {
    case 0:
      vx[i] = x[i] - g_x;
      vy[i] = y[i] - g_y;
      break;
    case 1:
      vx[i] = x[i] - g_x;
      vy[i] = y[i] - g_y;
      break;
    case 2:
      vx[i] = x[i] - g_x;
      vy[i] = y[i] - g_y;
      break;
    }
  }
}

// (2つ目以降)各頂点と重心とのベクトル計算
void SecondCenterOfGravity( int g_x, int g_y ) {
  for ( int i = 0; i < x.length; i++ ) {
    if (i != farPoint) {
      switch( i ) {
      case 0:
        vx[i] = x[i] - g_x;
        vy[i] = y[i] - g_y;
        break;
      case 1:
        vx[i] = x[i] - g_x;
        vy[i] = y[i] - g_y;
        break;
      case 2:
        vx[i] = x[i] - g_x;
        vy[i] = y[i] - g_y;
        break;
      case 3:
        vx[i] = x[i] - g_x;
        vy[i] = y[i] - g_y;
        break;
      }
    }
  }
}


// (最初)三角形の描画と重心を計算
void FirstTriangle() {
  beginShape(TRIANGLES);
  for (int i = 0; i < x.length-1; i++) {
    vertex(x[i], y[i]);
    g_x += x[i];
    g_y += y[i];
  }
  g_x /= 3;
  g_y /= 3;
  endShape(CLOSE);
}

// (2つ目以降)三角形描画と重心計算
void SecondTriangle() {
  beginShape(TRIANGLES);
  for (int i = 0; i < x.length; i++) {
    if (i != farPoint ) {
      vertex(x[i], y[i]);
      g_x += x[i];
      g_y += y[i];
    }
  }
  g_x /= 3;
  g_y /= 3;
  endShape();
}

// (最初)複数の三角形を描画する
void FirstTriangles( int[] x, int[] y ) {
  x_s = copyArrayX(x);
  y_s = copyArrayY(y);
  while (true) {
    if ( ratio < 0.0 ) break;
    // 線の色を毎回変える場合
    //stroke( random( 0,255 ), random( 0,255 ), random( 0,255 ), 150 );

    beginShape(TRIANGLES);
    for ( int i = 0; i < x_s.length-1; i++ ) {
      x_s[i] = (int)( vx[i] * ratio ) + g_x;
      y_s[i] = (int)( vy[i] * ratio ) + g_y;
      vertex( x_s[i], y_s[i] );
    }
    endShape( CLOSE );
    ratio -= diff;
  }
}

// (2つ目以降)複数の三角形を描画する
void SecondTriangles( int[] x, int[] y ) {
  x_s = copyArrayX(x);
  y_s = copyArrayY(y);
  while (true) {
    if ( ratio < 0.0 ) break;
    // 線の色を毎回変える場合
    //stroke( random( 0,255 ), random( 0,255 ), random( 0,255 ), 150 );

    beginShape(TRIANGLES);
    for ( int i = 0; i < x_s.length; i++ ) {
      if (i != farPoint) {
        x_s[i] = (int)( vx[i] * ratio ) + g_x;
        y_s[i] = (int)( vy[i] * ratio ) + g_y;
        vertex( x_s[i], y_s[i] );
      }
    }
    endShape( CLOSE );
    ratio -= diff;
  }
}

// 配列コピー(X)
int[] copyArrayX(int[] x) {
  for (int i = 0; i < x.length; i++)
    x_s[i] = x[i];
  return x_s;
}

// 配列コピー(Y)
int[] copyArrayY(int[] y) {
  for (int i = 0; i < y.length; i++)
    y_s[i] = y[i];
  return y_s;
}
