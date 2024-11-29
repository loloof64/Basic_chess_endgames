///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final TranslationsMiscEn misc = TranslationsMiscEn.internal(_root);
	late final TranslationsPickersEn pickers = TranslationsPickersEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsSampleChooserEn sample_chooser = TranslationsSampleChooserEn.internal(_root);
	late final TranslationsGamePageEn game_page = TranslationsGamePageEn.internal(_root);
	late final TranslationsScriptParserEn script_parser = TranslationsScriptParserEn.internal(_root);
	late final TranslationsScriptTypeEn script_type = TranslationsScriptTypeEn.internal(_root);
	late final TranslationsSideEn side = TranslationsSideEn.internal(_root);
	late final TranslationsTypeEn type = TranslationsTypeEn.internal(_root);
	late final TranslationsSampleScriptEn sample_script = TranslationsSampleScriptEn.internal(_root);
	late final TranslationsScriptEditorPageEn script_editor_page = TranslationsScriptEditorPageEn.internal(_root);
	late final TranslationsVariablesTableEn variables_table = TranslationsVariablesTableEn.internal(_root);
	late final TranslationsSyntaxManualPageEn syntax_manual_page = TranslationsSyntaxManualPageEn.internal(_root);
}

// Path: misc
class TranslationsMiscEn {
	TranslationsMiscEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get app_title => 'Basic chess endgames';
	String get button_ok => 'Ok';
	String get button_cancel => 'Cancel';
	String get button_accept => 'Accept';
	String get button_deny => 'Deny';
	String get button_validate => 'Validate';
}

// Path: pickers
class TranslationsPickersEn {
	TranslationsPickersEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get documents_directory => 'Documents';
	String get save_file_title => 'Script\'s saving';
	String get open_script_title => 'Script\'s opening';
	String get cancelled => 'Selection dialog cancelled';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get failed_loading_exercise => 'Failed to load exercise : the chess position is not valid.';
	String get failed_generating_position => 'Failed to generate the position.';
	String get success_saving_exercice => 'Exercice saved.';
	String get failed_saving_exercise => 'Failed to save the exercice.';
	String get max_generation_attempts_achieved => 'Impossible to generate a position from these scripts : maximum generation attempts surpassed.\n\nPlease check that your constraints aren\'t too restrictive.\n\nAlso, please check that all of your variables are declared before use.';
	String get misc_generating_error => 'Failed to generate the position for a miscellaneous error.';
	late final TranslationsHomeMenuButtonsEn menu_buttons = TranslationsHomeMenuButtonsEn.internal(_root);
	String get goal_label => 'Goal';
	String get win_label => 'Win';
	String get draw_label => 'Draw';
	late final TranslationsHomeErrorsPopupLabelsEn errors_popup_labels = TranslationsHomeErrorsPopupLabelsEn.internal(_root);
}

// Path: sample_chooser
class TranslationsSampleChooserEn {
	TranslationsSampleChooserEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Example chooser';
}

// Path: game_page
class TranslationsGamePageEn {
	TranslationsGamePageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Game page';
	String get goal_win => 'Goal: win';
	String get goal_draw => 'Goal: draw';
	String get new_game_title => 'Restart game ?';
	String get new_game_message => 'Do you want to restart game ?';
	String get stop_game_title => 'Stop current game ?';
	String get stop_game_message => 'Do you want to stop current game ?';
	String get game_stopped => 'Game stopped.';
	String get checkmate_white => 'White has won by checkmate.';
	String get checkmate_black => 'Black has won by checkmate.';
	String get stalemate => 'Stalemate.';
	String get three_fold_repetition => 'Draw by three-fold repetition.';
	String get missing_material => 'Draw by missing material.';
	String get fifty_moves_rule => 'Draw by the 50 moves rule.';
	String get before_exit_title => 'Cancel current game ?';
	String get before_exit_message => 'Do you want to leave this page and cancel current game ?';
	String get help_message => 'Besides playing the game against the engine, you can flip the board, restart from the generated position, but also stop game prematurely.\n Once the game is over you will be able to review moves from the history component.';
}

// Path: script_parser
class TranslationsScriptParserEn {
	TranslationsScriptParserEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String variable_not_affected({required Object Name}) => 'The variable ${Name} has been used before having been defined.';
	String input_mismatch({required Object Line, required Object Index, required Object Expected, required Object Received}) => 'Bad input at line ${Line}: character number ${Index}. You should have set ${Expected} but I got ${Received}.';
	String no_viable_alt_exception({required Object Token, required Object LineNumber, required Object PositionInLine}) => 'The input ${Token} does not match any rule. (Line ${LineNumber}, character number ${PositionInLine})';
	String get no_antlr4_token => '[No occurence]';
	String get eof => '[EndOfFile]';
	String overriding_predefined_variable({required Object Name}) => 'You try to change the value of predefined variable ${Name}.';
	String get type_error => 'Please check that you don\'t use int value instead of boolean value and vice versa.';
	String get missing_script_type => 'Failed to generate position : please check that all of the script sections declares a correct script type.';
	String unrecognized_script_type({required Object Type}) => 'Unrecognized script type : ${Type}.';
	String get misc_error_dialog_title => 'Global error';
	String get misc_checking_error => 'The errors checking has failed for a miscellaneous error.';
	String get no_return_statement => 'Missing return statement : also check that you return a boolean value.';
	String get return_statement_not_boolean => 'Return statement does not return a boolean value.';
	String get too_restrictive_script_title => 'Too restrictive script ?';
	String get too_restrictive_script_message => 'Failed to generate a sample position from your script : is it too restrictive ?';
	String wrong_token_alternatives({required Object Symbol, required Object ExpectedSymbols}) => 'Wrong symbol (${Symbol}) : expecting one among (${ExpectedSymbols}) !';
	String get invalid_assignements => 'Invalid assignment statement !';
	String unrecognized_token({required Object Symbol}) => 'Symbol not recognized (${Symbol}) !';
	String misc_syntaxt_error({required Object Symbol}) => 'Miscellaneous syntax error (${Symbol}) !';
	String get misc_syntaxt_error_unknown_token => 'Miscellaneous syntax error !';
	String get if_statement_missing_block => 'The \'if\' statement is missing at least one statements block or condition !';
	late final TranslationsScriptParserErrorSubstitutionsEn error_substitutions = TranslationsScriptParserErrorSubstitutionsEn.internal(_root);
}

// Path: script_type
class TranslationsScriptTypeEn {
	TranslationsScriptTypeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get player_king_constraint => 'Player king constraint';
	String get computer_king_constraint => 'Computer king constraint';
	String get kings_mutual_constraint => 'Kings mutual constraint';
	String get other_pieces_global_constraint => 'Other pieces global constraint';
	String get other_pieces_indexed_constraint => 'Other pieces constraints by order';
	String get other_pieces_mutual_constraint => 'Other pieces mutual constraint';
	String get piece_kind_count_constraint => 'Piece kinds counts constraint';
	String other_pieces_global_constraint_specialized({required Object PieceKind}) => 'Other pieces global constraint ${PieceKind}';
	String other_pieces_indexed_constraint_specialized({required Object PieceKind}) => 'Other pieces constraints by order ${PieceKind}';
	String other_pieces_mutual_constraint_specialized({required Object PieceKind}) => 'Other pieces mutual constraint ${PieceKind}';
}

// Path: side
class TranslationsSideEn {
	TranslationsSideEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get player => 'player';
	String get computer => 'computer';
}

// Path: type
class TranslationsTypeEn {
	TranslationsTypeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get pawn => 'pawn';
	String get knight => 'knight';
	String get bishop => 'bishop';
	String get rook => 'rook';
	String get queen => 'queen';
	String get king => 'king';
}

// Path: sample_script
class TranslationsSampleScriptEn {
	TranslationsSampleScriptEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get kq_k => 'King+Queen | King';
	String get kr_k => 'King+Rook | King';
	String get krr_k => 'King+2 Rooks | King';
	String get kbb_k => 'King+Rook | King';
	String get kp_k1 => 'King+Pawn | King (1)';
	String get kp_k2 => 'King+Pawn | King (2)';
	String get kppp_kppp => 'King+3 Pawns | King+3 Pawns';
	String get rook_ending_lucena => 'Lucena rook ending';
	String get rook_ending_philidor => 'Philidor rook ending';
}

// Path: script_editor_page
class TranslationsScriptEditorPageEn {
	TranslationsScriptEditorPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Script editor page';
	String get no_content_yet => 'Select a piece kind.';
	String get player_king_constraint => 'Player\'s king\'s constraints';
	String get computer_king_constraint => 'Computer\'s king\'s constraints';
	String get kings_mutual_constraint => 'Kings\'s mutual constraints';
	String get other_pieces_count_constraint => 'Other pieces\' count\'s constraints';
	String get other_pieces_global_constraint => 'Other pieces\' global constraints';
	String get other_pieces_mutual_constraint => 'Other pieces\' mutual constraints';
	String get other_pieces_indexed_constraint => 'Other pieces constraints by order';
	String get game_goal => 'Game\'s goal';
	String get add_count => 'Add';
	String get type_already_added => 'Already added this type.';
	String get should_win => 'Win';
	String get should_draw => 'Draw';
	String get before_exit_title => 'Cancel script edition ?';
	String get before_exit_message => 'Do you want to leave this page and cancel script edition ?';
	String get exercise_creation_success => 'Saved exercise';
	String get exercise_creation_error => 'Failed to save exercise !';
	String get insert_variable_title => 'Insert a predifined variable';
	String get choice_common_constants => 'Common constants';
	String get choice_script_variables => 'Variable for the script type';
}

// Path: variables_table
class TranslationsVariablesTableEn {
	TranslationsVariablesTableEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsVariablesTableHeadersEn headers = TranslationsVariablesTableHeadersEn.internal(_root);
	late final TranslationsVariablesTableRowsEn rows = TranslationsVariablesTableRowsEn.internal(_root);
}

// Path: syntax_manual_page
class TranslationsSyntaxManualPageEn {
	TranslationsSyntaxManualPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Manual of syntax';
	late final TranslationsSyntaxManualPageIntroductionEn introduction = TranslationsSyntaxManualPageIntroductionEn.internal(_root);
	late final TranslationsSyntaxManualPageLuaAdaptationEn lua_adaptation = TranslationsSyntaxManualPageLuaAdaptationEn.internal(_root);
	late final TranslationsSyntaxManualPageExplainingGenerationAlgorithmEn explaining_generation_algorithm = TranslationsSyntaxManualPageExplainingGenerationAlgorithmEn.internal(_root);
	late final TranslationsSyntaxManualPageGoalOfPositionEn goal_of_position = TranslationsSyntaxManualPageGoalOfPositionEn.internal(_root);
}

// Path: home.menu_buttons
class TranslationsHomeMenuButtonsEn {
	TranslationsHomeMenuButtonsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get samples => 'Play an example';
	String get load_script => 'Play a script';
	String get new_script => 'New script';
	String get edit_script => 'Edit script';
	String get show_sample_code => 'Show the code of an example';
	String get clone_sample => 'Clone the code of an example';
}

// Path: home.errors_popup_labels
class TranslationsHomeErrorsPopupLabelsEn {
	TranslationsHomeErrorsPopupLabelsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get script_type => 'Script type';
	String get position => 'Position';
	String get position_short => 'Pos.';
	String get message => 'Message';
}

// Path: script_parser.error_substitutions
class TranslationsScriptParserErrorSubstitutionsEn {
	TranslationsScriptParserErrorSubstitutionsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get eof => '#EndOfFile#';
	String get variable_name => '#VariableName#';
	String get integer => '#Integer#';
}

// Path: variables_table.headers
class TranslationsVariablesTableHeadersEn {
	TranslationsVariablesTableHeadersEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get variable_name => 'Name';
	String get variable_description => 'Description';
	String get variable_type => 'Type';
}

// Path: variables_table.rows
class TranslationsVariablesTableRowsEn {
	TranslationsVariablesTableRowsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsVariablesTableRowsFileAEn file_a = TranslationsVariablesTableRowsFileAEn.internal(_root);
	late final TranslationsVariablesTableRowsFileBEn file_b = TranslationsVariablesTableRowsFileBEn.internal(_root);
	late final TranslationsVariablesTableRowsFileCEn file_c = TranslationsVariablesTableRowsFileCEn.internal(_root);
	late final TranslationsVariablesTableRowsFileDEn file_d = TranslationsVariablesTableRowsFileDEn.internal(_root);
	late final TranslationsVariablesTableRowsFileEEn file_e = TranslationsVariablesTableRowsFileEEn.internal(_root);
	late final TranslationsVariablesTableRowsFileFEn file_f = TranslationsVariablesTableRowsFileFEn.internal(_root);
	late final TranslationsVariablesTableRowsFileGEn file_g = TranslationsVariablesTableRowsFileGEn.internal(_root);
	late final TranslationsVariablesTableRowsFileHEn file_h = TranslationsVariablesTableRowsFileHEn.internal(_root);
	late final TranslationsVariablesTableRowsRank1En rank_1 = TranslationsVariablesTableRowsRank1En.internal(_root);
	late final TranslationsVariablesTableRowsRank2En rank_2 = TranslationsVariablesTableRowsRank2En.internal(_root);
	late final TranslationsVariablesTableRowsRank3En rank_3 = TranslationsVariablesTableRowsRank3En.internal(_root);
	late final TranslationsVariablesTableRowsRank4En rank_4 = TranslationsVariablesTableRowsRank4En.internal(_root);
	late final TranslationsVariablesTableRowsRank5En rank_5 = TranslationsVariablesTableRowsRank5En.internal(_root);
	late final TranslationsVariablesTableRowsRank6En rank_6 = TranslationsVariablesTableRowsRank6En.internal(_root);
	late final TranslationsVariablesTableRowsRank7En rank_7 = TranslationsVariablesTableRowsRank7En.internal(_root);
	late final TranslationsVariablesTableRowsRank8En rank_8 = TranslationsVariablesTableRowsRank8En.internal(_root);
	late final TranslationsVariablesTableRowsKingFileEn king_file = TranslationsVariablesTableRowsKingFileEn.internal(_root);
	late final TranslationsVariablesTableRowsKingRankEn king_rank = TranslationsVariablesTableRowsKingRankEn.internal(_root);
	late final TranslationsVariablesTableRowsPlayerHasWhiteEn player_has_white = TranslationsVariablesTableRowsPlayerHasWhiteEn.internal(_root);
	late final TranslationsVariablesTableRowsPlayerKingFileEn player_king_file = TranslationsVariablesTableRowsPlayerKingFileEn.internal(_root);
	late final TranslationsVariablesTableRowsPlayerKingRankEn player_king_rank = TranslationsVariablesTableRowsPlayerKingRankEn.internal(_root);
	late final TranslationsVariablesTableRowsComputerKingFileEn computer_king_file = TranslationsVariablesTableRowsComputerKingFileEn.internal(_root);
	late final TranslationsVariablesTableRowsComputerKingRankEn computer_king_rank = TranslationsVariablesTableRowsComputerKingRankEn.internal(_root);
	late final TranslationsVariablesTableRowsPieceFileEn piece_file = TranslationsVariablesTableRowsPieceFileEn.internal(_root);
	late final TranslationsVariablesTableRowsPieceRankEn piece_rank = TranslationsVariablesTableRowsPieceRankEn.internal(_root);
	late final TranslationsVariablesTableRowsApparitionIndexEn apparition_index = TranslationsVariablesTableRowsApparitionIndexEn.internal(_root);
	late final TranslationsVariablesTableRowsFirstPieceFileEn first_piece_file = TranslationsVariablesTableRowsFirstPieceFileEn.internal(_root);
	late final TranslationsVariablesTableRowsFirstPieceRankEn first_piece_rank = TranslationsVariablesTableRowsFirstPieceRankEn.internal(_root);
	late final TranslationsVariablesTableRowsSecondPieceFileEn second_piece_file = TranslationsVariablesTableRowsSecondPieceFileEn.internal(_root);
	late final TranslationsVariablesTableRowsSecondPieceRankEn second_piece_rank = TranslationsVariablesTableRowsSecondPieceRankEn.internal(_root);
}

// Path: syntax_manual_page.introduction
class TranslationsSyntaxManualPageIntroductionEn {
	TranslationsSyntaxManualPageIntroductionEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Introduction';
	String get part_1 => 'In order to generate a position, the algorithm must be told which constraints it must respect.';
	String get part_2 => 'These constraints are dispatched among several types, and you can define a script for each.';
	String get part_3 => 'We\'ll see more about constraints later.';
	String get part_4 => 'The syntax is a tiny subset of the Lua (5.4) language.';
}

// Path: syntax_manual_page.lua_adaptation
class TranslationsSyntaxManualPageLuaAdaptationEn {
	TranslationsSyntaxManualPageLuaAdaptationEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Adaptation of the Lua language';
	late final TranslationsSyntaxManualPageLuaAdaptationSupportedTypesEn supported_types = TranslationsSyntaxManualPageLuaAdaptationSupportedTypesEn.internal(_root);
	late final TranslationsSyntaxManualPageLuaAdaptationRemovedTypesEn removed_types = TranslationsSyntaxManualPageLuaAdaptationRemovedTypesEn.internal(_root);
	late final TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsEn available_syntax_elements = TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsEn.internal(_root);
	late final TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsEn removed_syntax_elements = TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsEn.internal(_root);
	late final TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsEn available_operators = TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsEn.internal(_root);
}

// Path: syntax_manual_page.explaining_generation_algorithm
class TranslationsSyntaxManualPageExplainingGenerationAlgorithmEn {
	TranslationsSyntaxManualPageExplainingGenerationAlgorithmEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Explaining the generation algorithm';
	late final TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEn general_considerations = TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEn.internal(_root);
	late final TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEn order_of_scripts_evaluations = TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEn.internal(_root);
}

// Path: syntax_manual_page.goal_of_position
class TranslationsSyntaxManualPageGoalOfPositionEn {
	TranslationsSyntaxManualPageGoalOfPositionEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Goal of the position';
	String get part_1 => 'You can define the goal of the position (to win or to draw).';
	String get part_2 => 'Keep in mind that it won\'t affect the algorithm : it\'s just an information for the player of the position.';
}

// Path: variables_table.rows.file_a
class TranslationsVariablesTableRowsFileAEn {
	TranslationsVariablesTableRowsFileAEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'A\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_b
class TranslationsVariablesTableRowsFileBEn {
	TranslationsVariablesTableRowsFileBEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'B\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_c
class TranslationsVariablesTableRowsFileCEn {
	TranslationsVariablesTableRowsFileCEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'C\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_d
class TranslationsVariablesTableRowsFileDEn {
	TranslationsVariablesTableRowsFileDEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'D\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_e
class TranslationsVariablesTableRowsFileEEn {
	TranslationsVariablesTableRowsFileEEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'E\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_f
class TranslationsVariablesTableRowsFileFEn {
	TranslationsVariablesTableRowsFileFEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'F\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_g
class TranslationsVariablesTableRowsFileGEn {
	TranslationsVariablesTableRowsFileGEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'G\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.file_h
class TranslationsVariablesTableRowsFileHEn {
	TranslationsVariablesTableRowsFileHEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'H\' file';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_1
class TranslationsVariablesTableRowsRank1En {
	TranslationsVariablesTableRowsRank1En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'1\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_2
class TranslationsVariablesTableRowsRank2En {
	TranslationsVariablesTableRowsRank2En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'2\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_3
class TranslationsVariablesTableRowsRank3En {
	TranslationsVariablesTableRowsRank3En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'3\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_4
class TranslationsVariablesTableRowsRank4En {
	TranslationsVariablesTableRowsRank4En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'4\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_5
class TranslationsVariablesTableRowsRank5En {
	TranslationsVariablesTableRowsRank5En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'5\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_6
class TranslationsVariablesTableRowsRank6En {
	TranslationsVariablesTableRowsRank6En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'6\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_7
class TranslationsVariablesTableRowsRank7En {
	TranslationsVariablesTableRowsRank7En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'7\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.rank_8
class TranslationsVariablesTableRowsRank8En {
	TranslationsVariablesTableRowsRank8En.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The \'8\' rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.king_file
class TranslationsVariablesTableRowsKingFileEn {
	TranslationsVariablesTableRowsKingFileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The king\'s file';
	String get type => 'Integer';
}

// Path: variables_table.rows.king_rank
class TranslationsVariablesTableRowsKingRankEn {
	TranslationsVariablesTableRowsKingRankEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The king\'s rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.player_has_white
class TranslationsVariablesTableRowsPlayerHasWhiteEn {
	TranslationsVariablesTableRowsPlayerHasWhiteEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'Does the player have white side ?';
	String get type => 'Boolean';
}

// Path: variables_table.rows.player_king_file
class TranslationsVariablesTableRowsPlayerKingFileEn {
	TranslationsVariablesTableRowsPlayerKingFileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The player\'s king\'s file';
	String get type => 'Integer';
}

// Path: variables_table.rows.player_king_rank
class TranslationsVariablesTableRowsPlayerKingRankEn {
	TranslationsVariablesTableRowsPlayerKingRankEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The player\'s king\'s rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.computer_king_file
class TranslationsVariablesTableRowsComputerKingFileEn {
	TranslationsVariablesTableRowsComputerKingFileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The computer\'s king\'s file';
	String get type => 'Integer';
}

// Path: variables_table.rows.computer_king_rank
class TranslationsVariablesTableRowsComputerKingRankEn {
	TranslationsVariablesTableRowsComputerKingRankEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The computer\'s king\'s rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.piece_file
class TranslationsVariablesTableRowsPieceFileEn {
	TranslationsVariablesTableRowsPieceFileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The piece\'s file';
	String get type => 'Integer';
}

// Path: variables_table.rows.piece_rank
class TranslationsVariablesTableRowsPieceRankEn {
	TranslationsVariablesTableRowsPieceRankEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The piece\'s rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.apparition_index
class TranslationsVariablesTableRowsApparitionIndexEn {
	TranslationsVariablesTableRowsApparitionIndexEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The index of order of apparition for the piece (starts at 0)';
	String get type => 'Integer';
}

// Path: variables_table.rows.first_piece_file
class TranslationsVariablesTableRowsFirstPieceFileEn {
	TranslationsVariablesTableRowsFirstPieceFileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The first piece\'s file';
	String get type => 'Integer';
}

// Path: variables_table.rows.first_piece_rank
class TranslationsVariablesTableRowsFirstPieceRankEn {
	TranslationsVariablesTableRowsFirstPieceRankEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The first piece\'s rank';
	String get type => 'Integer';
}

// Path: variables_table.rows.second_piece_file
class TranslationsVariablesTableRowsSecondPieceFileEn {
	TranslationsVariablesTableRowsSecondPieceFileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The second piece\'s file';
	String get type => 'Integer';
}

// Path: variables_table.rows.second_piece_rank
class TranslationsVariablesTableRowsSecondPieceRankEn {
	TranslationsVariablesTableRowsSecondPieceRankEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get description => 'The second piece\'s rank';
	String get type => 'Integer';
}

// Path: syntax_manual_page.lua_adaptation.supported_types
class TranslationsSyntaxManualPageLuaAdaptationSupportedTypesEn {
	TranslationsSyntaxManualPageLuaAdaptationSupportedTypesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Supported types';
	String get part_1 => '*) Integer';
	String get part_2 => '*) Boolean';
}

// Path: syntax_manual_page.lua_adaptation.removed_types
class TranslationsSyntaxManualPageLuaAdaptationRemovedTypesEn {
	TranslationsSyntaxManualPageLuaAdaptationRemovedTypesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Removed types';
	String get part_1 => '*) Float';
	String get part_2 => '*) String';
	String get part_3 => '*) Array';
	String get part_4 => '*) Map';
}

// Path: syntax_manual_page.lua_adaptation.available_syntax_elements
class TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsEn {
	TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Available syntax elements';
	String get part_1 => '*) assignment';
	String get part_2 => '*) if statement (caution : if statement is not an expression)';
}

// Path: syntax_manual_page.lua_adaptation.removed_syntax_elements
class TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsEn {
	TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Removed syntax elements';
	String get part_1 => '*) Loops statements';
	String get part_2 => '*) Functions';
	String get part_3 => '*) Coroutines';
}

// Path: syntax_manual_page.lua_adaptation.available_operators
class TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsEn {
	TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Available operators';
	String get part_1 => '*) parenthesis';
	String get part_2 => '*) + - * / ^ % //';
	String get part_3 => '*) > >= < <= ~= ==';
	String get part_4 => '*) not and  or';
	String get part_5 => '*) & | ~ << >>';
}

// Path: syntax_manual_page.explaining_generation_algorithm.general_considerations
class TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEn {
	TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'General considerations';
	String get part_1_1 => 'The algorithm starts with an empty board, and try to place each piece one after the other.';
	String get part_1_2 => 'Of course, it checks for the fact that the legal chess rules are respected.';
	String get part_1_3 => 'But it also checks that, for the current piece kind, the contraints - if any - defined for it are respected.';
	String get part_1_4 => 'By piece kind, we mean, for example, a Rook belonging to the Computer, or a Pawn belonging to the Player.';
	String get part_2_1 => 'So each constraints is defined in a script, written in a subset of Lua as stated earlier.';
	String get part_2_2 => 'Each script has access to some predefined variables, whose values will be provided by the algorithm, but also some coordinates constants.';
	String get part_2_3 => 'You can have access to each script predefined variables and constants, and insert their names, by accessing the helper box for the script you\'re editing.';
	String get part_2_4 => 'But, above all - and that\'s how the algorithm will know if your constraints are respected - each script must return a boolean value.';
	String get part_3_1 => 'If at any step, the constraints are not respected for the last placed pieces, the algorithm will try to place it somewhere else.';
	String get part_3_2 => 'So it avoid restarting from scratch at each failure.';
}

// Path: syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations
class TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEn {
	TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Order of script evaluations';
	String get part_1_1 => 'The first steps of the algoritm are quite simples:';
	String get part_1_2 => '*) it starts to place the player\'s king, and use the player\'s king constraints script if defined for a check';
	String get part_1_3 => '*) it then places the computer\'s king, and use the computer\'s king constraints script, and also the kings mutual constraints script';
	String get part_2_1 => 'The following steps are a bit more complex. It uses the count constraints in order to know how many pieces of each kind it must generate.';
	String get part_2_2 => 'Then, for each single piece of a given kind, it places one after other and performs several checks:';
	String get part_2_3 => '*) it use the global constraints for this kind, in order to see if the overall constraints for this kind is respected';
	String get part_2_4 => '*) it use the indexed constraints for this kind, in order to see if the constraints relative to the apparation order of the current piece in its kind group is respected';
	String get part_2_5 => '*) it use the mutual constraints for this kind, in order to see if the contraints relative to two pieces of the same kind is each other respected';
}
