import "package:flutter/material.dart";

showCustomDialog (context, VoidCallback onPressed) {
  showAdaptiveDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text("Save"),
        content: const Text("Do you want to save your predictions?\nNote: once saved cannot be changed!!"),
        actions: [
          TextButton(
            onPressed: onPressed, 
            child: const Text("Yes")
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            child: const Text("No")
          )
        ],
      );
    },
  );
}

showFullDialog(context) {
    showDialog(
      context: context, 
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ), 
    );
}