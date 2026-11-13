# desktop_drop

meld /home/sa/AndroidStudioFlutter/desktop_drop/lib /home/sa/AndroidStudioFlutter/desktop_drop-0.3.0_org/lib
Flutter 3.0.0 に Upした。以下のエラー発生
ERROR: ../../../.pub-cache/hosted/pub.dev/file-6.1.2/lib/src/interface/file.dart:15:16: Error: The method 'File.create' has fewer named arguments
dependency_overrides: file: ^7.0.0 と Overrideした

[![Pub](https://img.shields.io/pub/v/desktop_drop.svg)](https://pub.dev/packages/desktop_drop)

A plugin which allows user dragging files to your flutter desktop applications.

|         |            |
|---------|------------|
| Windows | ✅          |
| Linux   | ✅          |
| macOS   | ✅          |
| Android | ✅(preview) |
| Web     | ✅          |

## Getting Started

1. Add `desktop_drop` to your `pubspec.yaml`.

```yaml
  desktop_drop: $latest_version
```

2. Then you can use `DropTarget` to receive file drop events.

```dart
class ExmapleDragTarget extends StatefulWidget {
  const ExmapleDragTarget({Key? key}) : super(key: key);

  @override
  _ExmapleDragTargetState createState() => _ExmapleDragTargetState();
}

class _ExmapleDragTargetState extends State<ExmapleDragTarget> {
  final List<XFile> _list = [];

  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        setState(() {
          _list.addAll(detail.files);
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        height: 200,
        width: 200,
        color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
        child: _list.isEmpty
            ? const Center(child: Text("Drop here"))
            : Text(_list.join("\n")),
      ),
    );
  }
}

```

## LICENSE

see LICENSE file
