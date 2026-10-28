import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tickly/l10n/output/app_localization.dart';
import 'package:tickly/src/core/presentation/widget/input_field.dart';
import 'package:tickly/src/features/tasks/presentation/widgets/task_search_field.dart';

Widget app(Widget child, {String language = 'vi'}) => MaterialApp(
  locale: Locale(language),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  testWidgets(
    'Shared input preserves required validation, character limits and label',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        app(
          Form(
            key: form,
            child: InputField(
              controller: controller,
              maxLength: 5,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
          ),
        ),
      );
      expect(form.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), 'abcdef');
      expect(controller.text, 'abcde');
      expect(form.currentState!.validate(), isTrue);
      await tester.pump();
      expect(find.text('Required'), findsNothing);
      expect(find.text('Title'), findsOneWidget);
    },
  );

  testWidgets('Optional description accepts empty text and line breaks', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final form = GlobalKey<FormState>();
    await tester.pumpWidget(
      app(
        Form(
          key: form,
          child: InputField(
            controller: controller,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ),
      ),
    );
    expect(form.currentState!.validate(), isTrue);
    await tester.enterText(
      find.byType(TextFormField),
      'First line\nSecond line',
    );
    expect(controller.text, 'First line\nSecond line');
    expect(tester.widget<EditableText>(find.byType(EditableText)).maxLines, 4);
  });

  testWidgets(
    'Search retains localized clear action and syncs external query',
    (tester) async {
      String query = 'Study';
      late StateSetter update;
      await tester.pumpWidget(
        app(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TaskSearchField(
                query: query,
                onChanged: (value) => setState(() => query = value),
              );
            },
          ),
          language: 'en',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(InputField), findsOneWidget);
      final loc = lookupAppLocalizations(const Locale('en'));
      expect(find.byTooltip(loc.clearSearch), findsOneWidget);
      await tester.tap(find.byTooltip(loc.clearSearch));
      await tester.pump();
      expect(query, isEmpty);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        isEmpty,
      );
      expect(find.byTooltip(loc.clearSearch), findsNothing);
      update(() => query = 'Read');
      await tester.pump();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        'Read',
      );
      await tester.enterText(find.byType(TextFormField), 'New query');
      expect(query, 'New query');
    },
  );

  testWidgets(
    'Password remains obscured initially and disabled toggle cannot change it',
    (tester) async {
      final controller = TextEditingController(text: 'password123');
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        app(InputField.password(controller: controller, enabled: true)),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
      await tester.pumpWidget(
        app(InputField.password(controller: controller, enabled: false)),
      );
      expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed,
        isNull,
      );
    },
  );
}
