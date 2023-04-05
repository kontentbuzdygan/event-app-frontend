import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:form_builder_validators/form_builder_validators.dart";
import "package:intl/intl.dart";

class TimePlaceStep extends StatefulWidget {
  const TimePlaceStep({
    super.key,
    required this.formKey,
    required this.adressController,
    required this.startsAtController,
    required this.endsAtController,
  });

  final TextEditingController adressController;
  final TextEditingController startsAtController;
  final TextEditingController endsAtController;
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<TimePlaceStep> createState() => _State();
}

class _State extends State<TimePlaceStep> {
  final initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            validator:
                FormBuilderValidators.required(errorText: l10n.addressInput),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l10n.addressExample,
              labelText: l10n.address,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderDateTimePicker(
            name: "startsAt",
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.startsAtController,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            firstDate: DateTime.now(),
            initialValue: DateTime.now(),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            inputType: InputType.both,
            initialTime: const TimeOfDay(hour: 18, minute: 0),
            decoration: InputDecoration(
              labelText: l10n.startsAt,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderDateTimePicker(
            name: "endsAt",
            controller: widget.endsAtController,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            firstDate: DateTime.now(),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            inputType: InputType.both,
            initialTime: const TimeOfDay(hour: 18, minute: 0),
            validator: FormBuilderValidators.compose([
              (value) {
                if (value == null) {
                  return null;
                }
                if (value.compareTo(widget.formKey.currentState!
                        .fields["startsAt"]!.value as DateTime) <
                    0) {
                  return l10n.endDateCantBeSoonerThanStart;
                }
                return null;
              }
            ]),
            decoration: InputDecoration(
              labelText: l10n.endsAt,
              suffixIcon: IconButton(
                icon: const Icon(Icons.close_outlined),
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
