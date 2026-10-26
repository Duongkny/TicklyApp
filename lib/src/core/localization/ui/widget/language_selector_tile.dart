import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../extensions/context.dart';
import '../../bloc/localization_bloc.dart';
import '../../bloc/localization_event.dart';
import '../../model/language.dart';

class LanguageSelectorTile extends StatelessWidget {
  const LanguageSelectorTile({super.key});
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<LocalizationBloc>();
    final selected = bloc.state.selectedLanguage;
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(context.loc.languageTitle),
      subtitle: Text(selected.text),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final language = await showModalBottomSheet<Language>(
          context: context,
          showDragHandle: true,
          builder: (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    context.loc.languageTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                for (final language in Language.values)
                  ListTile(
                    title: Text(language.text),
                    selected: language == selected,
                    trailing: language == selected
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: () => Navigator.pop(context, language),
                  ),
              ],
            ),
          ),
        );
        if (language != null && context.mounted) {
          bloc.add(ChangeLanguage(selectedLanguage: language));
        }
      },
    );
  }
}
