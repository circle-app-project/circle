import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EditableAvatar extends StatelessWidget {
  final VoidCallback onEditPressed;
  final String imagePath;
  final double? radius;
  const EditableAvatar(
      {super.key,
      required this.onEditPressed,
      required this.imagePath,
      this.radius});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        CircleAvatar(
          radius: radius ?? 64,
          backgroundImage:  NetworkImage(imagePath),///Todo: replace with cached network image eventually
          backgroundColor: theme.colorScheme.surfaceContainerLow,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton.filled(
              color: theme.colorScheme.onSurface,
              onPressed: onEditPressed,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.onSurface),
              icon:  Icon(
                HugeIcons.strokeRoundedPencilEdit02,
                color: theme.colorScheme.onSurface
              )),
        )
      ],
    );
  }
}
