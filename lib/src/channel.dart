// ignore_for_file: always_specify_types
import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'drop_item.dart';
import 'events.dart';
import 'utils/platform.dart' if (dart.library.html) 'utils/platform_web.dart';

typedef RawDropListener = void Function(DropEvent);

class DesktopDrop {
  static const MethodChannel _channel = MethodChannel('desktop_drop');

  DesktopDrop._();

  static final DesktopDrop instance = DesktopDrop._();

  final Set<RawDropListener> _listeners = <RawDropListener>{};

  bool _inited = false;

  Offset? _offset;

  void init() {
    if (_inited) {
      return;
    }
    _inited = true;
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        return await _handleMethodChannel(call);
      } catch (e, s) {
        debugPrint('_handleMethodChannel: $e $s');
      }
    });
  }

  Future<void> _handleMethodChannel(MethodCall call) async {
    switch (call.method) {
      case 'entered':
        assert(_offset == null);
        final List<double> position = (call.arguments as List).cast<double>();
        _offset = Offset(position[0], position[1]);
        _notifyEvent(DropEnterEvent(location: _offset!));
        break;
      case 'updated':
        if (_offset == null && Platform.isLinux) {
          final List<double> position = (call.arguments as List).cast<double>();
          _offset = Offset(position[0], position[1]);
          _notifyEvent(DropEnterEvent(location: _offset!));
          return;
        }
        assert(_offset != null);
        final List<double> position = (call.arguments as List).cast<double>();
        _offset = Offset(position[0], position[1]);
        _notifyEvent(DropUpdateEvent(location: _offset!));
        break;
      case 'exited':
        assert(_offset != null);
        _notifyEvent(DropExitEvent(location: _offset ?? Offset.zero));
        _offset = null;
        break;
      case 'performOperation':
        assert(_offset != null);
        final List<String> paths = (call.arguments as List).cast<String>();
        _notifyEvent(
          DropDoneEvent(
            location: _offset ?? Offset.zero,
            files: paths.map((String e) => XFile(e)).toList(),
          ),
        );
        _offset = null;
        break;
      case 'performOperation_linux':
        // gtk notify 'exit' before 'performOperation'.
        assert(_offset == null);
        final String text = (call.arguments as List<dynamic>)[0] as String;
        final List<double> offset = ((call.arguments as List<dynamic>)[1] as List<dynamic>)
            .cast<double>();
        final Iterable<String> paths = const LineSplitter()
            .convert(text)
            .map((String e) => Uri.tryParse(e)?.path ?? '')
            .where((String e) => e.isNotEmpty);
        _notifyEvent(DropDoneEvent(
          location: Offset(offset[0], offset[1]),
          files: paths.map((String e) => XFile(e)).toList(),
        ),);
        break;
      case 'performOperation_web':
        assert(_offset != null);
        final List<XFile> results = (call.arguments as List)
            .cast<Map>()
            .map((Map e) => WebDropItem.fromJson(e.cast<String, dynamic>()))
            .map((WebDropItem e) => XFile(
                  e.uri,
                  name: e.name,
                  length: e.size,
                  lastModified: e.lastModified,
                  mimeType: e.type,
                ),)
            .toList();
        _notifyEvent(
          DropDoneEvent(location: _offset ?? Offset.zero, files: results),
        );
        _offset = null;
        break;
      default:
        throw UnimplementedError('${call.method} not implement.');
    }
  }

  void _notifyEvent(DropEvent event) {
    for (final RawDropListener listener in _listeners) {
      listener(event);
    }
  }

  void addRawDropEventListener(RawDropListener listener) {
    assert(!_listeners.contains(listener));
    _listeners.add(listener);
  }

  void removeRawDropEventListener(RawDropListener listener) {
    assert(_listeners.contains(listener));
    _listeners.remove(listener);
  }
}
