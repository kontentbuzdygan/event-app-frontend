import "package:event_app/api/models/event.dart";
import "package:event_app/features/event/create-event-steps/summary_step.dart";
import "package:event_app/features/event/create-event-steps/time_place_step.dart";
import "package:flutter/material.dart";
import "package:event_app/features/event/create-event-steps/description_step.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:fluttertoast/fluttertoast.dart";
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event creation"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
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
                endsAt: DateTime.parse(startsAtController.text),
              ).save();
              Fluttertoast.showToast(
                msg: "Event created!",
                backgroundColor: Colors.blue,
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
                  child: Text(currentStep == 0 ? "" : "Back"),
                ),
                const Spacer(),
                TextButton(
                  onPressed: details.onStepContinue,
                  child: Text(
                    currentStep == steps.length - 1 ? "Confirm" : "Next",
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Step> get steps => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          title: const Text("Description"),
          content: DescriptionStep(
            formKey: _formKeys[0],
            descriptionController: descriptionController,
            titleController: titleController,
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text("Time & Place"),
          content: TimePlaceStep(
            formKey: _formKeys[1],
            adressController: addressController,
            startsAtController: startsAtController,
            endsAtController: endsAtController,
          ),
        ),
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          title: const Text("Summary"),
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