import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

class DescriptionStep extends StatefulWidget {
  const DescriptionStep({
    super.key,
    required this.descriptionController,
    required this.titleController,
  });

  final TextEditingController descriptionController;
  final TextEditingController titleController;

  @override
  State<DescriptionStep> createState() => _State();
}

class _State extends State<DescriptionStep> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            name: "dupa",
            controller: widget.titleController,
            maxLength: 50,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter a title";
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Sleepover at Mickey's",
              labelText: "Enter event title",
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.descriptionController,
            maxLines: 5,
            maxLength: 1000,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter a description";
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Third edition of coding event app together!",
              labelText: "Enter event description",
            ),
          ),
        ],
      ),
    );
  }
}
