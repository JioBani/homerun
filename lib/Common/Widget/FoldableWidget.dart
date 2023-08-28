import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class FoldableWidgetKey{
  late final Function() setOpen;
  late final Function() setClose;
  late final Function() isOpen;
  final Function(bool isOpen)? onFoldStateChange;

  FoldableWidgetKey({this.onFoldStateChange});
}

class FoldableWidget extends StatefulWidget {
  FoldableWidget({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.title = const Text(""),
    this.subTitle = const Text(""),
    required this.child,
    this.margin,
    this.onFoldStageChange,
    this.foldableWidgetKey,
  });

  final Duration duration;
  final Widget title;
  final Widget subTitle;
  final Function(bool value)? onFoldStageChange;
  final Widget child;
  final EdgeInsets? margin;
  FoldableWidgetKey? foldableWidgetKey;

  @override
  State<FoldableWidget> createState() => _FoldableWidgetState();
}

class _FoldableWidgetState extends State<FoldableWidget> {

  bool _open = false;
  get open => _open;

  AnimateIconController controller = AnimateIconController();

  @override
  void initState() {
    super.initState();
    if(widget.foldableWidgetKey != null){
      widget.foldableWidgetKey!.setOpen = setOpen;
      widget.foldableWidgetKey!.setClose = setClose;
      widget.foldableWidgetKey!.isOpen = (){return _open;};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30.w, 20.w, 0, 20.w),
          margin: widget.margin ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              color: Colors.black45,
              width: 0.3,
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1.w,
                blurRadius: 2.w,
                offset: Offset(0, 2.w), // changes position of shadow
              )
            ]
          ),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.title,
                          SizedBox(height: 10.w,),
                          widget.subTitle
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: AnimateIcons(
                          startIcon: Icons.keyboard_arrow_down,
                          endIcon: Icons.keyboard_arrow_up,
                          size: 60.w,
                          controller: controller,
                          // add this tooltip for the start icon
                          startTooltip: 'Icons.add_circle',
                          // add this tooltip for the end icon
                          endTooltip: 'Icons.add_circle_outline',
                          endIconColor: Colors.black45,
                          startIconColor: Colors.black45,
                          onStartIconPress: () {
                            _setOpen();
                            return true;
                          },
                          onEndIconPress: () {
                            _setClose();
                            return true;
                          },
                          duration: widget.duration,
                          clockwise: false,
                        ),
                      ),
                    ],
                  )
              ),
              AnimatedClipRect(
                  open: _open,
                  horizontalAnimation: false,
                  verticalAnimation: true,
                  alignment: Alignment.center,
                  duration: widget.duration,
                  curve: Curves.easeInOutSine,
                  reverseCurve: Curves.easeInOutSine,
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          widget.child
                        ],
                      )
                  )
              ),
            ],
          ),
        ),
        SizedBox(
          height: _open ? 20.w : 0.5,
        )
      ],
    );
  }

  void _setOpen(){
    setState(() {
      _open = true;
      if(widget.onFoldStageChange != null) {
        widget.onFoldStageChange!(_open);
      }
      if(widget.foldableWidgetKey != null && widget.foldableWidgetKey!.onFoldStateChange != null){
        widget.foldableWidgetKey!.onFoldStateChange!(_open);
      }
    });
  }

  void setOpen(){
    setState(() {
      _open = true;
      if(widget.onFoldStageChange != null) {
        widget.onFoldStageChange!(_open);
      }
      controller.animateToStart();
      if(widget.foldableWidgetKey != null && widget.foldableWidgetKey!.onFoldStateChange != null){
        widget.foldableWidgetKey!.onFoldStateChange!(_open);
      }
    });
  }

  void _setClose(){
    setState(() {
      _open = false;
      if(widget.onFoldStageChange != null) {
        widget.onFoldStageChange!(_open);
      }
    });
  }

  void setClose(){
    _open = false;
    if(widget.onFoldStageChange != null) {
      widget.onFoldStageChange!(_open);
    }
    controller.animateToStart();
    StaticLogger.logger.i("setClose");

    if(widget.foldableWidgetKey != null && widget.foldableWidgetKey!.onFoldStateChange != null){
      widget.foldableWidgetKey!.onFoldStateChange!(_open);
    }

    setState(() {

    });
  }
}

class AnimatedClipRect extends StatefulWidget {
  @override
  _AnimatedClipRectState createState() => _AnimatedClipRectState();

  final Widget child;
  final bool open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;

  ///The behavior of the controller when [AccessibilityFeatures.disableAnimations] is true.
  final AnimationBehavior animationBehavior;

  const AnimatedClipRect({
    Key? key,
    required this.child,
    required this.open,
    this.horizontalAnimation = true,
    this.verticalAnimation = true,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.animationBehavior = AnimationBehavior.normal,
  }) : super(key: key);
}

class _AnimatedClipRectState extends State<AnimatedClipRect> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: widget.duration,
        reverseDuration: widget.reverseDuration ?? widget.duration,
        vsync: this,
        value: widget.open ? 1.0 : 0.0,
        animationBehavior: widget.animationBehavior);
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve ?? widget.curve,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open ? _animationController.forward() : _animationController.reverse();

    return ClipRect(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _animation.value : 1.0,
            widthFactor: widget.horizontalAnimation ? _animation.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}