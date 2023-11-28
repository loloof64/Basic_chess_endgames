/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 723 (241 per locale)
///
/// Built on 2023-11-28 at 15:55 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, _TranslationsEn> {
	en(languageCode: 'en', build: _TranslationsEn.build),
	es(languageCode: 'es', build: _TranslationsEs.build),
	fr(languageCode: 'fr', build: _TranslationsFr.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, _TranslationsEn> build;

	/// Gets current instance managed by [LocaleSettings].
	_TranslationsEn get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
_TranslationsEn get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
class Translations {
	Translations._(); // no constructor

	static _TranslationsEn of(BuildContext context) => InheritedLocaleData.of<AppLocale, _TranslationsEn>(context).translations;
}

/// The provider for method B
class TranslationProvider extends BaseTranslationProvider<AppLocale, _TranslationsEn> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, _TranslationsEn> of(BuildContext context) => InheritedLocaleData.of<AppLocale, _TranslationsEn>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	_TranslationsEn get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, _TranslationsEn> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, _TranslationsEn> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// interfaces generated as mixins

mixin PageData2 {
	String get title;
	String? get content => null;

	@override
	bool operator ==(Object other) => other is PageData2 && title == other.title && content == other.content;

	@override
	int get hashCode => title.hashCode * content.hashCode;
}

// translations

// Path: <root>
class _TranslationsEn implements BaseTranslations<AppLocale, _TranslationsEn> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, _TranslationsEn> $meta;

	late final _TranslationsEn _root = this; // ignore: unused_field

	// Translations
	late final _TranslationsMiscEn misc = _TranslationsMiscEn._(_root);
	late final _TranslationsHomeEn home = _TranslationsHomeEn._(_root);
	late final _TranslationsExplorerEn explorer = _TranslationsExplorerEn._(_root);
	late final _TranslationsRgpdEn rgpd = _TranslationsRgpdEn._(_root);
	late final _TranslationsGamePageEn game_page = _TranslationsGamePageEn._(_root);
	late final _TranslationsScriptParserEn script_parser = _TranslationsScriptParserEn._(_root);
	late final _TranslationsScriptTypeEn script_type = _TranslationsScriptTypeEn._(_root);
	late final _TranslationsSampleScriptEn sample_script = _TranslationsSampleScriptEn._(_root);
	late final _TranslationsPrivacyEn privacy = _TranslationsPrivacyEn._(_root);
	late final _TranslationsUseConditionsEn use_conditions = _TranslationsUseConditionsEn._(_root);
	late final _TranslationsScriptEditorPageEn script_editor_page = _TranslationsScriptEditorPageEn._(_root);
	late final _TranslationsSyntaxManualPageEn syntax_manual_page = _TranslationsSyntaxManualPageEn._(_root);
}

// Path: misc
class _TranslationsMiscEn {
	_TranslationsMiscEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get app_title => 'Basic chess endgames';
	String get button_ok => 'Ok';
	String get button_cancel => 'Cancel';
	String get button_accept => 'Accept';
	String get button_deny => 'Deny';
	String get button_validate => 'Validate';
}

// Path: home
class _TranslationsHomeEn {
	_TranslationsHomeEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get failed_loading_exercise => 'Failed to load exercise : the chess position is not valid.';
	String get failed_generating_position => 'Failed to generate the position.';
	String get max_generation_attempts_achieved => 'Impossible to generate a position from these scripts : maximum generation attempts surpassed.\n\nPlease check that your constraints aren\'t too restrictive.\n\nAlso, please check that all of your variables are declared before use.';
	String get samples_help_message => 'Here you can select the type of position you want to play with.\nA line which leading icon is a trophy will generate a position in which you should win.\nOtherwise, with a handshake leading icon, your goal will be to save the game and make draw.\n\nYou can also see the code of an example, or even clone it into current folder of customs exercises section, by making a long press on it.';
	String get custom_scripts_help_message => 'Here you can create and run your custom exercises (with a single press on it).\n\nYou can also edit/rename/delete a single exercise with a long press on it.\n\nYou can also add/rename/delete folders.';
	String get tab_integrated => 'Integrated';
	String get tab_added => 'Added';
	String get no_game_yet => 'No element';
	String get failed_loading_added_exercises => 'Failed to load custom exercises list';
	String get misc_generating_error => 'Failed to generate the position for a miscellaneous error.';
	String get contextual_menu_file_delete => 'Delete';
	String get contextual_menu_file_rename => 'Rename';
	String get contextual_menu_file_edit => 'Edit';
	String get contextual_menu_rename_folder => 'Rename';
	String get contextual_menu_folder_delete => 'Delete';
	String get contextual_menu_see_sample_code => 'See code';
	String get contextual_menu_clone_sample_code => 'Cloner dans les exercices ajoutés';
	String get confirm_delete_file_title => 'Delete file ?';
	String confirm_delete_file_msg({required Object Name}) => 'Do you want to delete the file \'${Name}\' ?';
	String get confirm_delete_folder_title => 'Delete folder ?';
	String confirm_delete_folder_msg({required Object Name}) => 'Do you want to delete the folder \'${Name}\' ?';
	String get file_name_already_taken => 'This name is already in use.';
	String get new_folder_prompt => 'Name : ';
	String get rename_folder_prompt => 'New name : ';
	String get loading_content => 'Loading ...';
	String get root_directory => '\'Root\'';
	String get protected_folder => 'Protected folder';
	String cloned_sample_exercise({required Object Name}) => 'Cloned sample under name ${Name}.';
	String get contextual_menu_file_export => 'Export';
	String get export_script_title => 'Export';
	String get documents_directory => 'Documents';
	String get external_storage => 'External storage';
	String get script_exported => 'Script has been exported';
	String get import_file_menu => 'Import file';
	String get import_folder_menu => 'Import folder';
	String get no_external_storage => 'No SD card found';
}

// Path: explorer
class _TranslationsExplorerEn {
	_TranslationsExplorerEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get failed_loading_content => 'Failed to load content';
	String get save_file_prompt => 'Name : ';
	String get empty_item_name => 'You must specify a name.';
	String get new_folder_title => 'Add a new folder';
	String get new_folder_prompt => 'Name : ';
	String get folder_already_exists => 'This name is already in use.';
}

// Path: rgpd
class _TranslationsRgpdEn {
	_TranslationsRgpdEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get text => 'By using this app, you agree with :';
	String get privacy => 'the Privacy Policy';
	String get use_conditions => 'the Use Conditions';
}

// Path: game_page
class _TranslationsGamePageEn {
	_TranslationsGamePageEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

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
class _TranslationsScriptParserEn {
	_TranslationsScriptParserEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String variable_not_affected({required Object Name}) => 'The variable ${Name} has been used before having been defined.';
	String unrecognized_symbol({required Object Symbol}) => 'Unrecognized symbol ${Symbol}.';
	String input_mismatch({required Object Line, required Object Index, required Object Expected, required Object Received}) => 'Bad input at line ${Line}: character number ${Index}. You should have set ${Expected} but I got ${Received}.';
	String no_viable_alt_exception({required Object Token, required Object LineNumber, required Object PositionInLine}) => 'The input ${Token} does not match any rule. (Line ${LineNumber}, character number ${PositionInLine})';
	String get misc_parse_error => 'Miscellaneous parsing error.';
	String get no_antlr4_token => '[No occurence]';
	String get eof => '[EndOfFile]';
	String overriding_predefined_variable({required Object Name}) => 'You try to change the value of predefined variable ${Name}.';
	String parse_error_dialog_title({required Object Title}) => 'Script error for ${Title}';
	String get type_error => 'Please check that you don\'t use int value instead of boolean value and vice versa.';
	String get missing_script_type => 'Failed to generate position : please check that all of the script sections declares a correct script type.';
	String unrecognized_script_type({required Object Type}) => 'Unrecognized script type : ${Type}.';
	String get misc_error_dialog_title => 'Global error';
	String get misc_checking_error => 'The errors checking has failed for a miscellaneous error.';
}

// Path: script_type
class _TranslationsScriptTypeEn {
	_TranslationsScriptTypeEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get player_king_constraint => 'Player king constraint';
	String get computer_king_constraint => 'Computer king constraint';
	String get kings_mutual_constraint => 'Kings mutual constraint';
	String get other_pieces_global_constraint => 'Other pieces global constraint';
	String get other_pieces_indexed_constraint => 'Other pieces constraints by order';
	String get other_pieces_mutual_constraint => 'Other pieces mutual constraint';
	String get piece_kind_count_constraint => 'Piece kinds counts constraint';
}

// Path: sample_script
class _TranslationsSampleScriptEn {
	_TranslationsSampleScriptEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get kq_k => 'King + Queen Vs King';
	String get kr_k => 'King + Rook Vs King';
	String get krr_k => 'King + 2 Rooks Vs King';
	String get kbb_k => 'King + Rook Vs King';
	String get kp_k1 => 'King + Pawn Vs King (1)';
	String get kp_k2 => 'King + Pawn Vs King (2)';
	String get kppp_kppp => 'King + 3 Pawns Vs King + 3 Pawns';
	String get rook_ending_lucena => 'Lucena rook ending';
	String get rook_ending_philidor => 'Philidor rook ending';
}

// Path: privacy
class _TranslationsPrivacyEn {
	_TranslationsPrivacyEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Privacy policy';
	String get content1 => 'This page is used to inform you regarding the policies with the collection, use and disclosure of personal information for the app, Basic Chess Endgames. I respect the privacy of users and I am committed to protect the user\'s information, be it yours or your children\'s. I believe that you have a right to know my practices regarding the information I may collect and use when you use my app.';
	String get content2 => 'Privacy of my product users is important to me. I do not collect any identifiable information about my users. I do not store or transmit any personal information.';
	String get content3 => 'If you have any questions about this Privacy Policy please contact me at laurent.bernabe@gmail.com.';
}

// Path: use_conditions
class _TranslationsUseConditionsEn {
	_TranslationsUseConditionsEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Use conditions';
	String get content => 'No particular use condition is required for Basic Chess Endgames This application is only targeted to help chess players to improve their play, and do not include any content that could be harmful, violent or shocking.';
}

// Path: script_editor_page
class _TranslationsScriptEditorPageEn {
	_TranslationsScriptEditorPageEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Script editor page';
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
	String exercise_creation_success({required Object Name}) => 'Saved exercise under name ${Name}.';
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Scripts\' syntax';
	String get table_header_variable_name => 'Name';
	String get table_header_variable_type => 'Type';
	String get table_header_variable_use => 'Use';
	String get scripts_goal => 'Scripts\' goal';
	String get scripts_kinds => 'Scripts kinds';
	String get scripts_format => 'Scripts\' format';
	String get comments => 'Comments';
	String get variables => 'Variables';
	String get predefined_variables => 'Predefined variables';
	String get int_expressions => 'Integer expressions';
	String get bool_expressions => 'Boolean expressions';
	String get scripts_goal_description => 'A position generation script is split into several sub-scripts, each of its own kind and in a custom language, whose following sections will help you to understand.\n\nA sub-script\'s goal is to check that the generated position follow all of its constraints.\n\nIf at least one condition is not met, then the algorithm will try to \'fix\' the position so that all conditions are met.';
	String get scripts_kinds_head_description => 'There are several types of sub-scripts, and all rules of all defined sub-scripts must be respected by the generated position.\n\nOf course, it must also respect standard chess rules (for example : king of side not in turn musn\'t be in chess).\n\n';
	String get scripts_kinds_player_king_constraint_title => 'Player\'s king\'s constraints\n\n';
	String get scripts_kinds_player_king_constraint_description => 'Tells about the positioning constraints on the players\'s king (given that the player\'s color will be randomly choosen).\n\n';
	String get scripts_kinds_computer_king_constraint_title => 'Computer\'s king\'s constraints\n\n';
	String get scripts_kinds_computer_king_constraint_description => 'Tells about the positioning constraints on the computer\'s king (given that the player\'s color will be randomly choosen).\n\n';
	String get scripts_kinds_kings_mutual_constraints_title => 'Kings\'s mutual constraints\n\n';
	String get scripts_kinds_kings_mutual_constraints_description => 'Tells about the positioning constraints that both kings must respect between them.\n\n';
	String get scripts_kinds_other_pieces_count_constraints_title => 'Other pieces counts\' constraints\n\n';
	String get scripts_kinds_other_pieces_count_constraints_description => 'Tells about the counts\' constraints on pieces other than kings.\n\n';
	String get scripts_kinds_other_pieces_global_constraints_title => 'Other pieces\' global constraints\n\n';
	String get scripts_kinds_other_pieces_global_constraints_description => 'Tells about the positioning constraints for pieces other by kings, for each couple [type of piece / is it a player piece ?].\n\n';
	String get scripts_kinds_other_pieces_mutual_constraints_title => 'Other pieces\' mutual constraints\n\n';
	String get scripts_kinds_other_pieces_mutual_constraints_description => 'Tells about the positioning constraints for pieces other by kings, that they must respect between each other, two by two, for each couple [type of piece / is it a player piece ?].\n\n';
	String get scripts_kinds_other_pieces_indexed_constraints_title => 'Other pieces constraints by order\n\n';
	String get scripts_kinds_other_pieces_indexed_constraints_description => 'Tells about the positioning constraints for pieces other than kings, that they must respect given their apparition order on the chess board, for each couple [type of piece / is it a player piece ?].\n\n';
	String get scripts_format_head_description => 'Each script may start with one or several variables creation statements.\n\nBut the final expression must be a statement that returns a boolean expression.\n\nThis return expression will be used by the algorithm in order to check that the generated position is correct.\n\nPlease take into account that a statement can expand on several lines : they end as soon as the character \';\' is met.\n\nAlso, beware of the case sensitivity : uppercase or lowercase can make the difference.\n\n At last, in each sub-script, you should check that you don\'t use an undeclared variable : though your code will be accepted, it will always fail to generate the position.\n\n';
	String get scripts_format_main_description_1 => 'This is the syntax for the return expression :\n\n';
	String get scripts_format_code_section_1 => 'return [your boolean expression];\n\n';
	String get scripts_format_main_description_2 => 'This is a simple script sample :\n\n';
	String get scripts_comments_head_description => 'You can use two forms of comments, which are inspired by comments from the C language.\n\n';
	String get scripts_comments_multiline_comments_title => 'Multilines comments\n\n';
	String get scripts_comments_multiline_comments_description => 'A multiline comment starts with \'/*\' and ends with \'*/\', and can expand on several lines.\n\n';
	String get scripts_comments_multiline_comments_sample => '/* This is a\n multilines comment.\n\nAnd can expand on several lines.*/\n\n';
	String get scripts_comments_single_line_comments_title => 'Single line comments\n\n';
	String get scripts_comments_single_line_comments_description_1 => 'A single line comment can only be on a single line, and just starts by \'//\'.\n\nSo all following characters of the given line are parts of the comment.\n\n';
	String get scripts_comments_single_line_comments_sample_1 => '// This is a single line comment\n\n';
	String get scripts_comments_single_line_comments_description_2 => 'A single line comment can also follow a statement on the same line.\n\n';
	String get scripts_comments_single_line_comments_sample_2 => 'myIntVariable := FileF; // Sets to the value of the F file\n\n';
	String get scripts_variables_head_description => 'These are things to consider about variables :\n\n';
	String get scripts_variables_name_rules_title => 'Naming rules\n\n';
	String get scripts_variables_name_rules_description => 'A variable name must start with a letter (either uppercase or lowercase).\n\nThen the following characters can be letters (uppercase and/or lowercase), digits or underscore (\'_\').\n\nAlso keep in mind that you can\'t use name of predifined value or of a predefined variable (given that each script type, as you\'ll see later, has its own set of predefined variables).\n\n';
	String get scripts_variables_creation_title => 'Variable creation statement\n\n';
	String get scripts_variables_creation_description => 'This is the syntax for creating either an int variable or a boolean variable :\n\n';
	String get scripts_variables_creation_format => '[identifier] := [int expression | boolean expression];\n\n';
	String get scripts_variables_creation_sample_head_text => 'This is an example :\n\n';
	String get scripts_variables_creation_sample_code => 'myRank := boolIf(kingsInOpposition) then Rank4 else Rank1;\n\n';
	String get scripts_predefined_variables_head_description => 'The predefined variables relies on the kind of sub-script we\'re editing.\n\nThese variables will be fed by the algorithm when checking for the generated position\'s correctness.\n\nOf course, you can\'t name a custom variable with one of those names.\n\nAlso, keep in mind that chess board\'s coordinates values take board\'s orientation into account.\n\n';
	String get scripts_predefined_variables_single_king_constraints_title => 'Player\'s king\'s constraint / Computer king\'s constraint\n\n';
	String get scripts_predefined_variables_single_king_constraints_variable_file => 'the file which has been set for the king';
	String get scripts_predefined_variables_single_king_constraints_variable_rank => 'the rank which has been set for the king';
	String get scripts_predefined_variables_single_king_constraints_variable_player_has_white => 'does the player have white pieces ?';
	String get scripts_predefined_variables_mutual_kings_constraints_title => '\n\nMutual kings\' constraints\n\n';
	String get scripts_predefined_variables_single_king_constraints_variable_file_player => 'the file which has been set for the player\'s king';
	String get scripts_predefined_variables_single_king_constraints_variable_rank_player => 'the rank which has been set for the player\'s king';
	String get scripts_predefined_variables_single_king_constraints_variable_file_computer => 'the file which has been set for the computer\'s king';
	String get scripts_predefined_variables_single_king_constraints_variable_rank_computer => 'the rank which has been set for the computer\'s king';
	String get scripts_predefined_variables_other_pieces_global_constraints_title => '\n\nOthers pieces globals contraints\n\n';
	String get scripts_predefined_variables_other_pieces_global_constraints_file => 'the file which has been set for the piece';
	String get scripts_predefined_variables_other_pieces_global_constraints_rank => 'the rank which has been set for the piece';
	String get scripts_predefined_variables_other_pieces_mutual_constraints_title => '\n\nOther pieces mutual constraints\n\n';
	String get scripts_predefined_variables_other_pieces_mutual_constraints_file_first => 'the file which has been set for the first piece';
	String get scripts_predefined_variables_other_pieces_mutual_constraints_rank_first => 'the file which has been set for the first piece';
	String get scripts_predefined_variables_other_pieces_mutual_constraints_file_second => 'the file which has been set for the second piece';
	String get scripts_predefined_variables_other_pieces_mutual_constraints_rank_second => 'the file which has been set for the second piece';
	String get scripts_predefined_variables_other_pieces_indexed_constraints_title => '\n\nOthers pieces\' constraints by order\n\n';
	String get scripts_predefined_variables_other_pieces_indexed_constraints_apparition => 'the index (starting at 0) of apparition on the board';
	String get int_expressions_head_description => 'An integer expression is simply an expression whose final produced value is an integer.\n\n';
	String get int_expression_parenthesis_title => 'Parenthesis\n\n';
	String get int_expression_parenthesis_description => 'Useful for isolating an integer expression, so that it will be computed in priority.\n\n';
	String get int_expression_parenthesis_syntax => '([integer expression])\n\n';
	String get int_expression_parenthesis_sample_text => 'An example :\n\n';
	String get int_expression_conditional_title => 'Conditional expression\n\n';
	String get int_expression_conditional_description => 'For producing expressions conditionnaly.\n\nBeware of the \'numIf\' keyword.\n\n';
	String get int_expression_conditional_syntax => 'numIf([boolean expression]) then [integer expression] else [integer expression]\n\n';
	String get int_expression_absolute_title => 'Absolute value\n\n';
	String get int_expression_absolute_description => 'Produces the absolute value of the given expression.\n\n';
	String get int_expression_absolute_syntax => 'abs([integer expression])\n\n';
	String get int_expression_modulo_title => 'Modulo expression\n\n';
	String get int_expression_modulo_description => 'Produces the modulo value of the given expression.\n\n It\'s the remainder of the division of the first operand by the second.\n\n';
	String get int_expression_modulo_syntax => '[integer expression] % [integer expression]\n\n';
	String get int_expression_modulo_sample_code => 'myIntVariable % 2\n\n';
	String get int_expression_arithmetic_title => 'Arithmetic operators\n\n';
	String get int_expression_arithmetic_description => 'There are two arithmetic operators available: \'+\' and \'-\'.\n\n';
	String get int_expression_arithmetic_syntax_1 => '[integer expression] + [integer expression]\n';
	String get int_expression_arithmetic_syntax_or => 'or\n';
	String get int_expression_arithmetic_syntax_2 => '[integer expression] - [integer expression]\n\n';
	String get int_expression_literal_title => 'Literals\n\n';
	String get int_expression_literal_description => 'You can use literal values (1, 25, 150 for example).\n\n';
	String get int_expression_variable_title => 'Variables\n\n';
	String get int_expression_variable_description => 'Integer variables are also expressions.\n\n';
	String get int_expression_predefined_values_title => 'Predefined values\n\n';
	String get int_expression_predefined_values_description => 'All sub-scripts have the same predefined integer values (you can\'t name a variable with one of those names).\n\nAll of these values takes the chess board\'s orientation into account.\n\nThese are predefined integer values for the chess board files : FileA, FileB, FileC, FileD, FileE, FileF, FileG, FileH.\n\nThese are predefined integer values for the chess board ranks : Rank1, Rank2, Rank3, Rank4, Rank5, Rank6, Rank7, Rank8.\n\n';
	String get bool_expressions_head_description => 'An boolean expression is simply an expression whose final produced value is a boolean.\n\nNotice that there are no boolean litterals : you can\'t use true or false keywords.\n\n';
	String get bool_expression_parenthesis_title => 'Parenthesis\n\n';
	String get bool_expression_parenthesis_description => 'Useful for isolating an boolean expression, so that it will be computed in priority.\n\n';
	String get bool_expression_parenthesis_syntax => '([boolean expression])\n\n';
	String get bool_expression_conditional_title => 'Conditional expression\n\n';
	String get bool_expression_conditional_description => 'For producing expressions conditionnaly.\n\nBeware of the \'boolIf\' keyword.\n\n';
	String get bool_expression_conditional_syntax => 'boolIf([boolean expression]) then [boolean expression] else [boolean expression]\n\n';
	String get bool_expression_variable_title => 'Variables\n\n';
	String get bool_expression_variable_description => 'Boolean variables are also expressions.\n\n';
	String get bool_expression_integer_comparation_title => 'Integers comparation\n\n';
	String get bool_expression_integer_comparation_description => 'You can compare two integer values.\n\n \'==\' is for equality and \'!=\' is for difference.\n\n';
	String get bool_expression_integer_comparation_syntax_1 => '[integer expression] < [integer expression]\n\n';
	String get bool_expression_integer_comparation_syntax_2 => '[integer expression] > [integer expression]\n\n';
	String get bool_expression_integer_comparation_syntax_3 => '[integer expression] <= [integer expression]\n\n';
	String get bool_expression_integer_comparation_syntax_4 => '[integer expression] >= [integer expression]\n\n';
	String get bool_expression_integer_comparation_syntax_5 => '[integer expression] == [integer expression]\n\n';
	String get bool_expression_integer_comparation_syntax_6 => '[integer expression] != [integer expression]\n\n';
	String get bool_expression_boolean_comparation_title => 'Boolean comparation\n\n';
	String get bool_expression_boolean_comparation_description => 'You can compare two boolean values.\n\n\'<==>\' is for equality and \'<!=>\' is for difference.\n\n';
	String get bool_expression_boolean_comparation_syntax_1 => '[boolean expression] <==> [boolean expression]\n\n';
	String get bool_expression_boolean_comparation_syntax_2 => '[boolean expression] <!=> [boolean expression]\n\n';
	String get bool_expression_logical_operators_title => 'Logical operators\n\n';
	String get bool_expression_logical_operators_description => 'There are two available logical operators.\n\n';
	String get bool_expression_logical_operators_syntax_1 => '[boolean expression] and [boolean expression]\n\n';
	String get bool_expression_logical_operators_syntax_2 => '[boolean expression] or [boolean expression]\n\n';
}

// Path: <root>
class _TranslationsEs extends _TranslationsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsEs.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, _TranslationsEn> $meta;

	@override late final _TranslationsEs _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsMiscEs misc = _TranslationsMiscEs._(_root);
	@override late final _TranslationsHomeEs home = _TranslationsHomeEs._(_root);
	@override late final _TranslationsExplorerEs explorer = _TranslationsExplorerEs._(_root);
	@override late final _TranslationsRgpdEs rgpd = _TranslationsRgpdEs._(_root);
	@override late final _TranslationsGamePageEs game_page = _TranslationsGamePageEs._(_root);
	@override late final _TranslationsScriptParserEs script_parser = _TranslationsScriptParserEs._(_root);
	@override late final _TranslationsScriptTypeEs script_type = _TranslationsScriptTypeEs._(_root);
	@override late final _TranslationsSampleScriptEs sample_script = _TranslationsSampleScriptEs._(_root);
	@override late final _TranslationsPrivacyEs privacy = _TranslationsPrivacyEs._(_root);
	@override late final _TranslationsUseConditionsEs use_conditions = _TranslationsUseConditionsEs._(_root);
	@override late final _TranslationsScriptEditorPageEs script_editor_page = _TranslationsScriptEditorPageEs._(_root);
	@override late final _TranslationsSyntaxManualPageEs syntax_manual_page = _TranslationsSyntaxManualPageEs._(_root);
}

// Path: misc
class _TranslationsMiscEs extends _TranslationsMiscEn {
	_TranslationsMiscEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get app_title => 'Finales básicos de ajedrez';
	@override String get button_ok => 'De acuerdo';
	@override String get button_cancel => 'Anular';
	@override String get button_accept => 'Aceptar';
	@override String get button_deny => 'Rechazar';
	@override String get button_validate => 'Validar';
}

// Path: home
class _TranslationsHomeEs extends _TranslationsHomeEn {
	_TranslationsHomeEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inicio';
	@override String get failed_loading_exercise => 'No se pudo cargar el ejercicio: la posición de ajedrez no es válida.';
	@override String get max_generation_attempts_achieved => 'Es imposible generar una posición a partir de estos guiones: se han superado los intentos máximos de generación.\n\nComprueba que tus restricciones no sean demasiado restrictivas.\n\nAdemás, por favor, asegúrate de que todas tus variables estén declaradas antes de usarlas.';
	@override String get failed_generating_position => 'Falló al generar la posición.';
	@override String get samples_help_message => 'Aquí puedes seleccionar el tipo de posición con la que quieres jugar.\nUna línea cuyo icono principal es un trofeo generará una posición en la que deberías ganar.\nDe lo contrario, con un icono principal de un apretón de manos, tu objetivo será salvar la partida y hacer empate.\n\nTambién puedes ver el código de un ejemplo, o incluso clonarlo en la carpeta actual de la sección de ejercicios de aduanas, presionándolo durante unos segundos.';
	@override String get custom_scripts_help_message => 'Aquí puedes crear y ejecutar tus ejercicios personalizados (con una sola pulsación en ello).\n\n También puedes editar/renombrar/eliminar un ejercicio individual con una pulsación larga sobre él.\n\n También puedes añadir/renombrar/eliminar carpetas.';
	@override String get tab_integrated => 'Integrados';
	@override String get tab_added => 'Añadidos';
	@override String get no_game_yet => 'No hay elemento';
	@override String get failed_loading_added_exercises => 'Error al cargar la lista de ejercicios personalizados';
	@override String get misc_generating_error => 'Error al generar la posición para un error misceláneo.';
	@override String get contextual_menu_file_delete => 'Borrar';
	@override String get contextual_menu_file_rename => 'Renombrar';
	@override String get contextual_menu_file_edit => 'Editar';
	@override String get contextual_menu_rename_folder => 'Renombrar';
	@override String get contextual_menu_folder_delete => 'Borrar';
	@override String get contextual_menu_see_sample_code => 'Ver código';
	@override String get contextual_menu_clone_sample_code => 'Clonar en los ejercicios añadidos';
	@override String get confirm_delete_file_title => 'Borrar el archivo ?';
	@override String confirm_delete_file_msg({required Object Name}) => '¿Quieres borrar el archivo \'${Name}\'?';
	@override String get confirm_delete_folder_title => '¿Borrar la carpeta?';
	@override String confirm_delete_folder_msg({required Object Name}) => '¿Quieres borrar la carpeta \'${Name}\'?';
	@override String get file_name_already_taken => 'Este nombre ya está en uso.';
	@override String get new_folder_prompt => 'Nombre :';
	@override String get rename_folder_prompt => 'Nuevo nombre : ';
	@override String get loading_content => 'Cargando ...';
	@override String get root_directory => '\'Raíz\'';
	@override String get protected_folder => 'Carpeta protegida';
	@override String cloned_sample_exercise({required Object Name}) => 'Muestra clonada con el nombre ${Name}.';
	@override String get contextual_menu_file_export => 'Exportar';
	@override String get export_script_title => 'Exportar';
	@override String get documents_directory => 'Documentos';
	@override String get external_storage => 'Almacenamiento externo';
	@override String get script_exported => 'El script se ha exportado';
	@override String get import_file_menu => 'Importar archivo';
	@override String get import_folder_menu => 'Importar carpeta';
	@override String get no_external_storage => 'No hay tarjetas SD';
}

// Path: explorer
class _TranslationsExplorerEs extends _TranslationsExplorerEn {
	_TranslationsExplorerEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get failed_loading_content => 'Error al cargar el contenido';
	@override String get save_file_prompt => 'Nombre:';
	@override String get empty_item_name => 'Debe especificar un nombre.';
	@override String get new_folder_title => 'Añadir una nueva carpeta';
	@override String get new_folder_prompt => 'Nombre:';
	@override String get folder_already_exists => 'Este nombre ya está en uso.';
}

// Path: rgpd
class _TranslationsRgpdEs extends _TranslationsRgpdEn {
	_TranslationsRgpdEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get text => 'Al utilizar esta aplicación, estás de acuerdo con:';
	@override String get privacy => 'la Política de Privacidad';
	@override String get use_conditions => 'las Condiciones de Uso';
}

// Path: game_page
class _TranslationsGamePageEs extends _TranslationsGamePageEn {
	_TranslationsGamePageEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

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
class _TranslationsScriptParserEs extends _TranslationsScriptParserEn {
	_TranslationsScriptParserEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String variable_not_affected({required Object Name}) => 'La variable ${Name} se ha utilizado antes de haber sido definida.';
	@override String unrecognized_symbol({required Object Symbol}) => 'Símbolo no reconocido ${Symbol}.';
	@override String input_mismatch({required Object Line, required Object Index, required Object Expected, required Object Received}) => 'Entrada incorrecta en la línea ${Line}:carácter número ${Index}.Deberías haber establecido ${Expected} pero obtuve ${Received}.';
	@override String no_viable_alt_exception({required Object Token, required Object LineNumber, required Object PositionInLine}) => 'La entrada ${Token} no coincide con ninguna regla. (Línea ${LineNumber}, número de carácter ${PositionInLine})';
	@override String get misc_parse_error => 'Error de análisis variado.';
	@override String get no_antlr4_token => '[Sin ocurrencia]';
	@override String get eof => '[FinDeArchivo]';
	@override String overriding_predefined_variable({required Object Name}) => 'Intentas cambiar el valor de la variable predefinida ${Name}.';
	@override String parse_error_dialog_title({required Object Title}) => 'Error de guione para ${Title}';
	@override String get type_error => 'Por favor, compruebe que no utiliza un valor int en lugar de un valor booleano y viceversa.';
	@override String get missing_script_type => 'No se pudo generar la posición: compruebe que todas las secciones del guione declaran un tipo de guione correcto.';
	@override String unrecognized_script_type({required Object Type}) => 'Tipo de escritura no reconocido: ${Type}.';
	@override String get misc_error_dialog_title => 'Equivocado global';
	@override String get misc_checking_error => 'La verificación de errores ha fallado debido a un error misceláneo.';
}

// Path: script_type
class _TranslationsScriptTypeEs extends _TranslationsScriptTypeEn {
	_TranslationsScriptTypeEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get player_king_constraint => 'Restricción sobre rey del jugador';
	@override String get computer_king_constraint => 'Restricción sobre rey de la computadora';
	@override String get kings_mutual_constraint => 'Restricción mutua de reyes';
	@override String get other_pieces_global_constraint => 'Restricción global de otras piezas';
	@override String get other_pieces_indexed_constraint => 'Restricción indexada de otras piezas';
	@override String get other_pieces_mutual_constraint => 'Restricción mutua de otras piezas';
	@override String get piece_kind_count_constraint => 'Restricción de recuento de tipos de piezas';
}

// Path: sample_script
class _TranslationsSampleScriptEs extends _TranslationsSampleScriptEn {
	_TranslationsSampleScriptEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get kq_k => 'Rey + Reina Vs Rey';
	@override String get kr_k => 'Rey + Torre Vs Rey';
	@override String get krr_k => 'Rey + 2 Torres Vs Rey';
	@override String get kbb_k => 'Rey + 2 Alfiles Vs Rey';
	@override String get kp_k1 => 'Rey + Peón Vs Rey (1)';
	@override String get kp_k2 => 'Rey + Peón Vs Rey (2)';
	@override String get kppp_kppp => 'Rey + 3 Peones Vs Rey + 3 Peones';
	@override String get rook_ending_lucena => 'Finale de torre de Lucena';
	@override String get rook_ending_philidor => 'Finale de torre de Philidor';
}

// Path: privacy
class _TranslationsPrivacyEs extends _TranslationsPrivacyEn {
	_TranslationsPrivacyEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Politica de privacidad';
	@override String get content1 => 'Esta página se utiliza para informarle sobre las políticas con el recopilación, uso y divulgación de información personal para la aplicación, Finales Básicos de Ajedrez. Yo respeto la privacidad de usuarios y me comprometo a proteger la información del usuario, ya sea el tuyo o el de tus hijos. Creo que tienes derecho a conocer mi prácticas con respecto a la información que puedo recopilar y usar cuando usted usa mi aplicación.';
	@override String get content2 => 'La privacidad de los usuarios de mis productos es importante para mí. No colecciono ninguna información identificable sobre mis usuarios. No almaceno ni transmito cualquier información personal.';
	@override String get content3 => 'Si tiene alguna pregunta sobre esta Política de privacidad, comuníquese con yo en laurent.bernabe@gmail.com.';
}

// Path: use_conditions
class _TranslationsUseConditionsEs extends _TranslationsUseConditionsEn {
	_TranslationsUseConditionsEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Condiciones de uso';
	@override String get content => 'No se requiere una condición de uso particular para Finales Básicos de Ajedrez. Esta aplicación solo está destinada a ayudar a los jugadores de ajedrez para mejorar su juego y no incluir ningún contenido que pueda ser dañino, violento o impactante.';
}

// Path: script_editor_page
class _TranslationsScriptEditorPageEs extends _TranslationsScriptEditorPageEn {
	_TranslationsScriptEditorPageEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Página del editor de guiones';
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
	@override String exercise_creation_success({required Object Name}) => 'Ejercicio guardado bajo el nombre ${Name}.';
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageEs extends _TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sintaxis de guiones';
	@override String get table_header_variable_name => 'Nombre';
	@override String get table_header_variable_type => 'Tipo';
	@override String get table_header_variable_use => 'Uso';
	@override String get scripts_goal => 'Objetivo de los guiones';
	@override String get scripts_kinds => 'Tipos de guiones';
	@override String get scripts_format => 'Formato de los guiones';
	@override String get comments => 'Comentarios';
	@override String get variables => 'Variables';
	@override String get predefined_variables => 'Variables predefinidas';
	@override String get int_expressions => 'Expresiones enteras';
	@override String get bool_expressions => 'Expresiones booleanas';
	@override String get scripts_goal_description => 'Un guione de generación de posiciones se divide en varios subprogramas, cada uno de su propio tipo y en un lenguaje personalizado, cuyas siguientes secciones te ayudarán a comprender.\n\nEl objetivo de un subprograma es comprobar que la posición generada cumple con todas sus restricciones.\n\nSi al menos una condición no se cumple, el algoritmo intentará \'arreglar\' la posición para que se cumplan todas las condiciones.';
	@override String get scripts_kinds_head_description => 'Existen varios tipos de subprogramas, y la posición generada debe respetar todas las reglas de todos los subprogramas definidos.\n\nPor supuesto, también debe respetar las reglas estándar del ajedrez (por ejemplo, el rey del lado que no está en turno no puede estar en jaque).\n\n';
	@override String get scripts_kinds_player_king_constraint_title => 'Restricción sobre rey del jugador\n\n';
	@override String get scripts_kinds_player_king_constraint_description => 'Indica las restricciones de posicionamiento del rey del jugador (dado que el color del jugador se elegirá al azar).\n\n';
	@override String get scripts_kinds_computer_king_constraint_title => 'Restricciones sobre rey de la computadora\n\n';
	@override String get scripts_kinds_computer_king_constraint_description => 'Indica las restricciones de posicionamiento del rey de la computadora (dado que el color del jugador se elegirá al azar).\n\n';
	@override String get scripts_kinds_kings_mutual_constraints_title => 'Restricciones mutuas de los reyes\n\n';
	@override String get scripts_kinds_kings_mutual_constraints_description => 'Indica las restricciones de posicionamiento que ambos reyes deben respetar entre sí.\n\n';
	@override String get scripts_kinds_other_pieces_count_constraints_title => 'Restricciones sobre número de otras piezas\n\n';
	@override String get scripts_kinds_other_pieces_count_constraints_description => 'Indica las restricciones de conteo en piezas que no son reyes.\n\n';
	@override String get scripts_kinds_other_pieces_global_constraints_title => 'Restricciones globales sobre otras piezas\n\n';
	@override String get scripts_kinds_other_pieces_global_constraints_description => 'Indica las restricciones de posicionamiento para las piezas que no son reyes, para cada par [tipo de pieza / ¿es una pieza de jugador?].\n\n';
	@override String get scripts_kinds_other_pieces_mutual_constraints_title => 'Restricciones mutuas sobre otras piezas\n\n';
	@override String get scripts_kinds_other_pieces_mutual_constraints_description => 'Indica las restricciones de posicionamiento para las piezas que no son reyes, que deben respetar entre sí, dos a dos,para cada par [tipo de pieza / ¿es una pieza de jugador?].\n\n';
	@override String get scripts_kinds_other_pieces_indexed_constraints_title => 'Restricciones sobre otras piezas por orden\n\n';
	@override String get scripts_kinds_other_pieces_indexed_constraints_description => 'Indica las restricciones de posicionamiento para las piezas que no son reyes, que deben respetar dado su orden de aparición en el tablero de ajedrez, para cada par [tipo de pieza / ¿es una pieza de jugador?].\n\n';
	@override String get scripts_format_head_description => 'Cada guione puede comenzar con una o varias declaraciones de creación de variables.\n\nPero la expresión final debe ser una declaración que devuelva una expresión booleana.\n\nEsta expresión de retorno será utilizada por el algoritmo para comprobar que la posición generada es correcta.\n\nPor favor tenga en cuenta que una declaración puede extenderse en varias líneas: terminan tan pronto como se encuentra el carácter \';\'.\n\nAdemás, tenga cuidado con la sensibilidad a las mayúsculas: las mayúsculas o minúsculas pueden marcar la diferencia.\n\n Finalmente, en cada guión, debes comprobar que no utilizas ninguna variable no declarada: aunque tu código sea aceptado, siempre fallará a la hora de generar la posición.\n\n ';
	@override String get scripts_format_main_description_1 => 'Esta es la sintaxis para la expresión de retorno:\n\n';
	@override String get scripts_format_code_section_1 => 'return [su expresión booleana];\n\n';
	@override String get scripts_format_main_description_2 => 'Este es un ejemplo de guione simple :\n\n';
	@override String get scripts_comments_head_description => 'Puedes usar dos formas de comentarios, que están inspirados en los comentarios del lenguaje C.\n\n';
	@override String get scripts_comments_multiline_comments_title => 'Comentarios multilínea\n\n';
	@override String get scripts_comments_multiline_comments_description => 'Un comentario multilínea comienza con \'/*\' y termina con \'*/\', y puede expandirse en varias líneas.';
	@override String get scripts_comments_multiline_comments_sample => '/* Este es un \ncomentario multilínea. \n\nY puede expandirse en varias líneas.*/\n\n';
	@override String get scripts_comments_single_line_comments_title => 'Comentarios de una sola línea\n\n';
	@override String get scripts_comments_single_line_comments_description_1 => 'Un comentario de una sola línea solo puede estar en una sola línea y comienza con \'//\'.\n\nPor lo tanto, todos los caracteres siguientes de la línea dada son parte del comentario.\n\n';
	@override String get scripts_comments_single_line_comments_sample_1 => '// Este es un comentario de una sola línea\n\n';
	@override String get scripts_comments_single_line_comments_description_2 => 'Un comentario de una sola línea también puede seguir a una declaración en la misma línea.\n\n';
	@override String get scripts_comments_single_line_comments_sample_2 => 'miVariableEntera := FileF; // Establece el valor de la columna F\n\n';
	@override String get scripts_variables_head_description => 'Estos son aspectos a considerar sobre las variables:\n\n';
	@override String get scripts_variables_name_rules_title => 'Reglas de nomenclatura\n\n';
	@override String get scripts_variables_name_rules_description => 'Un nombre de variable debe comenzar con una letra (mayúscula o minúscula).\n\nLuego, los caracteres siguientes pueden ser letras (mayúsculas y/o minúsculas), dígitos o guiones bajos (\'_\').\n\nTen en cuenta también que no puedes usar el nombre de un valor predefinido o de una variable predefinida (ya que cada tipo de guione, como verás más adelante, tiene su propio conjunto de variables predefinidas).\n\n';
	@override String get scripts_variables_creation_title => 'Instrucción de creación de variable\n\n';
	@override String get scripts_variables_creation_description => 'Esta es la sintaxis para crear una variable entera o una variable booleana:\n\n';
	@override String get scripts_variables_creation_format => '[identificador] := [expresión entera | expresión booleana];\n\n';
	@override String get scripts_variables_creation_sample_head_text => 'Este es un ejemplo:\n\n';
	@override String get scripts_variables_creation_sample_code => 'miFila :=  boolIf(reyesEnOposicion) then Rank4 else Rank1;\n\n';
	@override String get scripts_predefined_variables_head_description => 'Las variables predefinidas dependen del tipo de la subrutina que estemos editando.\n\nEstas variables serán alimentadas por el algoritmo al comprobar la corrección de la posición generada.\n\nPor supuesto, no se puede nombrar una variable personal con uno de esos nombres.\n\nAdemás, ten en cuenta que los valores de las coordenadas del tablero de ajedrez tienen en cuenta la orientación del tablero.\n\n';
	@override String get scripts_predefined_variables_single_king_constraints_title => 'Restricciones rey del jugador / Restricciones rey de la computadora\n\n';
	@override String get scripts_predefined_variables_single_king_constraints_variable_file => 'la columna que ha sido preparado para el rey';
	@override String get scripts_predefined_variables_single_king_constraints_variable_rank => 'el rango que ha sido preparado para el rey';
	@override String get scripts_predefined_variables_single_king_constraints_variable_player_has_white => '¿tiene el jugador las piezas blancas?';
	@override String get scripts_predefined_variables_mutual_kings_constraints_title => '\n\nRestricciones mutuas de los reyes\n\n';
	@override String get scripts_predefined_variables_single_king_constraints_variable_file_player => 'la columna que ha sido preparado para el rey del jugador';
	@override String get scripts_predefined_variables_single_king_constraints_variable_rank_player => 'el rango que ha sido preparado para el rey del jugador';
	@override String get scripts_predefined_variables_single_king_constraints_variable_file_computer => 'la columna que ha sido preparado para el rey de la computadora';
	@override String get scripts_predefined_variables_single_king_constraints_variable_rank_computer => 'el rango que ha sido preparado para el rey de la computadora';
	@override String get scripts_predefined_variables_other_pieces_global_constraints_title => '\n\nRestricciones globales sobre otras piezas\n\n';
	@override String get scripts_predefined_variables_other_pieces_global_constraints_file => 'la columna que ha sido preparado para la pieza';
	@override String get scripts_predefined_variables_other_pieces_global_constraints_rank => 'el rango que ha sido preparado para la pieza';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_title => '\n\nRestricciones mutuas sobre otras piezas\n\n';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_file_first => 'la columna que ha sido preparado para la primera pieza';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_rank_first => 'el rango que ha sido preparado para la primera pieza';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_file_second => 'la columna que ha sido preparado para la segunda pieza';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_rank_second => 'la columna que ha sido preparado para la segunda pieza';
	@override String get scripts_predefined_variables_other_pieces_indexed_constraints_title => '\n\nRestricciones sobre otras piezas por orden\n\n';
	@override String get scripts_predefined_variables_other_pieces_indexed_constraints_apparition => 'el índice (empezando en 0) de aparición en el tablero';
	@override String get int_expressions_head_description => 'Una expresión entera es simplemente una expresión cuyo valor final producido es un entero.\n\n';
	@override String get int_expression_parenthesis_title => 'Paréntesis\n\n';
	@override String get int_expression_parenthesis_description => 'Útil para aislar una expresión entera, de modo que se calcule con prioridad.\n\n';
	@override String get int_expression_parenthesis_syntax => '([expresión entera])\n\n';
	@override String get int_expression_parenthesis_sample_text => 'Este es un ejemplo:\n\n';
	@override String get int_expression_conditional_title => 'Expresión condicional\n\n';
	@override String get int_expression_conditional_description => 'Para producir expresiones condicionalmente.\n\nCuidado con la palabra clave \'numIf\'.\n\n';
	@override String get int_expression_conditional_syntax => 'numIf([expresión booleana]) then [expresión entera] else [expresión entera]\n\n';
	@override String get int_expression_absolute_title => 'Valor absoluto\n\n';
	@override String get int_expression_absolute_description => 'Produce el valor absoluto de la expresión dada.\n\n';
	@override String get int_expression_absolute_syntax => 'abs([expresión entera])\n\n';
	@override String get int_expression_modulo_title => 'Expresión modulo\n\n';
	@override String get int_expression_modulo_description => 'Produce el valor modular de la expresión dada.\n\nEs el resto de la división del primer operando por el segundo.\n\n';
	@override String get int_expression_modulo_syntax => '[expresión entera] % [expresión entera]\n\n';
	@override String get int_expression_modulo_sample_code => 'miVariableEntera % 2\n\n';
	@override String get int_expression_arithmetic_title => 'Operadores aritméticos\n\n';
	@override String get int_expression_arithmetic_description => 'Hay dos operadores aritméticos disponibles: \'+\' y \'-\'.\n\n';
	@override String get int_expression_arithmetic_syntax_1 => '[expresión entera] + [expresión entera]\n';
	@override String get int_expression_arithmetic_syntax_or => 'o\n';
	@override String get int_expression_arithmetic_syntax_2 => '[expresión entera] - [expresión entera]\n\n';
	@override String get int_expression_literal_title => 'Literales\n\n';
	@override String get int_expression_literal_description => 'Puedes usar valores literales (1, 25, 150 por ejemplo).\n\n';
	@override String get int_expression_variable_title => 'Variables\n\n';
	@override String get int_expression_variable_description => 'Las variables enteras también son expresiones.\n\n';
	@override String get int_expression_predefined_values_title => 'Valores predefinidos\n\n';
	@override String get int_expression_predefined_values_description => 'Todos las subrutinas tienen los mismos valores enteros predefinidos (no puedes nombrar una variable con uno de esos nombres).\n\nTodos estos valores tienen en cuenta la orientación del tablero de ajedrez.\n\nEstos son los valores enteros predefinidos para las columnas del tablero de ajedrez: FileA, FileB, FileC, FileD, FileE, FileF, FileG, FileH.\n\nEstos son los valores enteros predefinidos para los rangos del tablero de ajedrez: Rank1, Rank2, Rank3, Rank4, Rank5, Rank6, Rank7, Rank8.\n\n ';
	@override String get bool_expressions_head_description => 'Una expresión booleana es simplemente una expresión cuyo valor final producido es un valor booleano.\n\nTenga en cuenta que no hay literales booleanos: no puede usar las palabras clave true o false.\n\n';
	@override String get bool_expression_parenthesis_title => 'Paréntesis\n\n';
	@override String get bool_expression_parenthesis_description => 'Útil para aislar una expresión booleana, de modo que se calcule con prioridad.\n\n';
	@override String get bool_expression_parenthesis_syntax => '([expresión booleana])\n\n';
	@override String get bool_expression_conditional_title => 'Expresión condicional\n\n';
	@override String get bool_expression_conditional_description => 'Para producir expresiones condicionalmente.\n\nCuidado con la palabra clave \'boolIf\'.\n\n';
	@override String get bool_expression_conditional_syntax => 'boolIf([expresión booleana]) then [expresión booleana] else [expresión booleana]\n\n';
	@override String get bool_expression_variable_title => 'Variables\n\n';
	@override String get bool_expression_variable_description => 'Booleanas variables también son expresiones.\n\n';
	@override String get bool_expression_integer_comparation_title => 'Comparación de enteros\n\n';
	@override String get bool_expression_integer_comparation_description => 'You can compare two integers values.\n\n\'==\' es para igualdad y \'!=\' es para diferencia.\n\n';
	@override String get bool_expression_integer_comparation_syntax_1 => '[expresión entera] < [expresión entera]\n\n';
	@override String get bool_expression_integer_comparation_syntax_2 => '[expresión entera] > [expresión entera]\n\n';
	@override String get bool_expression_integer_comparation_syntax_3 => '[expresión entera] <= [expresión entera]\n\n';
	@override String get bool_expression_integer_comparation_syntax_4 => '[expresión entera] >= [expresión entera]\n\n';
	@override String get bool_expression_integer_comparation_syntax_5 => '[expresión entera] == [expresión entera]\n\n';
	@override String get bool_expression_integer_comparation_syntax_6 => '[expresión entera] != [expresión entera]\n\n';
	@override String get bool_expression_boolean_comparation_title => 'Comparación de booleanos\n\n';
	@override String get bool_expression_boolean_comparation_description => 'Puedes comparar dos valores booleanos.\n\n\'<==>\' es para la igualdad y \'<!=>\' es para la diferencia.\n\n';
	@override String get bool_expression_boolean_comparation_syntax_1 => '[expresión booleana] <==> [expresión booleana]\n\n';
	@override String get bool_expression_boolean_comparation_syntax_2 => '[expresión booleana] <!=> [expresión booleana]\n\n';
	@override String get bool_expression_logical_operators_title => 'Operadores lógicos\n\n';
	@override String get bool_expression_logical_operators_description => 'Hay dos operadores lógicos disponibles.\n\n';
	@override String get bool_expression_logical_operators_syntax_1 => '[expresión booleana] and [expresión booleana]\n\n';
	@override String get bool_expression_logical_operators_syntax_2 => '[expresión booleana] or [expresión booleana]\n\n';
}

// Path: <root>
class _TranslationsFr extends _TranslationsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_TranslationsFr.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, _TranslationsEn> $meta;

	@override late final _TranslationsFr _root = this; // ignore: unused_field

	// Translations
	@override late final _TranslationsMiscFr misc = _TranslationsMiscFr._(_root);
	@override late final _TranslationsHomeFr home = _TranslationsHomeFr._(_root);
	@override late final _TranslationsExplorerFr explorer = _TranslationsExplorerFr._(_root);
	@override late final _TranslationsRgpdFr rgpd = _TranslationsRgpdFr._(_root);
	@override late final _TranslationsGamePageFr game_page = _TranslationsGamePageFr._(_root);
	@override late final _TranslationsScriptParserFr script_parser = _TranslationsScriptParserFr._(_root);
	@override late final _TranslationsScriptTypeFr script_type = _TranslationsScriptTypeFr._(_root);
	@override late final _TranslationsSampleScriptFr sample_script = _TranslationsSampleScriptFr._(_root);
	@override late final _TranslationsPrivacyFr privacy = _TranslationsPrivacyFr._(_root);
	@override late final _TranslationsUseConditionsFr use_conditions = _TranslationsUseConditionsFr._(_root);
	@override late final _TranslationsScriptEditorPageFr script_editor_page = _TranslationsScriptEditorPageFr._(_root);
	@override late final _TranslationsSyntaxManualPageFr syntax_manual_page = _TranslationsSyntaxManualPageFr._(_root);
}

// Path: misc
class _TranslationsMiscFr extends _TranslationsMiscEn {
	_TranslationsMiscFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get app_title => 'Finales d\'échecs basiques';
	@override String get button_ok => 'D\'accord';
	@override String get button_cancel => 'Annuler';
	@override String get button_accept => 'Accepter';
	@override String get button_deny => 'Refuser';
	@override String get button_validate => 'Valider';
}

// Path: home
class _TranslationsHomeFr extends _TranslationsHomeEn {
	_TranslationsHomeFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Accueil';
	@override String get failed_loading_exercise => 'Échec de chargement de l\'exerice : la position d\'échecs est invalide.';
	@override String get max_generation_attempts_achieved => 'Impossible de générer une position à partir de ces scripts : nombre de tentatives maximum dépassés.\n\nVeuillez vérifier que vos contraintes ne sont pas trop restrictives.\n\nÉgalement, veuillez vérifier que vos variables soient déclarées avant utilisation.';
	@override String get failed_generating_position => 'Échec de génération de la position.';
	@override String get samples_help_message => 'Ici vous pouvez choisir le type de position avec laquelle vous voulez jouer.\nUne ligne dont l\'icône est un trophée générera une position où vous devrez gagner.\nSinon si la ligne commence par une poignée de main, vous devrez sauver la partie et faire partie nulle.\n\nVous pouvez aussi voir le code d\'un exemple, ou même le cloner dans le dossier courant de la section exercices personnels, en faisant un appui-long dessus.';
	@override String get custom_scripts_help_message => 'Ici vous pouvez créér et exécuter vos exercices personnalisés (par un simple appui dessus).\n\n Vous pouvez aussi éditer/renommer/supprimer un unique exercice par un appui long dessus.\n\n Vous pouvez aussi ajouter/renommer/supprimer des dossiers.';
	@override String get tab_integrated => 'Intégrés';
	@override String get tab_added => 'Ajoutés';
	@override String get no_game_yet => 'Aucun élément';
	@override String get failed_loading_added_exercises => 'Échec de chargement des exercises personnalisés';
	@override String get misc_generating_error => 'Erreur de génération de la position pour une erreur diverse.';
	@override String get contextual_menu_file_delete => 'Supprimer';
	@override String get contextual_menu_file_rename => 'Renommer';
	@override String get contextual_menu_file_edit => 'Éditer';
	@override String get contextual_menu_rename_folder => 'Renommer';
	@override String get contextual_menu_folder_delete => 'Supprimer';
	@override String get contextual_menu_see_sample_code => 'Voir le code';
	@override String get contextual_menu_clone_sample_code => 'Cloner dans les exercices ajoutés';
	@override String get confirm_delete_file_title => 'Supprimer le fichier ?';
	@override String confirm_delete_file_msg({required Object Name}) => 'Souhaitez-vous supprimer le fichier \'${Name}\'?';
	@override String get confirm_delete_folder_title => 'Supprimer le dossier ?';
	@override String confirm_delete_folder_msg({required Object Name}) => 'Souhaitez-vous supprimer le dossier \'${Name}\'?';
	@override String get file_name_already_taken => 'Ce nom est déjà utilisé.';
	@override String get new_folder_prompt => 'Nom : ';
	@override String get rename_folder_prompt => 'Nouveau nom : ';
	@override String get loading_content => 'Chargement ...';
	@override String get root_directory => '\'Racine\'';
	@override String get protected_folder => 'Dossier protégé';
	@override String cloned_sample_exercise({required Object Name}) => 'Exemple cloné sous le nom ${Name}.';
	@override String get contextual_menu_file_export => 'Exporter';
	@override String get export_script_title => 'Exporter';
	@override String get documents_directory => 'Documents';
	@override String get external_storage => 'Stockage externe';
	@override String get script_exported => 'Le script a été exporté.';
	@override String get import_file_menu => 'Importer un fichier';
	@override String get import_folder_menu => 'Importer un dossier';
	@override String get no_external_storage => 'Aucune carte SD';
}

// Path: explorer
class _TranslationsExplorerFr extends _TranslationsExplorerEn {
	_TranslationsExplorerFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get failed_loading_content => 'Échec de chargement du contenu';
	@override String get save_file_prompt => 'Nom : ';
	@override String get empty_item_name => 'Vous devez spécifier un nom de fichier.';
	@override String get new_folder_title => 'Ajouter un nouveau dossier';
	@override String get new_folder_prompt => 'Nom : ';
	@override String get folder_already_exists => 'Ce nom est déjà utilisé.';
}

// Path: rgpd
class _TranslationsRgpdFr extends _TranslationsRgpdEn {
	_TranslationsRgpdFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get text => 'En utilisant cette application, vous vous conformez à :';
	@override String get privacy => 'la Politique de Confidentialité';
	@override String get use_conditions => 'les Conditions d\'Utilisation';
}

// Path: game_page
class _TranslationsGamePageFr extends _TranslationsGamePageEn {
	_TranslationsGamePageFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

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
class _TranslationsScriptParserFr extends _TranslationsScriptParserEn {
	_TranslationsScriptParserFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String variable_not_affected({required Object Name}) => 'La variable ${Name} a été utilisée avant même d\'avoir été définie.';
	@override String unrecognized_symbol({required Object Symbol}) => 'Symbol non reconnu ${Symbol}.';
	@override String input_mismatch({required Object Line, required Object Index, required Object Expected, required Object Received}) => 'Entrée incorrecte dans la ligne ${Line} :caractère à l\'index ${Index}. Vous auriez dû mettre ${Expected} mais j\'ai reçu ${Received}.';
	@override String no_viable_alt_exception({required Object Token, required Object LineNumber, required Object PositionInLine}) => 'L\'entrée ${Token} ne correspond à aucune règle.(Ligne ${LineNumber}, numéro de caractère ${PositionInLine})';
	@override String get misc_parse_error => 'Erreur d\'interprétation diverse.';
	@override String get no_antlr4_token => '[Aucune occurence]';
	@override String get eof => '[FinDeFichier]';
	@override String overriding_predefined_variable({required Object Name}) => 'Vous essayez de modifier la valeur de la variable prédéfinie ${Name}.';
	@override String parse_error_dialog_title({required Object Title}) => 'Erreur de script pour ${Title}';
	@override String get type_error => 'Veuillez vérifier que vous n\'utilisez pas de valeur entière à la place de valeur booléenne, et vice versa.';
	@override String get missing_script_type => 'Échec de génération de la position: veuillez vérifier que toutes les sections du script déclarent un type de script correct.';
	@override String unrecognized_script_type({required Object Type}) => 'Type de script non reconnu : ${Type}.';
	@override String get misc_error_dialog_title => 'Erreur globale';
	@override String get misc_checking_error => 'La vérification d\'erreurs a échoué pour une raison diverse.';
}

// Path: script_type
class _TranslationsScriptTypeFr extends _TranslationsScriptTypeEn {
	_TranslationsScriptTypeFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get player_king_constraint => 'Contraintes du roi du joueur';
	@override String get computer_king_constraint => 'Contraintes du roi de l\'ordinateur';
	@override String get kings_mutual_constraint => 'Contraintes entre les deux rois';
	@override String get other_pieces_global_constraint => 'Contraintes globales pour les autres pièces';
	@override String get other_pieces_indexed_constraint => 'Contraintes par index pour les autres pièces';
	@override String get other_pieces_mutual_constraint => 'Contraintes mutuelles pour les autres pièces';
	@override String get piece_kind_count_constraint => 'Contraintes sur le compte des autres pièces';
}

// Path: sample_script
class _TranslationsSampleScriptFr extends _TranslationsSampleScriptEn {
	_TranslationsSampleScriptFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get kq_k => 'Roi + Dame Contre Roi';
	@override String get kr_k => 'Roi + Tour Contre Roi';
	@override String get krr_k => 'Roi + 2 Tours Contre Roi';
	@override String get kbb_k => 'Roi + 2 Fous Contre Roi';
	@override String get kp_k1 => 'Roi + Pion Contre Roi (1)';
	@override String get kp_k2 => 'Roi + Pion Contre Roi (2)';
	@override String get kppp_kppp => 'Roi + 3 Pions Contre Roi + 3 Pions';
	@override String get rook_ending_lucena => 'Finale de tour de Lucena';
	@override String get rook_ending_philidor => 'Finale de tour de Philidor';
}

// Path: privacy
class _TranslationsPrivacyFr extends _TranslationsPrivacyEn {
	_TranslationsPrivacyFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Politique de confidentialité';
	@override String get content1 => 'Cette page est utilisée pour vous informer sur les politiques de collecte, d\'utilisation et divulgation d\'informations personnelles pour l\'application, Finales d\'Echecs Basiques. Je respecte la vie privée de utilisateurs et je m\'engage à protéger les informations de l\'utilisateur, que ce soit la vôtre ou celle de vos enfants. Je crois que vous avez le droit de connaître mes pratiques concernant les informations que je peux collecter et utiliser lorsque vous utilisez mon application.';
	@override String get content2 => 'La confidentialité des utilisateurs de mes applications est importante pour moi. Je ne collecte aucune information identifiable sur mes utilisateurs. Je ne stocke ni ne transmets aucune information personnelle.';
	@override String get content3 => 'Si vous avez quelque question que ce soit à propos de cette politique de confidentialité, veuillez me contacter à laurent.bernabe@gmail.com.';
}

// Path: use_conditions
class _TranslationsUseConditionsFr extends _TranslationsUseConditionsEn {
	_TranslationsUseConditionsFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Conditions d\'utilisation';
	@override String get content => 'Aucune condition d\'utilisation particulière n\'est requise pour Finales d\'Echecs Basiques. Cette application est uniquement destinée à aider les joueurs d\'échecs pour améliorer leur jeu, et n\'inclut aucun contenu qui pourrait être nuisible, violent ou choquant.';
}

// Path: script_editor_page
class _TranslationsScriptEditorPageFr extends _TranslationsScriptEditorPageEn {
	_TranslationsScriptEditorPageFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Page d\'édition de script';
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
	@override String exercise_creation_success({required Object Name}) => 'Exercise sauvegardé sous le nom ${Name}';
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageFr extends _TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Syntaxe des scripts';
	@override String get table_header_variable_name => 'Nom';
	@override String get table_header_variable_type => 'Type';
	@override String get table_header_variable_use => 'Utilisation';
	@override String get scripts_goal => 'Objectif des scripts';
	@override String get scripts_kinds => 'Types de scripts';
	@override String get scripts_format => 'Format des scripts';
	@override String get comments => 'Commentaires';
	@override String get variables => 'Variables';
	@override String get predefined_variables => 'Variables prédéfinies';
	@override String get int_expressions => 'Expressions entières';
	@override String get bool_expressions => 'Expressions booléennes';
	@override String get scripts_goal_description => 'Un script de génération de position est composé de plusieurs sous-scripts, chacun étant de son propre type et dans un langage personnalisé, que les prochaines sections vous aideront à comprendre.\n\nLe but d\'un sous-script est de vérifier que la position générée respecte toutes ses contraintes.\n\nSi au moins une des conditions n\'est pas respectée, alors l\'algorithme tentera de \'fixer\' la position de telle manière que toutes les contraintes soient respectéees.';
	@override String get scripts_kinds_head_description => 'Il y a plusieurs types de sous-scripts, et toutes les règles définies dans l\'ensemble des sous-scripts doivent être respectées par la position générée.\n\nBien sûr, elle doit aussi respecter les règles standards (par exemple : le roi qui n\'est pas au trait ne doit pas être en échec).\n\n';
	@override String get scripts_kinds_player_king_constraint_title => 'Contraintes sur le roi du joueur\n\n';
	@override String get scripts_kinds_player_king_constraint_description => 'Renseigne sur les contraintes d\'emplacement du roi du joueur (sachant que la couleur du joueur est tirée aléatoirement).\n\n';
	@override String get scripts_kinds_computer_king_constraint_title => 'Contraintes sur le roi de l\'ordinateur\n\n';
	@override String get scripts_kinds_computer_king_constraint_description => 'Renseigne sur les contraintes d\'emplacement du roi de l\'ordinateur (sachant que la couleur du joueur est tirée aléatoirement).\n\n';
	@override String get scripts_kinds_kings_mutual_constraints_title => 'Contraintes mutuelles entre rois\n\n';
	@override String get scripts_kinds_kings_mutual_constraints_description => 'Renseigne sur les contraintes de positionnement que les deux rois doivent respecter entre eux.\n\n';
	@override String get scripts_kinds_other_pieces_count_constraints_title => 'Contraintes sur le compte des autres pièces\n\n';
	@override String get scripts_kinds_other_pieces_count_constraints_description => 'Renseigne sur les contraintes sur le compte des pièces autres que les rois.\n\n';
	@override String get scripts_kinds_other_pieces_global_constraints_title => 'Contraintes globales sur les autres pièces\n\n';
	@override String get scripts_kinds_other_pieces_global_constraints_description => 'Renseigne sur les contraintes de positionnement des pièces autres que les rois, pour chaque couple [type de pièce / est-ce une pièce du joueur ?].\n\n';
	@override String get scripts_kinds_other_pieces_mutual_constraints_title => 'Contraintes mutuelles sur les autres pièces\n\n';
	@override String get scripts_kinds_other_pieces_mutual_constraints_description => 'Renseigne sur les contraintes de positionnement des pièces autres que les rois, qu\'elles doivent respecter entre elles, deux par deux, pour chaque couple [type de pièce / est-ce une pièce d\'un joueur ?].\n\n';
	@override String get scripts_kinds_other_pieces_indexed_constraints_title => 'Contraintes des autres pièces par ordre\n\n';
	@override String get scripts_kinds_other_pieces_indexed_constraints_description => 'Renseigne sur les contraintes de positionnement des pièces autres que les rois, qu\'elles doivent respecter en fonction de l\'ordre d\'apparition sur l\'échiquier, pour chaque couple [type de pièce / est-ce une pièce du joueur ?].\n\n';
	@override String get scripts_format_head_description => 'Chaque script peut commencer par une ou plusieures instructions de création de variables.\n\nMais au final la dernière instruction doit retourner une expression booléenne.\n\nCette expression de retour sera utilisée par l\'algorithme afin de vérifier que la position générée est correcte.\n\nVeuillez aussi prendre en compte le fait qu\'une instruction peut s\'étendre sur plusieurs lignes : elles se terminent dès le caractère \';\'.\n\nAussi, faites attention à la casse : les majuscules ou les minuscules peuvent faire la différence.\n\n Enfin, vous devriez vérifier que dans chaque sous-script, vous n\'utilisez pas de variable non déclarée : bien que le code soit accepté, il ne pourra jamais générer de position.\n\n';
	@override String get scripts_format_main_description_1 => 'Voici la syntaxe pour l\'expression de retour :\n\n';
	@override String get scripts_format_code_section_1 => 'return [votre expression booléenne];\n\n';
	@override String get scripts_format_main_description_2 => 'Voici un exemple simple de script :\n\n';
	@override String get scripts_comments_head_description => 'Vous pouvez utiliser deux types de commentaires, qui sont directement inspirés du langage C.\n\n';
	@override String get scripts_comments_multiline_comments_title => 'Commentaires multi-lignes\n\n';
	@override String get scripts_comments_multiline_comments_description => 'Un commentaire multi-lignes commence par \'/*\' et finit par \'*/\', et peut s\'étendre sur plusieurs lignes.\n\n';
	@override String get scripts_comments_multiline_comments_sample => '/* Ceci est un\ncommentaire multi-lignes.\n\nEt peut s\'étendre sur plusieurs lignes.*/\n\n';
	@override String get scripts_comments_single_line_comments_title => 'Commentaires mono-lignes\n\n';
	@override String get scripts_comments_single_line_comments_description_1 => 'Un commentaire mono-ligne peut seulement se situer sur une seule ligne, et commence par \'//\'.\n\nPar conséquent, tous les caractères suivants de cette ligne font partie du commentaire.\n\n';
	@override String get scripts_comments_single_line_comments_sample_1 => '// Ceci est un commentaire mono-ligne\n\n';
	@override String get scripts_comments_single_line_comments_description_2 => 'Un commentaire mono-ligne peut aussi suivre une déclaration sur la même ligne.\n\n';
	@override String get scripts_comments_single_line_comments_sample_2 => 'maVariableEntiere := FileF; // Fixe à la valeur de la colonne F\n\n';
	@override String get scripts_variables_head_description => 'Voici certaines choses à considérer à propos des variables :\n\n';
	@override String get scripts_variables_name_rules_title => 'Règles de nommage\n\n';
	@override String get scripts_variables_name_rules_description => 'Un nom de variable doit commencer par une lettre (soit majuscule, soit minuscule).\n\nEnsuite les caractères suivant peuvent être des lettres (en majuscule et/ou en minuscules), des chiffres ou des underscores (\'_\').\n\nAussi gardez à l\'esprit que vous ne pouvez pas définir au nom d\'une valeur prédéfinie ou d\'une variable prédéfinie (sachant que chaque type de script, comme vous le verrez plus tard, dispose de son propre ensemble de variables prédéfinies).\n\n';
	@override String get scripts_variables_creation_title => 'Instruction de création de variables\n\n';
	@override String get scripts_variables_creation_description => 'Voici la syntaxe pour créér une variable entière ou booléenne :\n\n';
	@override String get scripts_variables_creation_format => '[identifiant] := [expression entière | expression booléenne];\n\n';
	@override String get scripts_variables_creation_sample_head_text => 'À titre d\'exemple :\n\n';
	@override String get scripts_variables_creation_sample_code => 'maRangee :=  boolIf(roisEnOpposition) then Rank4 else Rank1;\n\n';
	@override String get scripts_predefined_variables_head_description => 'L\'ensemble des variables prédéfinies dépendent du type de script en cours d\'édition.\n\nCes variables seront alimentées par l\'algorithme lors de la vérification de la validité de la position.\n\nBien sûr, vous ne pouvez pas nommer une variable personnelle avec un de ces noms.\n\nEnfin, ne perdez pas de vue que les variables de coordonnées prenent en compte l\'orientation de l\'échiquier.\n\n';
	@override String get scripts_predefined_variables_single_king_constraints_title => 'Contraintes sur le roi du joueur / Contraintes sur le roi de l\'ordinateur\n\n';
	@override String get scripts_predefined_variables_single_king_constraints_variable_file => 'la colonne qui a été choisie pour le roi';
	@override String get scripts_predefined_variables_single_king_constraints_variable_rank => 'la rangée qui a été choisie pour le roi';
	@override String get scripts_predefined_variables_single_king_constraints_variable_player_has_white => 'le joueur dispose-t-il des pièces blanches ?';
	@override String get scripts_predefined_variables_mutual_kings_constraints_title => '\n\nContraintes mutuelles entre les rois\n\n';
	@override String get scripts_predefined_variables_single_king_constraints_variable_file_player => 'la colonne qui a été choisie pour le roi du joueur';
	@override String get scripts_predefined_variables_single_king_constraints_variable_rank_player => 'la rangée qui a été choisie pour le roi du joueur';
	@override String get scripts_predefined_variables_single_king_constraints_variable_file_computer => 'la colonne qui a été choisie pour le roi de l\'ordinateur';
	@override String get scripts_predefined_variables_single_king_constraints_variable_rank_computer => 'la rangée qui a été choisie pour le roi de l\'ordinateur';
	@override String get scripts_predefined_variables_other_pieces_global_constraints_title => '\n\nContraintes globales des autres pièces\n\n';
	@override String get scripts_predefined_variables_other_pieces_global_constraints_file => 'la colonne qui a été choisie pour la pièce';
	@override String get scripts_predefined_variables_other_pieces_global_constraints_rank => 'la rangée qui a été choisie pour la pièce';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_title => '\n\nContraintes mutuelles des autres pièces\n\n';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_file_first => 'la colonne qui a été choisie pour la première pièce';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_rank_first => 'la rangée qui a été choisie pour la première pièce';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_file_second => 'la colonne qui a été choisie pour la deuxième pièce';
	@override String get scripts_predefined_variables_other_pieces_mutual_constraints_rank_second => 'la rangée qui a été choisie pour la deuxième pièce';
	@override String get scripts_predefined_variables_other_pieces_indexed_constraints_title => '\n\nContraintes des autres pièces par ordre\n\n';
	@override String get scripts_predefined_variables_other_pieces_indexed_constraints_apparition => 'l\'index (démarrant à 0) d\'apparition sur l\'échiquier';
	@override String get int_expressions_head_description => 'Une expression entière est simplement une expression dont la valeur finalement produite est un entier.\n\n';
	@override String get int_expression_parenthesis_title => 'Parenthèses\n\n';
	@override String get int_expression_parenthesis_description => 'Utile pour isoler une expression entière, de sorte qu\'elle soit calculée en priorité.\n\n';
	@override String get int_expression_parenthesis_syntax => '([expression entière])\n\n';
	@override String get int_expression_parenthesis_sample_text => 'À titre d\'exemple :\n\n';
	@override String get int_expression_conditional_title => 'Expression conditionnelle\n\n';
	@override String get int_expression_conditional_description => 'Pour produire une expression de manière conditionnelle.\n\nAttention au mot-clé \'numIf\'.\n\n';
	@override String get int_expression_conditional_syntax => 'numIf([expression booléenne]) then [expression entière] else [expression entière]\n\n';
	@override String get int_expression_absolute_title => 'Valeur absolue\n\n';
	@override String get int_expression_absolute_description => 'Produit la valeur absolue de l\'expression donnée.\n\n';
	@override String get int_expression_absolute_syntax => 'abs([expression entière])\n\n';
	@override String get int_expression_modulo_title => 'Expression modulo\n\n';
	@override String get int_expression_modulo_description => 'Produit la valeur modulo de l\'expression donnée.\n\nC\'est le reste de la division de la première opérande par la seconde.\n\n';
	@override String get int_expression_modulo_syntax => '[expression entière] % [expression entière]\n\n';
	@override String get int_expression_modulo_sample_code => 'maVariableEntiere % 2\n\n';
	@override String get int_expression_arithmetic_title => 'Opérateurs arithmétiques\n\n';
	@override String get int_expression_arithmetic_description => 'Il y a deux opérateurs arithmétiques disponibles: \'+\' et \'-\'.\n\n';
	@override String get int_expression_arithmetic_syntax_1 => '[expression entière] + [expression entière]\n';
	@override String get int_expression_arithmetic_syntax_or => 'ou\n';
	@override String get int_expression_arithmetic_syntax_2 => '[expression entière] - [expression entière]\n\n';
	@override String get int_expression_literal_title => 'Litéraux\n\n';
	@override String get int_expression_literal_description => 'Vous pouvez utiliser des valeurs litérales (1, 25, 150 par exemple).\n\n';
	@override String get int_expression_variable_title => 'Variables\n\n';
	@override String get int_expression_variable_description => 'Les variables entières sont également des expressions.\n\n';
	@override String get int_expression_predefined_values_title => 'Valeurs prédéfinies\n\n';
	@override String get int_expression_predefined_values_description => 'Tous les sous-scripts ont les même valeurs prédéfinies (vous ne pouvez pas nommer une variable avec un de leurs noms).\n\nToutes ces valeurs prennent en compte l\'orientation de l\'échiquier.\n\nVoici les valeurs entières prédéfines pour les colonnes de l\'échiquier : FileA, FileB, FileC, FileD, FileE, FileF, FileG, FileH.\n\nVoici les valeurs entières prédéfines pour les rangées de l\'échiquier : Rank1, Rank2, Rank3, Rank4, Rank5, Rank6, Rank7, Rank8.\n\n ';
	@override String get bool_expressions_head_description => 'Une expression booléenne est simplement un expression dont la valeur finale produite est un booléen.\n\nNotez qu\'il n\'y a pas de littéral booléen: vous ne pouvez pas utiliser les mots-clés true et false.\n\n';
	@override String get bool_expression_parenthesis_title => 'Parenthèses\n\n';
	@override String get bool_expression_parenthesis_description => 'Utile pour isoler une expression entière, de sorte qu\'elle sera calculée en priorité.\n\n';
	@override String get bool_expression_parenthesis_syntax => '([expression booléenne])\n\n';
	@override String get bool_expression_conditional_title => 'Expression conditionnelle\n\n';
	@override String get bool_expression_conditional_description => 'Pour produire une expression de manière conditionnelle.\n\nAttention au mot-clé \'boolIf\'.\n\n';
	@override String get bool_expression_conditional_syntax => 'boolIf([expression booléenne]) then [expression booléenne] else [expression booléenne]\n\n';
	@override String get bool_expression_variable_title => 'Variables\n\n';
	@override String get bool_expression_variable_description => 'Les variables booléennes sont également des expressions.\n\n';
	@override String get bool_expression_integer_comparation_title => 'Comparaison d\'entiers\n\n';
	@override String get bool_expression_integer_comparation_description => 'Vous pouvez comparer deux valeurs entières.\n\n\'==\' pour l\'égalité et \'!=\' pour la différence.\n\n';
	@override String get bool_expression_integer_comparation_syntax_1 => '[expression entière] < [expression entière]\n\n';
	@override String get bool_expression_integer_comparation_syntax_2 => '[expression entière] > [expression entière]\n\n';
	@override String get bool_expression_integer_comparation_syntax_3 => '[expression entière] <= [expression entière]\n\n';
	@override String get bool_expression_integer_comparation_syntax_4 => '[expression entière] >= [expression entière]\n\n';
	@override String get bool_expression_integer_comparation_syntax_5 => '[expression entière] == [expression entière]\n\n';
	@override String get bool_expression_integer_comparation_syntax_6 => '[expression entière] != [expression entière]\n\n';
	@override String get bool_expression_boolean_comparation_title => 'Comparaison de booléens\n\n';
	@override String get bool_expression_boolean_comparation_description => 'Vous pouvez comparer deux valeurs entières.\n\n\'<==>\' est pour l\'égalité and \'<!=>\' est pour la différence.\n\n';
	@override String get bool_expression_boolean_comparation_syntax_1 => '[expression booléenne] <==> [expression booléenne]\n\n';
	@override String get bool_expression_boolean_comparation_syntax_2 => '[expression booléenne] <!=> [expression booléenne]\n\n';
	@override String get bool_expression_logical_operators_title => 'Opérateurs logiques\n\n';
	@override String get bool_expression_logical_operators_description => 'Il y a deux opérateurs logiques disponibles.\n\n';
	@override String get bool_expression_logical_operators_syntax_1 => '[expression booléenne] and [expression booléenne]\n\n';
	@override String get bool_expression_logical_operators_syntax_2 => '[expression booléenne] or [expression booléenne]\n\n';
}
