import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DialogUtil {
  static void showCustomBottomSheet({
    required BuildContext context,
    required Widget content,
    required String title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                Center(child: content),
                const Gap(20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
