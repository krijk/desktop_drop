// ignore_for_file: always_specify_types
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> list = <String>[
    'path0',
    'path1',
    'path2',
    'path3',
    'path4',
  ];

  ExampleDragTarget dragTarget = const ExampleDragTarget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _listHeader(),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (BuildContext context, int index) {
                          if (index >= list.length) {
                            final List<String> toAdd = <String>[];
                            final int idxFr = list.length;
                            final int idxTo = idxFr + 4;
                            for (int i = idxFr; i < idxTo; i++) {
                              final String msg = 'path$i';
                              toAdd.add(msg);
                            }
                            list.addAll(toAdd);
                          }
                          return _listItem('state', list[index]);
                          // return _menuItem(list[index], 'unknown');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: ExampleDragTarget(),
              ),
            ],
          );
        },
      ),
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
                child: Text('Path', style: TextStyle(fontWeight: FontWeight.bold)),),
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
                title,
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

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  _ExampleDragTargetState createState() => _ExampleDragTargetState();

  void onClear1() {}
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {
  // file list
  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  /// Mime
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (DropDoneDetails detail) async {
        setState(() {
          _list.addAll(detail.files);
        });

        debugPrint('onDragDone:');
        for (final XFile file in detail.files) {
          debugPrint('  ${file.path} ${file.name}'
              '  ${await file.lastModified()}'
              '  ${await file.length()}'
              '  ${file.mimeType}',);
        }
      },
      onDragUpdated: (DropEventDetails details) {
        setState(() {
          offset = details.localPosition;
        });
      },
      onDragEntered: (DropEventDetails detail) {
        setState(() {
          _dragging = true;
          offset = detail.localPosition;
        });
      },
      onDragExited: (DropEventDetails detail) {
        setState(() {
          _dragging = false;
          offset = null;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
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

  Widget _contents(){
    if (_list.isEmpty) {
      return const Center(child: Text('Drop here'));
    }

    return Text(_list.map((XFile e) => Uri.decodeFull(e.path)).join('\n'));
  }

}
