import '../providers/checkpoint_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckPointCode extends StatelessWidget {
  final TextEditingController nameController;
  const CheckPointCode({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Consumer<CheckPointProvider>(
        builder: (context, nameProvider, child) => TextField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          controller: nameController,
          maxLength: 1,
          decoration: const InputDecoration(
              icon: Icon(
                Icons.tour,
                color: Color.fromARGB(255, 4, 0, 77),
              ),
              hintText: 'Type your Stall Code',
              hintStyle: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
              border: OutlineInputBorder()),
          onSubmitted: (_) {
            CheckPointProvider checkPointProvider =
                Provider.of<CheckPointProvider>(context, listen: false);
            checkPointProvider.changeId(_);
          },
        ),
      ),
    );
  }
}
