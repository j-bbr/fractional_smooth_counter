import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/widgets.dart';

/// A wheel of digits.
class CounterWheel extends StatefulWidget {
  const CounterWheel({
    super.key,
    this.textStyle,
    required this.digits,
    required this.duration,
    required this.curve,
    this.fadeEdges = true,
    required this.itemIndex,
    required this.animateOnInit,
  });

  final bool fadeEdges;

  /// The text style of the counter.
  /// If null, the default text style will be used.
  final TextStyle? textStyle;

  /// The number of digits of the counter.
  final int digits;

  /// The duration of the wheel animation.
  final Duration duration;

  /// The curve of the wheel animation.
  final Curve curve;

  /// The index of the item to be selected.
  final int itemIndex;

  /// Whether the wheel should animate on init.
  final bool animateOnInit;

  @override
  State<CounterWheel> createState() => _CounterWheelState();
}

class _CounterWheelState extends State<CounterWheel> {
  late final controller = FixedExtentScrollController(
    initialItem: widget.animateOnInit ? 0 : widget.itemIndex,
  );
  late bool initialized = widget.digits == 1 || !widget.animateOnInit;
  int? selectedItem;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.hasClients && selectedItem != widget.itemIndex) {
        selectedItem = widget.itemIndex;
        await controller.animateToItem(
          widget.itemIndex,
          duration: widget.duration,
          curve: widget.curve,
        );
        initialized = true;
      }
    });

    return LayoutBuilder(
      builder: (_, constraints) {
        final scrollWheel = ListWheelScrollView.useDelegate(
          itemExtent: constraints.maxHeight,
          controller: controller,
          physics: const FixedExtentScrollPhysics(),
          useMagnifier: true,
          childDelegate: _CounterWheelChildLoopingListDelegate(
            skipFirstItem: !initialized,
            children: List.generate(
              10,
              (i) => Text(i.toString(), style: widget.textStyle),
            ),
          ),
        );
        if (!widget.fadeEdges) {
          return scrollWheel;
        }
        return FadingEdgeScrollView.fromListWheelScrollView(
            gradientFractionOnStart: 0.3,
            gradientFractionOnEnd: 0.3,
            child: scrollWheel);
      },
    );
  }
}

class _CounterWheelChildLoopingListDelegate
    extends ListWheelChildLoopingListDelegate {
  _CounterWheelChildLoopingListDelegate({
    this.skipFirstItem = true,
    required super.children,
  });

  late final List<Widget> reversedChildren = [
    children[0],
    ...children.skip(1).toList().reversed,
  ];
  final bool skipFirstItem;

  @override
  Widget? build(BuildContext context, int index) {
    if (children.isEmpty || (index == 0 && skipFirstItem)) {
      return const SizedBox.shrink();
    }
    final list = index.isNegative ? reversedChildren : children;
    return IndexedSemantics(index: index, child: list[index % children.length]);
  }
}
