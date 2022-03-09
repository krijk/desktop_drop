// ignore_for_file: always_specify_types
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';

import 'data.dart';

late Data data;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Audio Creator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    data = Data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              _listHeader(),
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: Data.list.length,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (BuildContext context, int index) {
                        return _listItem('state', Data.getFilePath(index));
                        // return _menuItem(list[index], 'unknown');
                      },
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: DragDropTarget(
                        update: onUpdate,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        },
      ),
      floatingActionButton: _SpeedDial(state: this),
    );
  }

  Widget _listHeader() {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 2.0, color: Colors.grey))),
      child: ListTile(
        title: Row(
          children: const <Widget>[
            Expanded(child: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
            Expanded(
              flex: 3,
              child: Text('Path', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItem(String state, String title) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 2.0, color: Colors.grey))),
      child: ListTile(
        title: Row(
          children: <Widget>[
            Expanded(child: Text(state)),
            Expanded(
              flex: 3,
              child: Text(
                Uri.decodeFull(title),
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
        onTap: () {},
        onLongPress: () {},
      ),
    );
  }

  void onUpdate(int val) {
    setState(() {});
  }

  void onDelete(){
    setState(() {
      Data.clear();
    });
  }
}

class DragDropTarget extends StatefulWidget {
  final ValueChanged<int> update;

  const DragDropTarget({Key? key, required this.update}) : super(key: key);

  @override
  _DragDropTargetState createState() => _DragDropTargetState();

  void onClear1() {}
}

class _DragDropTargetState extends State<DragDropTarget> {
  // file list
  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  /// Mime
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails details) async {
        setState(() {
          for (final XFile file in details.files) {
            Data.append(file);
          }
        });

        widget.update(0);

        debugPrint('onDragDone:');
        for (final XFile file in details.files) {
          debugPrint(
            '${Uri.decodeFull(file.path)} '
            ' ${Uri.decodeFull(file.name)}'
            // ' ${await file.lastModified()}'
            // ' ${await file.length()}'
            ' ${file.mimeType}',
          );
        }
      },
      onDragUpdated: (DropEventDetails details) {
        setState(() {
          // offset = details.localPosition;
        });
      },
      onDragEntered: (DropEventDetails detail) {
        setState(() {
          _dragging = true;
          // offset = detail.localPosition;
        });
      },
      onDragExited: (DropEventDetails detail) {
        setState(() {
          _dragging = false;
          // offset = null;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.transparent,
        child: Stack(
          children: [
            _contents(),
            if (offset != null)
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '$offset',
                  style: Theme.of(context).textTheme.caption,
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _contents() {
    if (_list.isEmpty) {
      return const Center(child: Text(''));
    }

    return Text(_list.map((XFile e) => Uri.decodeFull(e.path)).join('\n'));
  }
}


class _SpeedDial extends StatelessWidget {
  static const Color kDarkBlue = Color(0xFF1565C0);

  final _MyHomePageState state;

  const _SpeedDial({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      overlayColor: Colors.transparent,
      overlayOpacity: 0.0,
      backgroundColor: kDarkBlue,
      foregroundColor: Colors.white,
      // closeManually: true,
      // curve: Curves.fastOutSlowIn,
      activeIcon: Icons.close,
      icon: Icons.menu,
      children: <SpeedDialChild>[
        SpeedDialChild(
          label: 'Delete',
          labelBackgroundColor: Colors.white30,
          child: const Icon(Icons.delete),
          backgroundColor: Colors.red,
          onTap: state.onDelete,
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}
