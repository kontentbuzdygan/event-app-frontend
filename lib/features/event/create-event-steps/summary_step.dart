import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";

class SummaryStep extends StatefulWidget {
  const SummaryStep({
    super.key,
    required this.formKey,
    required this.title,
    required this.description,
    required this.address,
    required this.startsAt,
    required this.endsAt,
  });

  final GlobalKey<FormBuilderState> formKey;
  final String title, description, address, startsAt;
  final String? endsAt;

  @override
  State<SummaryStep> createState() => _State();
}

class _State extends State<SummaryStep> {
  final initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          Text("Title: ${widget.title}"),
          Text("Description: ${widget.description}"),
          Text("Address: ${widget.address}"),
          Text("Start date: ${widget.startsAt}"),
          Text(
            widget.endsAt != ""
                ? "End date: ${widget.endsAt!}"
                : "No finishing date was chosen.",
          ),
        ],
      ),
    );
  }
}
