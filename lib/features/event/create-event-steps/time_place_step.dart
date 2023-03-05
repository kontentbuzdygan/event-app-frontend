import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:intl/intl.dart";

class TimePlaceStep extends StatefulWidget {
  const TimePlaceStep({
    super.key,
    required this.formKey,
    required this.adressController,
    required this.startDateController,
    required this.endDateController,
  });

  final TextEditingController adressController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
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
            name: "startsAt",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.startDateController,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            firstDate: DateTime.now(),
            initialValue: DateTime.now(),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            inputType: InputType.both,
            initialTime: const TimeOfDay(hour: 18, minute: 0),
            decoration: const InputDecoration(
              labelText: "Start time",
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderDateTimePicker(
            name: "endsAt",
            controller: widget.endDateController,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            firstDate: DateTime.now(),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            inputType: InputType.both,
            initialTime: const TimeOfDay(hour: 18, minute: 0),
            validator: (value) {
              if (value == null) {
                return null;
              }
              if (value.compareTo(
                    widget.formKey.currentState!.fields["startsAt"]!.value
                        as DateTime,
                  ) <
                  0) {
                return "The end date cannot be earlier than the start date.";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "End time (optional)",
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.formKey.currentState!.fields["endsAt"]
                      ?.didChange(null);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
