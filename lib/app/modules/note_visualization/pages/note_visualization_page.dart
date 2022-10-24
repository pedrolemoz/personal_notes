import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unicons/unicons.dart';

import '../../../core/controllers/base/base_states.dart';
import '../../../core/models/note_model.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/datetime_extension.dart';
import '../../../core/utils/typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/decision_dialog.dart';
import '../../../core/widgets/disable_splash.dart';
import '../../notes_listing/controllers/notes_listing_bloc.dart';
import '../../notes_listing/controllers/notes_listing_events.dart';
import '../controllers/note_visualization_bloc.dart';
import '../controllers/note_visualization_events.dart';
import '../controllers/note_visualization_states.dart';

class NoteVisualizationPage extends StatefulWidget {
  final NoteModel noteModel;

  const NoteVisualizationPage({super.key, required this.noteModel});

  @override
  State<NoteVisualizationPage> createState() => _NoteVisualizationPageState();
}

class _NoteVisualizationPageState extends State<NoteVisualizationPage> {
  final noteVisualizationBloc = Modular.get<NoteVisualizationBloc>();
  final notesListingBloc = Modular.get<NoteListingBloc>();

  @override
  void initState() {
    noteVisualizationBloc.add(UpdateCurrentNoteInVisualizationBloc(noteModel: widget.noteModel));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteVisualizationBloc, AppState>(
      bloc: noteVisualizationBloc,
      listener: (context, state) {
        if (state is SuccessfullyDeletedCurrentNoteState) {
          notesListingBloc.add(const RefreshAllNotes());
          Modular.to.popUntil(ModalRoute.withName('/notes_listing/'));
        }

        if (state is ErrorState) {
          final errorSnackBar = SnackBar(
            backgroundColor: AppColors.red,
            content: Text(
              'Não foi possível excluir a nota',
              style: AppTypography.textHeadline(color: AppColors.lightGray1),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        }
      },
      builder: (context, state) {
        if (state is InitialState || state is UpdateCurrentNoteInVisualizationBloc) return const SizedBox();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => Modular.to.pushNamed('/note_creation/', arguments: noteVisualizationBloc.noteModel),
            child: const Icon(
              UniconsLine.pen,
              size: 28,
              color: AppColors.white,
            ),
          ),
          appBar: AppBar(
            title: Text(noteVisualizationBloc.noteModel.title),
            automaticallyImplyLeading: false,
            leading: IconButton(
              tooltip: 'Voltar',
              splashRadius: 24,
              onPressed: () => Modular.to.maybePop(),
              icon: const Icon(
                UniconsLine.arrow_left,
                size: 28,
              ),
            ),
          ),
          body: DisableSplash(
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Text(
                  noteVisualizationBloc.noteModel.content,
                  style: AppTypography.textSubtitle(),
                  textAlign: TextAlign.justify,
                ),
                const Divider(color: AppColors.gray, height: 24, thickness: 1),
                Text(
                  noteVisualizationBloc.noteModel.date.formattedDateTime,
                  style: AppTypography.textSubtitle(),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Excluir nota',
                  color: AppColors.red,
                  borderColor: AppColors.darkRed,
                  textColor: AppColors.lightGray1,
                  onTap: () async {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => DecisionDialog(
                        title: 'Excluir a nota?',
                        subtitle: 'Após a exclusão da nota, não será possível recuperá-la',
                        confirmText: 'Excluir',
                        onConfirm: () => noteVisualizationBloc.add(const DeleteCurrentNote()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
