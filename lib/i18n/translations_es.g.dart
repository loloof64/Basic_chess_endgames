///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsEs extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsEs _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsMiscEs misc = _TranslationsMiscEs._(_root);
	@override late final _TranslationsPickersEs pickers = _TranslationsPickersEs._(_root);
	@override late final _TranslationsHomeEs home = _TranslationsHomeEs._(_root);
	@override late final _TranslationsSampleChooserEs sample_chooser = _TranslationsSampleChooserEs._(_root);
	@override late final _TranslationsGamePageEs game_page = _TranslationsGamePageEs._(_root);
	@override late final _TranslationsScriptParserEs script_parser = _TranslationsScriptParserEs._(_root);
	@override late final _TranslationsScriptTypeEs script_type = _TranslationsScriptTypeEs._(_root);
	@override late final _TranslationsSideEs side = _TranslationsSideEs._(_root);
	@override late final _TranslationsTypeEs type = _TranslationsTypeEs._(_root);
	@override late final _TranslationsSampleScriptEs sample_script = _TranslationsSampleScriptEs._(_root);
	@override late final _TranslationsScriptEditorPageEs script_editor_page = _TranslationsScriptEditorPageEs._(_root);
	@override late final _TranslationsVariablesTableEs variables_table = _TranslationsVariablesTableEs._(_root);
	@override late final _TranslationsSyntaxManualPageEs syntax_manual_page = _TranslationsSyntaxManualPageEs._(_root);
	@override late final _TranslationsRandomTestingEs random_testing = _TranslationsRandomTestingEs._(_root);
}

// Path: misc
class _TranslationsMiscEs extends TranslationsMiscEn {
	_TranslationsMiscEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get app_title => 'Finales básicos de ajedrez';
	@override String get button_ok => 'De acuerdo';
	@override String get button_cancel => 'Anular';
	@override String get button_accept => 'Aceptar';
	@override String get button_deny => 'Rechazar';
	@override String get button_validate => 'Validar';
}

// Path: pickers
class _TranslationsPickersEs extends TranslationsPickersEn {
	_TranslationsPickersEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get documents_directory => 'Documentos';
	@override String get save_file_title => 'Guardar el código';
	@override String get open_script_title => 'Cargar el código';
	@override String get cancelled => 'Diálogo de selección cancelado';
}

// Path: home
class _TranslationsHomeEs extends TranslationsHomeEn {
	_TranslationsHomeEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inicio';
	@override String get failed_loading_exercise => 'No se pudo cargar el ejercicio: la posición de ajedrez no es válida.';
	@override String get success_saving_exercice => 'Ejercicio guardado.';
	@override String get failed_saving_exercise => 'No se pudo guardar el ejercicio.';
	@override String get max_generation_attempts_achieved => 'Es imposible generar una posición a partir de estos guiones: se han superado los intentos máximos de generación.\n\nComprueba que tus restricciones no sean demasiado restrictivas.\n\nAdemás, por favor, asegúrate de que todas tus variables estén declaradas antes de usarlas.';
	@override String get failed_generating_position => 'Falló al generar la posición.';
	@override String get misc_generating_error => 'Error al generar la posición para un error misceláneo.';
	@override late final _TranslationsHomeMenuButtonsEs menu_buttons = _TranslationsHomeMenuButtonsEs._(_root);
	@override String get goal_label => 'Objectivo';
	@override String get win_label => 'Ganar';
	@override String get draw_label => 'Empate';
	@override late final _TranslationsHomeErrorsPopupLabelsEs errors_popup_labels = _TranslationsHomeErrorsPopupLabelsEs._(_root);
}

// Path: sample_chooser
class _TranslationsSampleChooserEs extends TranslationsSampleChooserEn {
	_TranslationsSampleChooserEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Selector de ejemplo';
}

// Path: game_page
class _TranslationsGamePageEs extends TranslationsGamePageEn {
	_TranslationsGamePageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Página del juego';
	@override String get goal_win => 'Objetivo: ganar';
	@override String get goal_draw => 'Objetivo: empate';
	@override String get new_game_title => '¿Reiniciar el juego?';
	@override String get new_game_message => '¿Quieres reiniciar el juego?';
	@override String get stop_game_title => '¿Detener el juego actual?';
	@override String get stop_game_message => '¿Quiere detener el juego actual?';
	@override String get game_stopped => 'Juego detenido.';
	@override String get checkmate_white => 'Los Blancos han ganado por jaque mate.';
	@override String get checkmate_black => 'Los Negros han ganado por jaque mate.';
	@override String get stalemate => 'Empate.';
	@override String get three_fold_repetition => 'Igualdad por repetición triple.';
	@override String get missing_material => 'Igualdad por falta de material.';
	@override String get fifty_moves_rule => 'Igualdad por la regla de los 50 movimientos.';
	@override String get before_exit_title => '¿Cancelar el juego actual?';
	@override String get before_exit_message => '¿Quieres abandonar esta página y cancelar el juego actual?';
	@override String get help_message => 'Además de jugar la partida contra el motor, puedes voltear el tablero, reiniciar desde la posición generada, pero también detener el juego prematuramente.\n Una vez que la partida haya terminado, podrás revisar los movimientos desde el componente de historial.';
}

// Path: script_parser
class _TranslationsScriptParserEs extends TranslationsScriptParserEn {
	_TranslationsScriptParserEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get undefined_script_type => '#NoDefinido#';
	@override String get missing_script_type => 'No se pudo generar la posición: compruebe que todas las secciones del guione declaran un tipo de guione correcto.';
	@override String unrecognized_script_type({required Object Type}) => 'Tipo de escritura no reconocido: ${Type}.';
	@override String get misc_error_dialog_title => 'Equivocado global';
	@override String get misc_checking_error => 'La verificación de errores ha fallado debido a un error misceláneo.';
	@override String get misc_syntaxt_error_unknown_token => '¡Error de sintaxis varios!';
	@override String get missing_result_value => '¡El código debe establecer un booleano en la variable \'result\' !';
}

// Path: script_type
class _TranslationsScriptTypeEs extends TranslationsScriptTypeEn {
	_TranslationsScriptTypeEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get player_king_constraint => 'Restricción sobre rey del jugador';
	@override String get computer_king_constraint => 'Restricción sobre rey de la computadora';
	@override String get kings_mutual_constraint => 'Restricción mutua de reyes';
	@override String get other_pieces_global_constraint => 'Restricción global de otras piezas';
	@override String get other_pieces_indexed_constraint => 'Restricción indexada de otras piezas';
	@override String get other_pieces_mutual_constraint => 'Restricción mutua de otras piezas';
	@override String get piece_kind_count_constraint => 'Restricción de recuento de tipos de piezas';
	@override String other_pieces_global_constraint_specialized({required Object PieceKind}) => 'Restricción global de otras piezas ${PieceKind}';
	@override String other_pieces_indexed_constraint_specialized({required Object PieceKind}) => 'Restricción indexada de otras piezas ${PieceKind}';
	@override String other_pieces_mutual_constraint_specialized({required Object PieceKind}) => 'Restricción mutuas de tipos de piezas ${PieceKind}';
}

// Path: side
class _TranslationsSideEs extends TranslationsSideEn {
	_TranslationsSideEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get player => 'jugador';
	@override String get computer => 'computadora';
}

// Path: type
class _TranslationsTypeEs extends TranslationsTypeEn {
	_TranslationsTypeEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get pawn => 'peón';
	@override String get knight => 'caballero';
	@override String get bishop => 'alfil';
	@override String get rook => 'torre';
	@override String get queen => 'reina';
	@override String get king => 'rey';
}

// Path: sample_script
class _TranslationsSampleScriptEs extends TranslationsSampleScriptEn {
	_TranslationsSampleScriptEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kq_k => 'Rey+Reina | Rey';
	@override String get kr_k => 'Rey+ Torre | Rey';
	@override String get krr_k => 'Rey+2 Torres | Rey';
	@override String get kbb_k => 'Rey+2 Alfiles | Rey';
	@override String get kp_k1 => 'Rey+Peón | Rey (1)';
	@override String get kp_k2 => 'Rey+Peón | Rey (2)';
	@override String get kppp_kppp => 'Rey+3 Peones | Rey+3 Peones';
	@override String get rook_ending_lucena => 'Finale de torre de Lucena';
	@override String get rook_ending_philidor => 'Finale de torre de Philidor';
}

// Path: script_editor_page
class _TranslationsScriptEditorPageEs extends TranslationsScriptEditorPageEn {
	_TranslationsScriptEditorPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Página del editor de guiones';
	@override String get no_content_yet => 'Seleccione un tipo de pieza.';
	@override String get player_king_constraint => 'Restricciones rey del jugador';
	@override String get computer_king_constraint => 'Restricciones rey de la computadora';
	@override String get kings_mutual_constraint => 'Restricciones mutuas de los reyes';
	@override String get other_pieces_count_constraint => 'Restricciones número otras piezas';
	@override String get other_pieces_global_constraint => 'Restricciones globales sobre otras piezas';
	@override String get other_pieces_mutual_constraint => 'Restricciones mutuas sobre otras piezas';
	@override String get other_pieces_indexed_constraint => 'Restricciones sobre otras piezas por orden';
	@override String get game_goal => 'Objetivo del juego';
	@override String get add_count => 'Añadir';
	@override String get type_already_added => 'Ya se agregó este tipo.';
	@override String get should_win => 'Ganar';
	@override String get should_draw => 'Empate';
	@override String get before_exit_title => '¿Cancelar la edición del guione?';
	@override String get before_exit_message => '¿Desea salir de esta página y cancelar la edición del guione?';
	@override String get exercise_creation_success => 'Ejercicio guardado';
	@override String get exercise_creation_error => '¡No se pudo guardar el ejercicio!';
	@override String get insert_variable_title => 'Insertar una predefinida variable';
	@override String get consult_variables_title => 'Consultar predefinidas variables';
	@override String get choice_common_constants => 'Constantes comunes';
	@override String get choice_script_variables => 'Variable para el tipo de código';
	@override String get invalid_script => 'El código tiene errores. Por favor, corregirlos.';
}

// Path: variables_table
class _TranslationsVariablesTableEs extends TranslationsVariablesTableEn {
	_TranslationsVariablesTableEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVariablesTableHeadersEs headers = _TranslationsVariablesTableHeadersEs._(_root);
	@override late final _TranslationsVariablesTableRowsEs rows = _TranslationsVariablesTableRowsEs._(_root);
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageEs extends TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Manual de sintaxis';
	@override late final _TranslationsSyntaxManualPageIntroductionEs introduction = _TranslationsSyntaxManualPageIntroductionEs._(_root);
	@override late final _TranslationsSyntaxManualPageExplainingGenerationAlgorithmEs explaining_generation_algorithm = _TranslationsSyntaxManualPageExplainingGenerationAlgorithmEs._(_root);
	@override late final _TranslationsSyntaxManualPageGoalOfPositionEs goal_of_position = _TranslationsSyntaxManualPageGoalOfPositionEs._(_root);
}

// Path: random_testing
class _TranslationsRandomTestingEs extends TranslationsRandomTestingEn {
	_TranslationsRandomTestingEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsRandomTestingParametersDialogEs parameters_dialog = _TranslationsRandomTestingParametersDialogEs._(_root);
	@override String get title => 'Generación aleatoria para probar';
	@override String get tab_generated_positions => 'Generadas';
	@override String get tab_rejected_positions => 'Rechazadas';
}

// Path: home.menu_buttons
class _TranslationsHomeMenuButtonsEs extends TranslationsHomeMenuButtonsEn {
	_TranslationsHomeMenuButtonsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get samples => 'Jugar un ejemplo';
	@override String get load_script => 'Jugar un archivo de código';
	@override String get new_script => 'Nuevo archivo de código';
	@override String get edit_script => 'Editar un archivo de código';
	@override String get show_sample_code => 'Mostrar el código de un ejemplo';
	@override String get clone_sample => 'Clonar el código de un ejemplo';
	@override String get generate_random_testing => 'Generar un aleatorio para probar';
}

// Path: home.errors_popup_labels
class _TranslationsHomeErrorsPopupLabelsEs extends TranslationsHomeErrorsPopupLabelsEn {
	_TranslationsHomeErrorsPopupLabelsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get script_type => 'Tipo de código';
	@override String get position => 'Posición';
	@override String get position_short => 'Pos.';
	@override String get message => 'Mensaje';
}

// Path: variables_table.headers
class _TranslationsVariablesTableHeadersEs extends TranslationsVariablesTableHeadersEn {
	_TranslationsVariablesTableHeadersEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get variable_name => 'Nombre';
	@override String get variable_description => 'Descripción';
	@override String get variable_type => 'Tipo';
}

// Path: variables_table.rows
class _TranslationsVariablesTableRowsEs extends TranslationsVariablesTableRowsEn {
	_TranslationsVariablesTableRowsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVariablesTableRowsFileAEs file_a = _TranslationsVariablesTableRowsFileAEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileBEs file_b = _TranslationsVariablesTableRowsFileBEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileCEs file_c = _TranslationsVariablesTableRowsFileCEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileDEs file_d = _TranslationsVariablesTableRowsFileDEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileEEs file_e = _TranslationsVariablesTableRowsFileEEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileFEs file_f = _TranslationsVariablesTableRowsFileFEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileGEs file_g = _TranslationsVariablesTableRowsFileGEs._(_root);
	@override late final _TranslationsVariablesTableRowsFileHEs file_h = _TranslationsVariablesTableRowsFileHEs._(_root);
	@override late final _TranslationsVariablesTableRowsRank1Es rank_1 = _TranslationsVariablesTableRowsRank1Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank2Es rank_2 = _TranslationsVariablesTableRowsRank2Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank3Es rank_3 = _TranslationsVariablesTableRowsRank3Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank4Es rank_4 = _TranslationsVariablesTableRowsRank4Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank5Es rank_5 = _TranslationsVariablesTableRowsRank5Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank6Es rank_6 = _TranslationsVariablesTableRowsRank6Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank7Es rank_7 = _TranslationsVariablesTableRowsRank7Es._(_root);
	@override late final _TranslationsVariablesTableRowsRank8Es rank_8 = _TranslationsVariablesTableRowsRank8Es._(_root);
	@override late final _TranslationsVariablesTableRowsKingFileEs king_file = _TranslationsVariablesTableRowsKingFileEs._(_root);
	@override late final _TranslationsVariablesTableRowsKingRankEs king_rank = _TranslationsVariablesTableRowsKingRankEs._(_root);
	@override late final _TranslationsVariablesTableRowsPlayerHasWhiteEs player_has_white = _TranslationsVariablesTableRowsPlayerHasWhiteEs._(_root);
	@override late final _TranslationsVariablesTableRowsPlayerKingFileEs player_king_file = _TranslationsVariablesTableRowsPlayerKingFileEs._(_root);
	@override late final _TranslationsVariablesTableRowsPlayerKingRankEs player_king_rank = _TranslationsVariablesTableRowsPlayerKingRankEs._(_root);
	@override late final _TranslationsVariablesTableRowsComputerKingFileEs computer_king_file = _TranslationsVariablesTableRowsComputerKingFileEs._(_root);
	@override late final _TranslationsVariablesTableRowsComputerKingRankEs computer_king_rank = _TranslationsVariablesTableRowsComputerKingRankEs._(_root);
	@override late final _TranslationsVariablesTableRowsPieceFileEs piece_file = _TranslationsVariablesTableRowsPieceFileEs._(_root);
	@override late final _TranslationsVariablesTableRowsPieceRankEs piece_rank = _TranslationsVariablesTableRowsPieceRankEs._(_root);
	@override late final _TranslationsVariablesTableRowsApparitionIndexEs apparition_index = _TranslationsVariablesTableRowsApparitionIndexEs._(_root);
	@override late final _TranslationsVariablesTableRowsFirstPieceFileEs first_piece_file = _TranslationsVariablesTableRowsFirstPieceFileEs._(_root);
	@override late final _TranslationsVariablesTableRowsFirstPieceRankEs first_piece_rank = _TranslationsVariablesTableRowsFirstPieceRankEs._(_root);
	@override late final _TranslationsVariablesTableRowsSecondPieceFileEs second_piece_file = _TranslationsVariablesTableRowsSecondPieceFileEs._(_root);
	@override late final _TranslationsVariablesTableRowsSecondPieceRankEs second_piece_rank = _TranslationsVariablesTableRowsSecondPieceRankEs._(_root);
}

// Path: syntax_manual_page.introduction
class _TranslationsSyntaxManualPageIntroductionEs extends TranslationsSyntaxManualPageIntroductionEn {
	_TranslationsSyntaxManualPageIntroductionEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Introducción';
	@override String get part_1 => 'Para generar una posición, es necesario indicarle al algoritmo qué restricciones debe respetar.';
	@override String get part_2 => 'Estas restricciones se distribuyen entre varios tipos y se puede definir un código para cada uno.';
	@override String get part_3 => 'Veremos más sobre las restricciones más adelante.';
	@override String get part_4 => 'El programa utiliza una Máquina Virtual Lua 5.3 para interpretar los scripts.';
}

// Path: syntax_manual_page.explaining_generation_algorithm
class _TranslationsSyntaxManualPageExplainingGenerationAlgorithmEs extends TranslationsSyntaxManualPageExplainingGenerationAlgorithmEn {
	_TranslationsSyntaxManualPageExplainingGenerationAlgorithmEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Explicando el algoritmo de generación';
	@override late final _TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEs general_considerations = _TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEs._(_root);
	@override late final _TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEs order_of_scripts_evaluations = _TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEs._(_root);
}

// Path: syntax_manual_page.goal_of_position
class _TranslationsSyntaxManualPageGoalOfPositionEs extends TranslationsSyntaxManualPageGoalOfPositionEn {
	_TranslationsSyntaxManualPageGoalOfPositionEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Objetivo de la posición';
	@override String get part_1 => 'Puedes definir el objetivo de la posición (ganar o empatar).';
	@override String get part_2 => 'Tenga en cuenta que esto no afectará al algoritmo: es solo una información para el jugador de la posición.';
}

// Path: random_testing.parameters_dialog
class _TranslationsRandomTestingParametersDialogEs extends TranslationsRandomTestingParametersDialogEn {
	_TranslationsRandomTestingParametersDialogEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Parámetros de aleatorio para probar';
	@override String get images_count => 'Nombre de imágenes';
	@override String get intermediates_positions_level => 'Nivel de posiciones intermedias';
	@override String get intermediates_positions_level_none => 'Ninguna';
	@override String get intermediates_positions_level_with_max_pieces => 'Solo posiciones que no incluyan solo rey(s)';
	@override String get intermediates_positions_level_all => 'Todas';
}

// Path: variables_table.rows.file_a
class _TranslationsVariablesTableRowsFileAEs extends TranslationsVariablesTableRowsFileAEn {
	_TranslationsVariablesTableRowsFileAEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'A\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_b
class _TranslationsVariablesTableRowsFileBEs extends TranslationsVariablesTableRowsFileBEn {
	_TranslationsVariablesTableRowsFileBEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'B\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_c
class _TranslationsVariablesTableRowsFileCEs extends TranslationsVariablesTableRowsFileCEn {
	_TranslationsVariablesTableRowsFileCEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'C\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_d
class _TranslationsVariablesTableRowsFileDEs extends TranslationsVariablesTableRowsFileDEn {
	_TranslationsVariablesTableRowsFileDEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'D\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_e
class _TranslationsVariablesTableRowsFileEEs extends TranslationsVariablesTableRowsFileEEn {
	_TranslationsVariablesTableRowsFileEEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'E\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_f
class _TranslationsVariablesTableRowsFileFEs extends TranslationsVariablesTableRowsFileFEn {
	_TranslationsVariablesTableRowsFileFEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'F\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_g
class _TranslationsVariablesTableRowsFileGEs extends TranslationsVariablesTableRowsFileGEn {
	_TranslationsVariablesTableRowsFileGEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'G\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.file_h
class _TranslationsVariablesTableRowsFileHEs extends TranslationsVariablesTableRowsFileHEn {
	_TranslationsVariablesTableRowsFileHEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna \'H\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_1
class _TranslationsVariablesTableRowsRank1Es extends TranslationsVariablesTableRowsRank1En {
	_TranslationsVariablesTableRowsRank1Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'1\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_2
class _TranslationsVariablesTableRowsRank2Es extends TranslationsVariablesTableRowsRank2En {
	_TranslationsVariablesTableRowsRank2Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'2\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_3
class _TranslationsVariablesTableRowsRank3Es extends TranslationsVariablesTableRowsRank3En {
	_TranslationsVariablesTableRowsRank3Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'3\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_4
class _TranslationsVariablesTableRowsRank4Es extends TranslationsVariablesTableRowsRank4En {
	_TranslationsVariablesTableRowsRank4Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'4\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_5
class _TranslationsVariablesTableRowsRank5Es extends TranslationsVariablesTableRowsRank5En {
	_TranslationsVariablesTableRowsRank5Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'5\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_6
class _TranslationsVariablesTableRowsRank6Es extends TranslationsVariablesTableRowsRank6En {
	_TranslationsVariablesTableRowsRank6Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'6\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_7
class _TranslationsVariablesTableRowsRank7Es extends TranslationsVariablesTableRowsRank7En {
	_TranslationsVariablesTableRowsRank7Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'7\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.rank_8
class _TranslationsVariablesTableRowsRank8Es extends TranslationsVariablesTableRowsRank8En {
	_TranslationsVariablesTableRowsRank8Es._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango \'8\'';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.king_file
class _TranslationsVariablesTableRowsKingFileEs extends TranslationsVariablesTableRowsKingFileEn {
	_TranslationsVariablesTableRowsKingFileEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna del rey';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.king_rank
class _TranslationsVariablesTableRowsKingRankEs extends TranslationsVariablesTableRowsKingRankEn {
	_TranslationsVariablesTableRowsKingRankEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango del rey';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.player_has_white
class _TranslationsVariablesTableRowsPlayerHasWhiteEs extends TranslationsVariablesTableRowsPlayerHasWhiteEn {
	_TranslationsVariablesTableRowsPlayerHasWhiteEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => '¿El jugador tiene lado blanco?';
	@override String get type => 'Booleano';
}

// Path: variables_table.rows.player_king_file
class _TranslationsVariablesTableRowsPlayerKingFileEs extends TranslationsVariablesTableRowsPlayerKingFileEn {
	_TranslationsVariablesTableRowsPlayerKingFileEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna del rey del jugador';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.player_king_rank
class _TranslationsVariablesTableRowsPlayerKingRankEs extends TranslationsVariablesTableRowsPlayerKingRankEn {
	_TranslationsVariablesTableRowsPlayerKingRankEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango del rey del jugador';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.computer_king_file
class _TranslationsVariablesTableRowsComputerKingFileEs extends TranslationsVariablesTableRowsComputerKingFileEn {
	_TranslationsVariablesTableRowsComputerKingFileEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna del rey de la computadora';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.computer_king_rank
class _TranslationsVariablesTableRowsComputerKingRankEs extends TranslationsVariablesTableRowsComputerKingRankEn {
	_TranslationsVariablesTableRowsComputerKingRankEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango del rey de la computadora';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.piece_file
class _TranslationsVariablesTableRowsPieceFileEs extends TranslationsVariablesTableRowsPieceFileEn {
	_TranslationsVariablesTableRowsPieceFileEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna de la pieza';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.piece_rank
class _TranslationsVariablesTableRowsPieceRankEs extends TranslationsVariablesTableRowsPieceRankEn {
	_TranslationsVariablesTableRowsPieceRankEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango de la pieza';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.apparition_index
class _TranslationsVariablesTableRowsApparitionIndexEs extends TranslationsVariablesTableRowsApparitionIndexEn {
	_TranslationsVariablesTableRowsApparitionIndexEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El índice del orden de aparición de la pieza (comienza en 0)';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.first_piece_file
class _TranslationsVariablesTableRowsFirstPieceFileEs extends TranslationsVariablesTableRowsFirstPieceFileEn {
	_TranslationsVariablesTableRowsFirstPieceFileEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna de la primera pieza';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.first_piece_rank
class _TranslationsVariablesTableRowsFirstPieceRankEs extends TranslationsVariablesTableRowsFirstPieceRankEn {
	_TranslationsVariablesTableRowsFirstPieceRankEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango de la primera pieza';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.second_piece_file
class _TranslationsVariablesTableRowsSecondPieceFileEs extends TranslationsVariablesTableRowsSecondPieceFileEn {
	_TranslationsVariablesTableRowsSecondPieceFileEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'La columna de la segunda pieza';
	@override String get type => 'Entero';
}

// Path: variables_table.rows.second_piece_rank
class _TranslationsVariablesTableRowsSecondPieceRankEs extends TranslationsVariablesTableRowsSecondPieceRankEn {
	_TranslationsVariablesTableRowsSecondPieceRankEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get description => 'El rango de la segunda pieza';
	@override String get type => 'Entero';
}

// Path: syntax_manual_page.explaining_generation_algorithm.general_considerations
class _TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEs extends TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEn {
	_TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Consideraciones Generales';
	@override String get part_1_1 => 'El algoritmo comienza con un tablero vacío y trata de colocar cada pieza una detrás de otra.';
	@override String get part_1_2 => 'Por supuesto, se comprueba que se respeten las reglas legales del ajedrez.';
	@override String get part_1_3 => 'Pero también verifica que, para el tipo de la pieza actual, se respeten las restricciones (si las hay) definidas para ello.';
	@override String get part_1_4 => 'Por tipo de pieza nos referimos, por ejemplo, a una Torre perteneciente a la Computadora o a un Peón perteneciente al Jugador.';
	@override String get part_2_1 => 'Entonces, cada restricción se define en un código, escrito en un subconjunto de Lua como se indicó anteriormente.';
	@override String get part_2_2 => 'Cada código tiene acceso a algunas variables predefinidas, cuyos valores serán proporcionados por el algoritmo, pero también a algunas constantes de coordenadas.';
	@override String get part_2_3 => 'Puede tener acceso a las variables y constantes predefinidas de cada código e insertar sus nombres accediendo al cuadro de ayuda del tipo de código que está editando.';
	@override String get part_2_4 => 'Pero, sobre todo (y así sabrá el algoritmo si se respetan sus restricciones), cada código debe definir una variable booleana \'result\'.';
	@override String get part_3_1 => 'Si en algún paso no se respetan las restricciones para las últimas piezas colocadas, el algoritmo intentará colocarlas en otro lugar.';
	@override String get part_3_2 => 'De esta manera se evita tener que reiniciar desde cero en cada fallo.';
}

// Path: syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations
class _TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEs extends TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEn {
	_TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Orden de evaluación de los códigos';
	@override String get part_1_1 => 'Los primeros pasos del algoritmo son bastante simples:';
	@override String get part_1_2 => '*) comienza a colocar el rey del jugador y usa el código de restricciones del rey del jugador si está definido para una verificación';
	@override String get part_1_3 => '*) luego coloca al rey de la computadora y utiliza el código de restricciones del rey de la computadora, y también el código de restricciones mutuas de los reyes';
	@override String get part_2_1 => 'Los siguientes pasos son un poco más complejos. Utiliza las restricciones de conteo para saber cuántas piezas de cada tipo debe generar.';
	@override String get part_2_2 => 'Luego, para cada pieza individual de un tipo determinado, coloca uno tras otro y realiza varias comprobaciones:';
	@override String get part_2_3 => '*) utiliza las restricciones globales para este tipo, con el fin de ver si se respetan las restricciones generales para este tipo';
	@override String get part_2_4 => '*) utiliza las restricciones indexadas para este tipo, con el fin de ver si se respetan las restricciones relativas al orden de aparición de la pieza actual en su grupo de tipo';
	@override String get part_2_5 => '*) utiliza las restricciones mutuas para este tipo, con el fin de ver si las restricciones relativas a dos piezas del mismo tipo se respetan entre sí';
}
