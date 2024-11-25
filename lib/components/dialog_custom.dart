
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
                    style: const TextStyle(color: ThemeColor.colorBlack),
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
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: ThemeColor.colorBlueTema,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Icon(
            size: 25.0,
            icon,
          ),
        ),
      ),
      child: child,
    );
  }
}
