// import "package:event_app/api/models/event.dart";
import "package:flutter/material.dart";
// import "package:intl/intl.dart";

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _State();
}

class _State extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;
  int id = 0, authorId = 0;
  String title = "", description = "";
  DateTime startsAt = DateTime.now();
  DateTime? endsAt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event creation"),
      ),
      body: Container(
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepCancel: () => currentStep == 0
              ? null
              : setState(() {
                  currentStep -= 1;
                }),
          onStepContinue: () {
            bool isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              //TODO: send event to backend
              return;
            }
            setState(() {
              currentStep += 1;
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

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        title: const Text("Description"),
        content: Column(
          children: [
            TextFormField(
              maxLength: 50,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a title";
                }
                return null;
              },
              onChanged: (value) {
                title = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Sleepover at Mickey's",
                labelText: "Enter event title",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 5,
              maxLength: 1000,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a description";
                }
                return null;
              },
              onChanged: (value) {
                description = value;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Third edition of coding event app together!",
                labelText: "Enter event description",
              ),
            )
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        title: const Text("Time & Place"),
        content: Column(
          children: [
            // Location picker
            // Date picker
          ],
        ),
      )
    ];
  }
}
