
import 'package:flutter/material.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class DialogCustom extends StatelessWidget {
  final Key keyConfirm;
  final Widget child;
  final VoidCallback onDismissed;
  final String confirmTitle;
  final String confirmContent;
  final String cancelText;
  final String confirmText;
  final IconData icon;

  const DialogCustom({
    required this.keyConfirm,
    required this.child,
    required this.onDismissed,
    this.confirmTitle = "",
    this.confirmContent = "",
    this.cancelText = "",
    this.confirmText = "",
    this.icon = Icons.delete,
  }) : super(key: keyConfirm);

  @override
  Widget build(BuildContext context) {

    return Dismissible(
      key: keyConfirm,
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(confirmTitle),
              content: Text(confirmContent),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancelText),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(confirmText,
                    style: const TextStyle(color: UtilColors.colorBlack),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(
        color: UtilColors.colorWhite70,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          size: 29.0,
          icon,
        ),
      ),
      child: child,
    );
  }
}
