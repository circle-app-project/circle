import 'package:circle/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:springster/springster.dart';

enum SelectableCircularButtonMode { small, medium }
class SelectableCircularButton extends StatefulWidget implements SelectableWidget{
  const SelectableCircularButton({
    super.key,
    this.iconPath,
    this.color,
    this.backgroundColor,
    this.label,
    this.icon,
    this.size = const Size.square(72),
    this.child,
    required this.onPressed,
    required this.isItemSelected,
  });
  final String? label;
  final bool isItemSelected;
  final String? iconPath;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? color;
  final VoidCallback onPressed;
  final Size size;
  final Widget? child;

  @override
  State<SelectableCircularButton> createState() => _SelectableCircularButtonState();

  @override
  bool get isSelected => isItemSelected;

  @override
  VoidCallback get onSelected => onPressed;
}

class _SelectableCircularButtonState extends State<SelectableCircularButton> with SingleTickerProviderStateMixin{
  late final AnimationController animationController;
  late final Animation<double> _radiusAnimation;


  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: 300.ms);
    _radiusAnimation = Tween<double>(begin: 36, end: 20).animate(
        CurvedAnimation(parent: animationController, curve: Spring.defaultIOS.toCurve));

    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _radiusAnimation,
          builder: (context, child) {
            return InkWell(
              onTapDown: (TapDownDetails tapDownDetails) {
                animationController.forward();
              },
              onTapUp: (TapUpDetails tapUpDetails) {
                ///Todo: Refactor this to use Spring animations
                animationController.reverse(from: 1.0);
              },
              onTap: widget.onPressed,
              splashColor: widget.color?.withValues(alpha: .2) ??  theme.colorScheme.primary.withValues(alpha: .2),
              //splashColor: Colors.transparent,
              splashFactory: InkSparkle.splashFactory,
              borderRadius: BorderRadius.circular(_radiusAnimation.value),
              child: Ink(
                height: widget.size.height,
                width: widget.size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(_radiusAnimation.value),
                  color: widget.isItemSelected ? theme.colorScheme.primary : widget.backgroundColor ?? theme.colorScheme.surfaceContainerLow,
                ),
                child: Center(
                  child: widget.child?? AppIcon(
                    size: 24,
                    color: widget.color ?? (widget.isSelected? Colors.white : theme.colorScheme.onSurface),
                    iconPath: widget.iconPath,
                    icon: widget.icon,
                  )
                ),
              ),
            );
          },
        ),
        const Gap(8),
        if(widget.label !=null)
        Text(
          widget.label!,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: .7)),
        )
      ],
    );
  }
}

