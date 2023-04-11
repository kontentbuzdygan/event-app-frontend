import "package:event_app/api/models/event_tag.dart";
import "package:event_app/features/events/tags/tag.dart";
import "package:flutter/material.dart";
import "package:flutter_form_builder/flutter_form_builder.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class SummaryStep extends StatefulWidget {
  const SummaryStep({
    super.key,
    required this.formKey,
    required this.title,
    required this.description,
    required this.address,
    required this.startsAt,
    required this.endsAt,
    required this.selectedTags,
  });

  final GlobalKey<FormBuilderState> formKey;
  final String title, description, address, startsAt;
  final String? endsAt;
  final List<EventTag> selectedTags;

  @override
  State<SummaryStep> createState() => _State();
}

class _State extends State<SummaryStep> {
  final initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          Text("${l10n.title}: ${widget.title}"),
          Text("${l10n.description}: ${widget.description}"),
          Text("${l10n.address}: ${widget.address}"),
          if (widget.startsAt != "") ...[
            Text(l10n.startsAtDate(DateTime.parse(widget.startsAt)))
          ],
          if (widget.endsAt != "") ...[
            Text(l10n.endsAtDate(DateTime.parse(widget.endsAt!))),
          ],
          ...widget.selectedTags.map((tag) => Tag(tag: tag)).toList(),
        ],
      ),
    );
  }
}
