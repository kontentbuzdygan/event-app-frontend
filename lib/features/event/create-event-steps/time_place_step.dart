import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:intl/intl.dart";

class TimePlaceStep extends StatefulWidget {
  const TimePlaceStep({
    super.key,
    required this.formKey,
    required this.adressController,
    required this.dateController,
  });

  final TextEditingController adressController;
  final TextEditingController dateController;
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<TimePlaceStep> createState() => _State();
}

class _State extends State<TimePlaceStep> {
  final initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            name: "address",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.adressController,
            maxLength: 50,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter an address";
              }
              return null;
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Podwale staromiejskie 69",
              labelText: "Enter address",
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderDateTimePicker(
            name: "date",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.dateController,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialValue: DateTime.now(),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            inputType: InputType.both,
            initialTime: const TimeOfDay(hour: 18, minute: 0),
            decoration: InputDecoration(
              labelText: "Start time",
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.formKey.currentState!.fields["date"]?.didChange(null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
