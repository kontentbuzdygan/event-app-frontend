// import "package:event_app/api/models/event.dart";
import "package:event_app/features/event/create-event-steps/time_place_step.dart";
import "package:flutter/material.dart";
import "package:event_app/features/event/create-event-steps/description_step.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

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
  ];

  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final adressController = TextEditingController();

  int currentStep = 0;
  int id = 0;
  DateTime startsAt = DateTime.now();
  DateTime? endsAt;

  @override
  Widget build(BuildContext context) {
    //final authState = context.watch<AuthState>();
    //authState.userToken!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event creation"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps,
          currentStep: currentStep,
          onStepCancel: () => currentStep == 0
              ? null
              : setState(() {
                  currentStep -= 1;
                }),
          onStepContinue: () {
            bool isLastStep = currentStep == getSteps.length - 1;
            if (isLastStep) {
              //TODO: send event to backend
              return;
            }
            setState(() {
              if (_formKeys[currentStep].currentState!.saveAndValidate()) {
                _formKey.currentState?.saveAndValidate();
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
                  child: const Text("Next"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Step> get getSteps => [
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
            adressController: adressController,
            dateController: dateController,
          ),
        ),
      ];
}
