
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

extension SizeBox on double {
  SizedBox get widthBox {
    return SizedBox(
      width: this,
    );
  }

  SizedBox get heightBox {
    return SizedBox(
      height: this,
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    var renderObject = currentContext?.findRenderObject();
    var matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      var rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension CancelableFutureExtension<T> on Future<T> {
  static CancelableOperation? _currentOperation;

  Future<T> asCancelableOperation() async {
    _currentOperation?.cancel();
    _currentOperation = CancelableOperation.fromFuture(this);
    try {
      T result = await _currentOperation!.value;
      _currentOperation = null;
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
