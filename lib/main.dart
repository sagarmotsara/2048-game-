import 'package:flutter/material.dart';
import 'package:two048_game/board.dart';
import 'colortile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 game example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('2048', style: TextStyle(color: Colors.white),), backgroundColor: Colors.amber,),
        body: BoardWidget(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _BoardWidgetState state;

  const MyHomePage({this.state});

  @override
  Widget build(BuildContext context) {
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding) /
        state.column;

    List<TileBox> backgroundBox = List<TileBox>();
    for (int r = 0; r < state.row; ++r) {
      for (int c = 0; c < state.column; ++c) {
        TileBox tile = TileBox(
          left: c * width * state.tilePadding * (c + 1),
          top: r * width * state.tilePadding * (r + 1),
          size: width,
        );
        backgroundBox.add(tile);
      }
    }

    return Positioned(
      left: 0.0,
      top: 0.0,
      child: Container(
        width: state.boardSize().width,
        height: state.boardSize().width,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(6.0)),
        child: Stack(
          children: backgroundBox,
        ),
      ),
    );
  }
}
class BoardWidget extends StatefulWidget {
  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Board _board;
  int row;
  int column;

  bool _isMoving;
  bool gameOver;
  double tilePadding = 5.0;
  MediaQueryData _queryData;
  
  @override
  void initState() {
    super.initState();

    row = 4;
    column = 4;
    _isMoving = false;
    gameOver = false;

    _board = Board(row, column);
    newGame();
  }

  void newGame() {
    setState(() {
      _board.initBoard();
      gameOver = false;
    });
  }

  void gameover() {
    setState(() {
      if (_board.gameOver()) {
        gameOver = true;
      }
    });
  }

  Size boardSize() {
    Size size = _queryData.size;
    return Size(size.width, size.width);

   }
      AlertDialog dialogue = new AlertDialog(
        content: new Text("HOW TO PLAY: Use your arrow keys to move the tiles. Tiles with the same number merge into one when they touch. Add them up to reach 2048!", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
       backgroundColor: Colors.yellow,
      );
    



  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);
    List<TileWidget> _tileWidgets = List<TileWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _tileWidgets.add(TileWidget(tile: _board.getTile(r, c), state: this));
      }
    }
    List<Widget> children = List<Widget>();

    children.add(MyHomePage(state: this));
    children.addAll(_tileWidgets);

    return SingleChildScrollView(
      child: Column(
    children: <Widget>[
     
      Container(
      padding: EdgeInsets.only(top:10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
            ),

            Container(
              color: Colors.yellow,
              width: 120.0,
              height: 80.0,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.graphic_eq),
                  Text("Score: "), Text("${_board.score}")],
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
            ),
            FlatButton(
              child: Container(
                width: 90.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    color: Colors.orange[100]),
                child: Center(
                  child: Text("New Game"),
                ),
              ),
              onPressed: () {
                newGame();
              },
            ),
            FlatButton(
                          child: Container(
                  width: 90.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      color: Colors.orange[100]),
                  child: Center(
                    child: Text("Instructions"),
                  ),
                  
                ),
                onPressed: () => showDialog(context: context, builder: (BuildContext context){
                  return dialogue;
                }),
            ),
          ],
        ),
      ),
     
      Container(
          height: 40.0,
          child: Opacity(
            opacity: gameOver ? 1.0 : 0.0,
            child: Center(
              child: Text('Game Over: Your Score is ${_board.score}', style: TextStyle(fontSize: 20),),
            ),
          )),
      Container(
        width: _queryData.size.width,
        height: _queryData.size.width,
        child: GestureDetector(
          onVerticalDragUpdate: (detail) {
            if (detail.delta.distance == 0 || _isMoving) {
              return;
            }
            _isMoving = true;
            if (detail.delta.direction > 0) {
              setState(() {
                _board.moveDown();
                gameover();
              });
            } else {
              setState(() {
                _board.moveUp();
                gameover();
              });
            }
          },
          onVerticalDragEnd: (d) {
            _isMoving = false;
          },
          onVerticalDragCancel: () {
            _isMoving = false;
          },
          onHorizontalDragUpdate: (d) {
            if (d.delta.distance == 0 || _isMoving) {
              return;
            }
            _isMoving = true;
            if (d.delta.direction > 0) {
              setState(() {
                _board.moveLeft();
                gameover();
              });
            } else {
              setState(() {
                _board.moveRight();
                gameover();
              });
            }
          },
          onHorizontalDragEnd: (d) {
            _isMoving = false;
          },
          onHorizontalDragCancel: () {
            _isMoving = false;
          },
          child: Stack(
            children: children,
          ),
        ),
      ),
      Padding(padding:EdgeInsets.only(bottom:5)),
      Container(
          padding: EdgeInsets.only(bottom: 20, top: 20, left: 225),
          color: Colors.lime[100],
          height: 100,
          width: 400,
        
          child: Text("By Sagar Motsara", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontStyle:FontStyle.italic)),
        ),
       
    ],
        ),
      );
  }
}

class TileWidget extends StatefulWidget {
  final Tile tile;
  final _BoardWidgetState state;

  const TileWidget({Key key, this.tile, this.state}) : super(key: key);
  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    widget.tile.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.isNew && !widget.tile.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.tile.isNew = false;
    } else {
      controller.animateTo(1.0);
    }

    return AnimatedTileWidget(
      tile: widget.tile,
      state: widget.state,
      animation: animation,
    );
  }
}

class AnimatedTileWidget extends AnimatedWidget {
  final Tile tile;
  final _BoardWidgetState state;

  AnimatedTileWidget({
    Key key,
    this.tile,
    this.state,
    Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.tilePadding) /
        state.column;

    if (tile.value == 0) {
      return Container();
    } else {
      return TileBox(
        left: (tile.column * width + state.tilePadding * (tile.column + 1)) +
            width / 2 * (1 - animationValue),
        top: tile.row * width +
            state.tilePadding * (tile.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: tileColors.containsKey(tile.value)
            ? tileColors[tile.value]
            : Colors.orange[50],
        text: Text('${tile.value}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),),
      );
    }
  }
}

class TileBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;

  const TileBox({
    Key key,
    this.left,
    this.top,
    this.size,
    this.color,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(

        width: size,
        height: size,
        
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        
        child: Center(
          child: text,
        ),
      ),
    );
    
  }
}
