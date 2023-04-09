import "package:event_app/api/models/event.dart";
import "package:event_app/features/events/create_event_steps/description_step.dart";
import "package:event_app/features/events/create_event_steps/summary_step.dart";
import "package:event_app/features/events/create_event_steps/time_place_step.dart";
import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _State();
}

class _State extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<GlobalKey<FormBuilderState>> _formKeys = [
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
    GlobalKey<FormBuilderState>(),
  ];

  late final AppLocalizations l10n = AppLocalizations.of(context)!;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final startsAtController = TextEditingController();
  final endsAtController = TextEditingController();

  int currentStep = 0;
  int id = 0;
  DateTime startsAt = DateTime.now();
  DateTime? endsAt;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.createEvent),
        ),
        body: FormBuilder(
          key: _formKey,
          child: Stepper(
            steps: steps,
            currentStep: currentStep,
            onStepCancel: () => currentStep == 0
                ? null
                : setState(() {
                    currentStep -= 1;
                    FocusScope.of(context).unfocus();
                  }),
            onStepContinue: () {
              FocusScope.of(context).unfocus();
              bool isLastStep = currentStep == steps.length - 1;
              if (isLastStep) {
                if (endsAtController.text.isEmpty) {
                  NewEvent(
                    title: titleController.text,
                    description: descriptionController.text,
                    startsAt: DateTime.parse(startsAtController.text),
                  ).save();
                  return;
                }
                NewEvent(
                  title: titleController.text,
                  description: descriptionController.text,
                  startsAt: DateTime.parse(startsAtController.text),
                  endsAt: DateTime.parse(endsAtController.text),
                ).save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.eventCreated),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.pop();
                return;
              }
              setState(() {
                if (_formKeys[currentStep].currentState!.saveAndValidate()) {
                  currentStep += 1;
                }
              });
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                children: <Widget>[
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(currentStep == 0 ? "" : l10n.back),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: details.onStepContinue,
                    child: Text(
                      currentStep == steps.length - 1
                          ? l10n.confirm
                          : l10n.next,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );

  List<Step> get steps => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          title: Text(l10n.description),
          content: DescriptionStep(
            formKey: _formKeys[0],
            descriptionController: descriptionController,
            titleController: titleController,
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          title: Text(l10n.timeAndPlace),
          content: TimePlaceStep(
            formKey: _formKeys[1],
            adressController: addressController,
            startsAtController: startsAtController,
            endsAtController: endsAtController,
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          title: Text(l10n.summary),
          content: SummaryStep(
            formKey: _formKeys[2],
            title: titleController.text,
            description: descriptionController.text,
            address: addressController.text,
            startsAt: startsAtController.text,
            endsAt: endsAtController.text,
          ),
        ),
      ];
}
