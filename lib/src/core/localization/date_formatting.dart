import 'package:flutter/material.dart';

String localizedDate(BuildContext context, DateTime value) =>
    MaterialLocalizations.of(context).formatShortDate(value.toLocal());
String localizedTime(BuildContext context, DateTime value) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(value.toLocal()),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
String localizedDateTime(BuildContext context, DateTime value) =>
    '${localizedDate(context, value)} · ${localizedTime(context, value)}';
