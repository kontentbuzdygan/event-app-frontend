import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

class TimePlaceStep extends StatefulWidget {
  const TimePlaceStep({
    super.key,
    required this.adressController,
    required this.dateController,
  });

  final TextEditingController adressController;
  final TextEditingController dateController;

  @override
  State<TimePlaceStep> createState() => _State();
}

class _State extends State<TimePlaceStep> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            name: "adress",
            controller: widget.adressController,
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
              hintText: "Podwale staromiejskie 69",
              labelText: "Enter adress",
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderDateTimePicker(
            name: "date",
            controller: widget.dateController,
            initialEntryMode: DatePickerEntryMode.calendar,
            initialValue: DateTime.now(),
            inputType: InputType.both,
            decoration: InputDecoration(
              labelText: "Appointment Time",
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _formKey.currentState!.fields["date"]?.didChange(null);
                },
              ),
            ),
            initialTime: const TimeOfDay(hour: 8, minute: 0),
          ),
        ],
      ),
    );
  }
}
