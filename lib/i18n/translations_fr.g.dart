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
class TranslationsFr extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsFr _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsMiscFr misc = _TranslationsMiscFr._(_root);
	@override late final _TranslationsPickersFr pickers = _TranslationsPickersFr._(_root);
	@override late final _TranslationsHomeFr home = _TranslationsHomeFr._(_root);
	@override late final _TranslationsSampleChooserFr sample_chooser = _TranslationsSampleChooserFr._(_root);
	@override late final _TranslationsGamePageFr game_page = _TranslationsGamePageFr._(_root);
	@override late final _TranslationsScriptParserFr script_parser = _TranslationsScriptParserFr._(_root);
	@override late final _TranslationsScriptTypeFr script_type = _TranslationsScriptTypeFr._(_root);
	@override late final _TranslationsSideFr side = _TranslationsSideFr._(_root);
	@override late final _TranslationsTypeFr type = _TranslationsTypeFr._(_root);
	@override late final _TranslationsSampleScriptFr sample_script = _TranslationsSampleScriptFr._(_root);
	@override late final _TranslationsScriptEditorPageFr script_editor_page = _TranslationsScriptEditorPageFr._(_root);
	@override late final _TranslationsVariablesTableFr variables_table = _TranslationsVariablesTableFr._(_root);
	@override late final _TranslationsSyntaxManualPageFr syntax_manual_page = _TranslationsSyntaxManualPageFr._(_root);
}

// Path: misc
class _TranslationsMiscFr extends TranslationsMiscEn {
	_TranslationsMiscFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get app_title => 'Finales d\'échecs basiques';
	@override String get button_ok => 'D\'accord';
	@override String get button_cancel => 'Annuler';
	@override String get button_accept => 'Accepter';
	@override String get button_deny => 'Refuser';
	@override String get button_validate => 'Valider';
}

// Path: pickers
class _TranslationsPickersFr extends TranslationsPickersEn {
	_TranslationsPickersFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get documents_directory => 'Documents';
	@override String get save_file_title => 'Sauvegarde du script';
	@override String get open_script_title => 'Ouverture du script';
	@override String get cancelled => 'Dialogue de sélection annulé';
}

// Path: home
class _TranslationsHomeFr extends TranslationsHomeEn {
	_TranslationsHomeFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Accueil';
	@override String get failed_loading_exercise => 'Échec de chargement de l\'exerice : la position d\'échecs est invalide.';
	@override String get success_saving_exercice => 'Exercice enregistré.';
	@override String get failed_saving_exercise => 'Échec de sauvegarde de l\'exercice.';
	@override String get max_generation_attempts_achieved => 'Impossible de générer une position à partir de ces scripts : nombre de tentatives maximum dépassés.\n\nVeuillez vérifier que vos contraintes ne sont pas trop restrictives.\n\nÉgalement, veuillez vérifier que vos variables soient déclarées avant utilisation.';
	@override String get failed_generating_position => 'Échec de génération de la position.';
	@override String get misc_generating_error => 'Erreur de génération de la position pour une erreur diverse.';
	@override late final _TranslationsHomeMenuButtonsFr menu_buttons = _TranslationsHomeMenuButtonsFr._(_root);
	@override String get goal_label => 'Objectif';
	@override String get win_label => 'Gain';
	@override String get draw_label => 'Nulle';
	@override late final _TranslationsHomeErrorsPopupLabelsFr errors_popup_labels = _TranslationsHomeErrorsPopupLabelsFr._(_root);
}

// Path: sample_chooser
class _TranslationsSampleChooserFr extends TranslationsSampleChooserEn {
	_TranslationsSampleChooserFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sélecteur d\'exemple';
}

// Path: game_page
class _TranslationsGamePageFr extends TranslationsGamePageEn {
	_TranslationsGamePageFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Page de jeu';
	@override String get goal_win => 'Objectif: victoire';
	@override String get goal_draw => 'Objectif: nulle';
	@override String get new_game_title => 'Recommencer la partie ?';
	@override String get new_game_message => 'Souhaitez-vous recommencer la partie ?';
	@override String get stop_game_title => 'Arrêter la partie ?';
	@override String get stop_game_message => 'Souhaitez-vous arrêter la partie en cours ?';
	@override String get game_stopped => 'Partie interrompue.';
	@override String get checkmate_white => 'Les Blancs ont gagné par échec et mat.';
	@override String get checkmate_black => 'Les Noirs ont gagné par échec et mat.';
	@override String get stalemate => 'Pat.';
	@override String get three_fold_repetition => 'Nulle par triple répétition.';
	@override String get missing_material => 'Nulle par manque de matériel.';
	@override String get fifty_moves_rule => 'Nulle par la règle des 50 coups.';
	@override String get before_exit_title => 'Annuler la partie courante ?';
	@override String get before_exit_message => 'Souhaitez-vous abandonner cette partie et revenir à la page précédente ?';
	@override String get help_message => 'Au delà de la partie contre la machine, vous pouvez renverser l\'échiquier, redémarrer depuis la position générée, mais aussi interrompre la partie de manière prématurée.\n Une fois la partie terminée, vous pourrez visualiser les coups joués grâce au composant historique.';
}

// Path: script_parser
class _TranslationsScriptParserFr extends TranslationsScriptParserEn {
	_TranslationsScriptParserFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String variable_not_affected({required Object Name}) => 'La variable ${Name} a été utilisée avant même d\'avoir été définie.';
	@override String input_mismatch({required Object Line, required Object Index, required Object Expected, required Object Received}) => 'Entrée incorrecte dans la ligne ${Line} :caractère à l\'index ${Index}. Vous auriez dû mettre ${Expected} mais j\'ai reçu ${Received}.';
	@override String no_viable_alt_exception({required Object Token, required Object LineNumber, required Object PositionInLine}) => 'L\'entrée ${Token} ne correspond à aucune règle.(Ligne ${LineNumber}, numéro de caractère ${PositionInLine})';
	@override String get no_antlr4_token => '[Aucune occurence]';
	@override String get eof => '[FinDeFichier]';
	@override String get parenthesis_without_expression => 'Parenthèses sans expression.';
	@override String get unary_expression_without_value => 'Expression unaire sans valeur.';
	@override String invalid_expression_type({required Object Expected, required Object Got, required Object Operator}) => 'Type d\'expression invalide (attendu: ${Expected}, obtenu: ${Got}, opérateur: ${Operator}).';
	@override String get missing_value_in_exponent_expression => 'Il manque une valeur dans l\'expression exposant.';
	@override String missing_value_in_binary_expression({required Object Operator}) => 'Il manque une valeur dans l\'expression binaire (opérateur: ${Operator}).';
	@override String overriding_predefined_variable({required Object Name}) => 'Vous essayez de modifier la valeur de la variable prédéfinie ${Name}.';
	@override String get type_error => 'Veuillez vérifier que vous n\'utilisez pas de valeur entière à la place de valeur booléenne, et vice versa.';
	@override String get missing_script_type => 'Échec de génération de la position: veuillez vérifier que toutes les sections du script déclarent un type de script correct.';
	@override String unrecognized_script_type({required Object Type}) => 'Type de script non reconnu : ${Type}.';
	@override String get misc_error_dialog_title => 'Erreur globale';
	@override String get misc_checking_error => 'La vérification d\'erreurs a échoué pour une raison diverse.';
	@override String get no_return_statement => 'Il manque l\'instruction \'return\': vérifiez aussi que vous retournez une valeur booléenne.';
	@override String get return_statement_not_boolean => 'L\'instruction \'return\' ne retourne pas un booléen.';
	@override String get too_restrictive_script_title => 'Script trop restrictif ?';
	@override String get too_restrictive_script_message => 'Échec de génération de position à partir de votre script: serait-il trop restrictif ?';
	@override String wrong_token_alternatives({required Object Symbol, required Object ExpectedSymbols}) => 'Symbol non reconnu (${Symbol}): attendant un parmi (${ExpectedSymbols}) !';
	@override String get invalid_assignements => 'Instruction d\'assignement invalide !';
	@override String unrecognized_token({required Object Symbol}) => 'Symbol non reconnu (${Symbol}) !';
	@override String misc_syntaxt_error({required Object Symbol}) => 'Erreur de syntaxe diverse (${Symbol}) !';
	@override String get misc_syntaxt_error_unknown_token => 'Erreur de syntaxe diverse !';
	@override String get if_statement_missing_block => 'Il manque au moins un bloc d\'instructions ou condition dans l\'instruction \'if\' !';
	@override late final _TranslationsScriptParserErrorSubstitutionsFr error_substitutions = _TranslationsScriptParserErrorSubstitutionsFr._(_root);
	@override late final _TranslationsScriptParserTypesFr types = _TranslationsScriptParserTypesFr._(_root);
}

// Path: script_type
class _TranslationsScriptTypeFr extends TranslationsScriptTypeEn {
	_TranslationsScriptTypeFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get player_king_constraint => 'Contraintes du roi du joueur';
	@override String get computer_king_constraint => 'Contraintes du roi de l\'ordinateur';
	@override String get kings_mutual_constraint => 'Contraintes entre les deux rois';
	@override String get other_pieces_global_constraint => 'Contraintes globales pour les autres pièces';
	@override String get other_pieces_indexed_constraint => 'Contraintes par index pour les autres pièces';
	@override String get other_pieces_mutual_constraint => 'Contraintes mutuelles pour les autres pièces';
	@override String get piece_kind_count_constraint => 'Contraintes sur le compte des autres pièces';
	@override String other_pieces_global_constraint_specialized({required Object PieceKind}) => 'Contraintes globales pour les autres pièces ${PieceKind}';
	@override String other_pieces_indexed_constraint_specialized({required Object PieceKind}) => 'Contraintes par index pour les autres pièces ${PieceKind}';
	@override String other_pieces_mutual_constraint_specialized({required Object PieceKind}) => 'Contraintes mutuelles pour les autres pièces ${PieceKind}';
}

// Path: side
class _TranslationsSideFr extends TranslationsSideEn {
	_TranslationsSideFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get player => 'joueur';
	@override String get computer => 'ordinateur';
}

// Path: type
class _TranslationsTypeFr extends TranslationsTypeEn {
	_TranslationsTypeFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get pawn => 'pion';
	@override String get knight => 'cavalier';
	@override String get bishop => 'fou';
	@override String get rook => 'tour';
	@override String get queen => 'dame';
	@override String get king => 'roi';
}

// Path: sample_script
class _TranslationsSampleScriptFr extends TranslationsSampleScriptEn {
	_TranslationsSampleScriptFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get kq_k => 'Roi+Dame | Roi';
	@override String get kr_k => 'Roi+Tour | Roi';
	@override String get krr_k => 'Roi+2 Tours | Roi';
	@override String get kbb_k => 'Roi+2 Fous | Roi';
	@override String get kp_k1 => 'Roi+Pion | Roi (1)';
	@override String get kp_k2 => 'Roi+Pion | Roi (2)';
	@override String get kppp_kppp => 'Roi+3 Pions | Roi+3 Pions';
	@override String get rook_ending_lucena => 'Finale de tour de Lucena';
	@override String get rook_ending_philidor => 'Finale de tour de Philidor';
}

// Path: script_editor_page
class _TranslationsScriptEditorPageFr extends TranslationsScriptEditorPageEn {
	_TranslationsScriptEditorPageFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Page d\'édition de script';
	@override String get no_content_yet => 'Choisissez un type de pièce.';
	@override String get player_king_constraint => 'Contraintes roi du joueur';
	@override String get computer_king_constraint => 'Contraintes roi de l\'ordinateur';
	@override String get kings_mutual_constraint => 'Contraintes mutuelles entre rois';
	@override String get other_pieces_count_constraint => 'Contraintes compte des autres pièces';
	@override String get other_pieces_global_constraint => 'Contraintes globales des autres pièces';
	@override String get other_pieces_mutual_constraint => 'Contraintes mutuelles des autres pièces';
	@override String get other_pieces_indexed_constraint => 'Contraintes des autres pièces par ordre';
	@override String get game_goal => 'Objectif';
	@override String get add_count => 'Ajouter';
	@override String get type_already_added => 'Type déjà ajouté.';
	@override String get should_win => 'Gagner';
	@override String get should_draw => 'Annuler';
	@override String get before_exit_title => 'Annuler l\'édition du script ?';
	@override String get before_exit_message => 'Souhaitez-vous quitter la page et annuler l\'édition du script ?';
	@override String get exercise_creation_success => 'Exercise sauvegardé';
	@override String get exercise_creation_error => 'Échec de sauvegarde de l\'exercice !';
	@override String get insert_variable_title => 'Insérer une variable prédéfinie';
	@override String get choice_common_constants => 'Constantes communes';
	@override String get choice_script_variables => 'Variables pour le type de script';
}

// Path: variables_table
class _TranslationsVariablesTableFr extends TranslationsVariablesTableEn {
	_TranslationsVariablesTableFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVariablesTableHeadersFr headers = _TranslationsVariablesTableHeadersFr._(_root);
	@override late final _TranslationsVariablesTableRowsFr rows = _TranslationsVariablesTableRowsFr._(_root);
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageFr extends TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Manuel de syntaxe';
	@override late final _TranslationsSyntaxManualPageIntroductionFr introduction = _TranslationsSyntaxManualPageIntroductionFr._(_root);
	@override late final _TranslationsSyntaxManualPageLuaAdaptationFr lua_adaptation = _TranslationsSyntaxManualPageLuaAdaptationFr._(_root);
	@override late final _TranslationsSyntaxManualPageExplainingGenerationAlgorithmFr explaining_generation_algorithm = _TranslationsSyntaxManualPageExplainingGenerationAlgorithmFr._(_root);
	@override late final _TranslationsSyntaxManualPageGoalOfPositionFr goal_of_position = _TranslationsSyntaxManualPageGoalOfPositionFr._(_root);
}

// Path: home.menu_buttons
class _TranslationsHomeMenuButtonsFr extends TranslationsHomeMenuButtonsEn {
	_TranslationsHomeMenuButtonsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get samples => 'Jouer un exemple';
	@override String get load_script => 'Jouer un script';
	@override String get new_script => 'Nouveau script';
	@override String get edit_script => 'Éditer un script';
	@override String get show_sample_code => 'Montrer le code d\'un exemple';
	@override String get clone_sample => 'Cloner le code d\'un exemple';
}

// Path: home.errors_popup_labels
class _TranslationsHomeErrorsPopupLabelsFr extends TranslationsHomeErrorsPopupLabelsEn {
	_TranslationsHomeErrorsPopupLabelsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get script_type => 'Type de script';
	@override String get position => 'Position';
	@override String get position_short => 'Pos.';
	@override String get message => 'Message';
}

// Path: script_parser.error_substitutions
class _TranslationsScriptParserErrorSubstitutionsFr extends TranslationsScriptParserErrorSubstitutionsEn {
	_TranslationsScriptParserErrorSubstitutionsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get eof => '#FinDeFichier#';
	@override String get variable_name => '#NomDeVariable#';
	@override String get integer => '#Entier#';
}

// Path: script_parser.types
class _TranslationsScriptParserTypesFr extends TranslationsScriptParserTypesEn {
	_TranslationsScriptParserTypesFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get int => 'entier';
	@override String get bool => 'booléen';
}

// Path: variables_table.headers
class _TranslationsVariablesTableHeadersFr extends TranslationsVariablesTableHeadersEn {
	_TranslationsVariablesTableHeadersFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get variable_name => 'Nom';
	@override String get variable_description => 'Description';
	@override String get variable_type => 'Type';
}

// Path: variables_table.rows
class _TranslationsVariablesTableRowsFr extends TranslationsVariablesTableRowsEn {
	_TranslationsVariablesTableRowsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsVariablesTableRowsFileAFr file_a = _TranslationsVariablesTableRowsFileAFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileBFr file_b = _TranslationsVariablesTableRowsFileBFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileCFr file_c = _TranslationsVariablesTableRowsFileCFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileDFr file_d = _TranslationsVariablesTableRowsFileDFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileEFr file_e = _TranslationsVariablesTableRowsFileEFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileFFr file_f = _TranslationsVariablesTableRowsFileFFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileGFr file_g = _TranslationsVariablesTableRowsFileGFr._(_root);
	@override late final _TranslationsVariablesTableRowsFileHFr file_h = _TranslationsVariablesTableRowsFileHFr._(_root);
	@override late final _TranslationsVariablesTableRowsRank1Fr rank_1 = _TranslationsVariablesTableRowsRank1Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank2Fr rank_2 = _TranslationsVariablesTableRowsRank2Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank3Fr rank_3 = _TranslationsVariablesTableRowsRank3Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank4Fr rank_4 = _TranslationsVariablesTableRowsRank4Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank5Fr rank_5 = _TranslationsVariablesTableRowsRank5Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank6Fr rank_6 = _TranslationsVariablesTableRowsRank6Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank7Fr rank_7 = _TranslationsVariablesTableRowsRank7Fr._(_root);
	@override late final _TranslationsVariablesTableRowsRank8Fr rank_8 = _TranslationsVariablesTableRowsRank8Fr._(_root);
	@override late final _TranslationsVariablesTableRowsKingFileFr king_file = _TranslationsVariablesTableRowsKingFileFr._(_root);
	@override late final _TranslationsVariablesTableRowsKingRankFr king_rank = _TranslationsVariablesTableRowsKingRankFr._(_root);
	@override late final _TranslationsVariablesTableRowsPlayerHasWhiteFr player_has_white = _TranslationsVariablesTableRowsPlayerHasWhiteFr._(_root);
	@override late final _TranslationsVariablesTableRowsPlayerKingFileFr player_king_file = _TranslationsVariablesTableRowsPlayerKingFileFr._(_root);
	@override late final _TranslationsVariablesTableRowsPlayerKingRankFr player_king_rank = _TranslationsVariablesTableRowsPlayerKingRankFr._(_root);
	@override late final _TranslationsVariablesTableRowsComputerKingFileFr computer_king_file = _TranslationsVariablesTableRowsComputerKingFileFr._(_root);
	@override late final _TranslationsVariablesTableRowsComputerKingRankFr computer_king_rank = _TranslationsVariablesTableRowsComputerKingRankFr._(_root);
	@override late final _TranslationsVariablesTableRowsPieceFileFr piece_file = _TranslationsVariablesTableRowsPieceFileFr._(_root);
	@override late final _TranslationsVariablesTableRowsPieceRankFr piece_rank = _TranslationsVariablesTableRowsPieceRankFr._(_root);
	@override late final _TranslationsVariablesTableRowsApparitionIndexFr apparition_index = _TranslationsVariablesTableRowsApparitionIndexFr._(_root);
	@override late final _TranslationsVariablesTableRowsFirstPieceFileFr first_piece_file = _TranslationsVariablesTableRowsFirstPieceFileFr._(_root);
	@override late final _TranslationsVariablesTableRowsFirstPieceRankFr first_piece_rank = _TranslationsVariablesTableRowsFirstPieceRankFr._(_root);
	@override late final _TranslationsVariablesTableRowsSecondPieceFileFr second_piece_file = _TranslationsVariablesTableRowsSecondPieceFileFr._(_root);
	@override late final _TranslationsVariablesTableRowsSecondPieceRankFr second_piece_rank = _TranslationsVariablesTableRowsSecondPieceRankFr._(_root);
}

// Path: syntax_manual_page.introduction
class _TranslationsSyntaxManualPageIntroductionFr extends TranslationsSyntaxManualPageIntroductionEn {
	_TranslationsSyntaxManualPageIntroductionFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Introduction';
	@override String get part_1 => 'Afin de générer une position, l\'algorithme a besoin de connaître les contraintes à respecter.';
	@override String get part_2 => 'Ces contraintes sont réparties en plusieurs types, et vous avez la possibilité de définir un script pour chaque type.';
	@override String get part_3 => 'Nous reparlerons des contraintes plus tard.';
	@override String get part_4 => 'La syntaxe est un petit sous-ensemble du langage Lua (5.4).';
}

// Path: syntax_manual_page.lua_adaptation
class _TranslationsSyntaxManualPageLuaAdaptationFr extends TranslationsSyntaxManualPageLuaAdaptationEn {
	_TranslationsSyntaxManualPageLuaAdaptationFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Adaptation du langage Lua';
	@override late final _TranslationsSyntaxManualPageLuaAdaptationSupportedTypesFr supported_types = _TranslationsSyntaxManualPageLuaAdaptationSupportedTypesFr._(_root);
	@override late final _TranslationsSyntaxManualPageLuaAdaptationRemovedTypesFr removed_types = _TranslationsSyntaxManualPageLuaAdaptationRemovedTypesFr._(_root);
	@override late final _TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsFr available_syntax_elements = _TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsFr._(_root);
	@override late final _TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsFr removed_syntax_elements = _TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsFr._(_root);
	@override late final _TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsFr available_operators = _TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsFr._(_root);
}

// Path: syntax_manual_page.explaining_generation_algorithm
class _TranslationsSyntaxManualPageExplainingGenerationAlgorithmFr extends TranslationsSyntaxManualPageExplainingGenerationAlgorithmEn {
	_TranslationsSyntaxManualPageExplainingGenerationAlgorithmFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Explication de l\'algorithm de génération';
	@override late final _TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsFr general_considerations = _TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsFr._(_root);
	@override late final _TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsFr order_of_scripts_evaluations = _TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsFr._(_root);
}

// Path: syntax_manual_page.goal_of_position
class _TranslationsSyntaxManualPageGoalOfPositionFr extends TranslationsSyntaxManualPageGoalOfPositionEn {
	_TranslationsSyntaxManualPageGoalOfPositionFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Objectif de la position';
	@override String get part_1 => 'Vous pouvez définir l\'objectif de la position (gagner ou faire nulle).';
	@override String get part_2 => 'Gardez à l\'esprit que cela n\'aura aucune incidence sur l\'algorithme : c\'est juste une information pour le joueur de votre position.';
}

// Path: variables_table.rows.file_a
class _TranslationsVariablesTableRowsFileAFr extends TranslationsVariablesTableRowsFileAEn {
	_TranslationsVariablesTableRowsFileAFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'A\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_b
class _TranslationsVariablesTableRowsFileBFr extends TranslationsVariablesTableRowsFileBEn {
	_TranslationsVariablesTableRowsFileBFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'B\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_c
class _TranslationsVariablesTableRowsFileCFr extends TranslationsVariablesTableRowsFileCEn {
	_TranslationsVariablesTableRowsFileCFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'C\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_d
class _TranslationsVariablesTableRowsFileDFr extends TranslationsVariablesTableRowsFileDEn {
	_TranslationsVariablesTableRowsFileDFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'D\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_e
class _TranslationsVariablesTableRowsFileEFr extends TranslationsVariablesTableRowsFileEEn {
	_TranslationsVariablesTableRowsFileEFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'E\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_f
class _TranslationsVariablesTableRowsFileFFr extends TranslationsVariablesTableRowsFileFEn {
	_TranslationsVariablesTableRowsFileFFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'F\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_g
class _TranslationsVariablesTableRowsFileGFr extends TranslationsVariablesTableRowsFileGEn {
	_TranslationsVariablesTableRowsFileGFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'G\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.file_h
class _TranslationsVariablesTableRowsFileHFr extends TranslationsVariablesTableRowsFileHEn {
	_TranslationsVariablesTableRowsFileHFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne \'H\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_1
class _TranslationsVariablesTableRowsRank1Fr extends TranslationsVariablesTableRowsRank1En {
	_TranslationsVariablesTableRowsRank1Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'1\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_2
class _TranslationsVariablesTableRowsRank2Fr extends TranslationsVariablesTableRowsRank2En {
	_TranslationsVariablesTableRowsRank2Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'2\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_3
class _TranslationsVariablesTableRowsRank3Fr extends TranslationsVariablesTableRowsRank3En {
	_TranslationsVariablesTableRowsRank3Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'3\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_4
class _TranslationsVariablesTableRowsRank4Fr extends TranslationsVariablesTableRowsRank4En {
	_TranslationsVariablesTableRowsRank4Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'4\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_5
class _TranslationsVariablesTableRowsRank5Fr extends TranslationsVariablesTableRowsRank5En {
	_TranslationsVariablesTableRowsRank5Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'5\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_6
class _TranslationsVariablesTableRowsRank6Fr extends TranslationsVariablesTableRowsRank6En {
	_TranslationsVariablesTableRowsRank6Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'6\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_7
class _TranslationsVariablesTableRowsRank7Fr extends TranslationsVariablesTableRowsRank7En {
	_TranslationsVariablesTableRowsRank7Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'7\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.rank_8
class _TranslationsVariablesTableRowsRank8Fr extends TranslationsVariablesTableRowsRank8En {
	_TranslationsVariablesTableRowsRank8Fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée \'8\'';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.king_file
class _TranslationsVariablesTableRowsKingFileFr extends TranslationsVariablesTableRowsKingFileEn {
	_TranslationsVariablesTableRowsKingFileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne du roi';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.king_rank
class _TranslationsVariablesTableRowsKingRankFr extends TranslationsVariablesTableRowsKingRankEn {
	_TranslationsVariablesTableRowsKingRankFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée du roi';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.player_has_white
class _TranslationsVariablesTableRowsPlayerHasWhiteFr extends TranslationsVariablesTableRowsPlayerHasWhiteEn {
	_TranslationsVariablesTableRowsPlayerHasWhiteFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'Le joueur a-t-il les Blancs ?';
	@override String get type => 'Booléen';
}

// Path: variables_table.rows.player_king_file
class _TranslationsVariablesTableRowsPlayerKingFileFr extends TranslationsVariablesTableRowsPlayerKingFileEn {
	_TranslationsVariablesTableRowsPlayerKingFileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne du roi du joueur';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.player_king_rank
class _TranslationsVariablesTableRowsPlayerKingRankFr extends TranslationsVariablesTableRowsPlayerKingRankEn {
	_TranslationsVariablesTableRowsPlayerKingRankFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée du roi du joueur';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.computer_king_file
class _TranslationsVariablesTableRowsComputerKingFileFr extends TranslationsVariablesTableRowsComputerKingFileEn {
	_TranslationsVariablesTableRowsComputerKingFileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée du roi de l\'ordinateur';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.computer_king_rank
class _TranslationsVariablesTableRowsComputerKingRankFr extends TranslationsVariablesTableRowsComputerKingRankEn {
	_TranslationsVariablesTableRowsComputerKingRankFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée du roi de l\'ordinateur';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.piece_file
class _TranslationsVariablesTableRowsPieceFileFr extends TranslationsVariablesTableRowsPieceFileEn {
	_TranslationsVariablesTableRowsPieceFileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne de la pièce';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.piece_rank
class _TranslationsVariablesTableRowsPieceRankFr extends TranslationsVariablesTableRowsPieceRankEn {
	_TranslationsVariablesTableRowsPieceRankFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée de la pièce';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.apparition_index
class _TranslationsVariablesTableRowsApparitionIndexFr extends TranslationsVariablesTableRowsApparitionIndexEn {
	_TranslationsVariablesTableRowsApparitionIndexFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'L\'index d\'ordre d\'apparition de la pièce (commence à 0)';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.first_piece_file
class _TranslationsVariablesTableRowsFirstPieceFileFr extends TranslationsVariablesTableRowsFirstPieceFileEn {
	_TranslationsVariablesTableRowsFirstPieceFileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne de la première pièce';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.first_piece_rank
class _TranslationsVariablesTableRowsFirstPieceRankFr extends TranslationsVariablesTableRowsFirstPieceRankEn {
	_TranslationsVariablesTableRowsFirstPieceRankFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée de la première pièce';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.second_piece_file
class _TranslationsVariablesTableRowsSecondPieceFileFr extends TranslationsVariablesTableRowsSecondPieceFileEn {
	_TranslationsVariablesTableRowsSecondPieceFileFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La colonne de la deuxième pièce';
	@override String get type => 'Entier';
}

// Path: variables_table.rows.second_piece_rank
class _TranslationsVariablesTableRowsSecondPieceRankFr extends TranslationsVariablesTableRowsSecondPieceRankEn {
	_TranslationsVariablesTableRowsSecondPieceRankFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get description => 'La rangée de la deuxième pièce';
	@override String get type => 'Entier';
}

// Path: syntax_manual_page.lua_adaptation.supported_types
class _TranslationsSyntaxManualPageLuaAdaptationSupportedTypesFr extends TranslationsSyntaxManualPageLuaAdaptationSupportedTypesEn {
	_TranslationsSyntaxManualPageLuaAdaptationSupportedTypesFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Types supportés';
	@override String get part_1 => '*) Integer';
	@override String get part_2 => '*) Boolean';
}

// Path: syntax_manual_page.lua_adaptation.removed_types
class _TranslationsSyntaxManualPageLuaAdaptationRemovedTypesFr extends TranslationsSyntaxManualPageLuaAdaptationRemovedTypesEn {
	_TranslationsSyntaxManualPageLuaAdaptationRemovedTypesFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Types supprimés';
	@override String get part_1 => '*) Float';
	@override String get part_2 => '*) String';
	@override String get part_3 => '*) Array';
	@override String get part_4 => '*) Map';
}

// Path: syntax_manual_page.lua_adaptation.available_syntax_elements
class _TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsFr extends TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsEn {
	_TranslationsSyntaxManualPageLuaAdaptationAvailableSyntaxElementsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Éléments de syntaxe disponibles';
	@override String get part_1 => '*) affectation';
	@override String get part_2 => '*) instruction if (attention : l\'instruction if n\'est pas une expression)';
}

// Path: syntax_manual_page.lua_adaptation.removed_syntax_elements
class _TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsFr extends TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsEn {
	_TranslationsSyntaxManualPageLuaAdaptationRemovedSyntaxElementsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Éléments de syntaxe supprimés';
	@override String get part_1 => '*) instructions boucles';
	@override String get part_2 => '*) fonctions';
	@override String get part_3 => '*) coroutines';
}

// Path: syntax_manual_page.lua_adaptation.available_operators
class _TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsFr extends TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsEn {
	_TranslationsSyntaxManualPageLuaAdaptationAvailableOperatorsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Opérateurs disponibles';
	@override String get part_1 => '*) parenthèses';
	@override String get part_2 => '*) + - * / ^ % //';
	@override String get part_3 => '*) > >= < <= ~= ==';
	@override String get part_4 => '*) not and  or';
	@override String get part_5 => '*) & | ~ << >>';
}

// Path: syntax_manual_page.explaining_generation_algorithm.general_considerations
class _TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsFr extends TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsEn {
	_TranslationsSyntaxManualPageExplainingGenerationAlgorithmGeneralConsiderationsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Considérations générales';
	@override String get part_1_1 => 'L\'algorithme commence avec un échiquier vide, et essaie de placer chaque pièce l\'une après l\'autre.';
	@override String get part_1_2 => 'Bien sûr, il vérifie aussi que les règles générales du jeu d\'échecs soient respectées.';
	@override String get part_1_3 => 'Mais il vérifie aussi que, pour chaque type de pièce, les contraintes - s\'il y en a - définies pour lui soient respectées.';
	@override String get part_1_4 => 'Par type de pièce, nous voulons dire, par exemple, une Tour de l\'Ordinateur, ou un Pion du Joueur.';
	@override String get part_2_1 => 'Donc chaque contrainte est écrite dans un script, écrit dans un sous-ensemble de Lua comme expliqué plus tôt.';
	@override String get part_2_2 => 'Chaque script a accès à un certain nombre de variables prédéfinies, dont les valeurs seront fournies par l\'algorithme, mais aussi des constantes pour les coordonnées.';
	@override String get part_2_3 => 'Vous pouvez accéder aux variables prédéfines et constantes de chaque type de script, et insérer leurs noms, en accédant à la boîte d\'aide pour le type de script en cours d\'édition.';
	@override String get part_2_4 => 'Mais, avant tout - et c\'est de cette manière que l\'algorithme saura si vos contraintes sont respectées - chaque script doit retourner une valeur booléenne.';
	@override String get part_3_1 => 'Si à une étape quelconque, les contraintes pour la dernière pièce mise en place ne sont pas respectées, l\'algorithme esseaira de la placer ailleurs.';
	@override String get part_3_2 => 'Cela permet donc d\'éviter de repartir de zéro à chaque échec.';
}

// Path: syntax_manual_page.explaining_generation_algorithm.order_of_scripts_evaluations
class _TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsFr extends TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsEn {
	_TranslationsSyntaxManualPageExplainingGenerationAlgorithmOrderOfScriptsEvaluationsFr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ordre d\'évaluation des scripts';
	@override String get part_1_1 => 'Les premières étapes de l\'algorithmes sont très simples:';
	@override String get part_1_2 => '*) il commence par placer le roi du joueur, et se sert du script de contraintes du roi du joueur si défini pour une vérification';
	@override String get part_1_3 => '*) il place ensuite le roi de l\'ordinateur, et se sert du script de contraintes du roi de l\'ordinateur, et aussi du script de contraintes mutuelles entre les rois';
	@override String get part_2_1 => 'Les étapes suivantes sont un peu plus complexes. Il se sert d\'abord des contraintes de compte des autres types de pièces afin de savoir combien il doit en générer.';
	@override String get part_2_2 => 'Ensuite, pour chaque type de pièce donné, il en place une par une et efféctue un certain nombre de vérifications :';
	@override String get part_2_3 => '*) il utilise les contraintes globales pour ce type de pièces, afin de voir si les contraintes générales pour ce type de pièce sont respectées';
	@override String get part_2_4 => '*) il utilise les contraintes indexées pour ce type de pièces, afin de voir si les contraintes relatives à l\'ordre d\'apparition de la pièce dans son groupe de type de pièces sont respectées';
	@override String get part_2_5 => '*) il utilise les contraintes mutuelles pour ce type de pièces, afin de voir si les contraintes relatives à deux pièces de même type de pièce sont respectées entre elles';
}
