/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 327 (109 per locale)
///
/// Built on 2023-11-04 at 10:06 UTC

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

// context enums

enum GenderContext {
	male,
	female,
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
}

// Path: home
class _TranslationsHomeEn {
	_TranslationsHomeEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get failed_loading_exercise => 'Failed to load exercise : the chess position is not valid.';
	String get failed_generating_position => 'Failed to generate the position.';
	String get help_message => 'Here you can select the type of position you want to play with. A line which leading icon is a trophy will generate a position in which you should win. Otherwise, with a handshake leading icon, your goal will be to save the game and make draw.';
	String get tab_integrated => 'Integrated';
	String get tab_added => 'Added';
	String get no_game_yet => 'No element';
	String get failed_loading_added_exercises => 'Failed to load custom exercises list';
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
	String get misc_error_dialog_title => 'Global error';
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
	String get content1 => 'This page is used to inform you regarding the policies with the collection, use and disclosure of personal information for the app, Basic Chess Endgames. Laurent Bernabe respect the privacy of users and is committed to protect the user\'s information, be it yours or your children\'s. I believe that you have a right to know my practices regarding the information I may collect and use when you use my app.';
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
	String get syntax_button_label => 'Syntax rules';
	String get variables_button_label => 'Predefined variables';
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageEn._(this._root);

	final _TranslationsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Scripts\' syntax';
	String get scripts_goal => 'Scripts\' goal';
	String get scripts_kinds => 'Scripts kinds';
	String get scripts_format => 'Scripts\' format';
	String get comments => 'Comments';
	String get variable_creation => 'Variable creation';
	String get predefined_variables_and_values => 'Predefined variables and values';
	String get boolean_expressions => 'Boolean expressions';
	String get int_expressions => 'Integer expressions';
	String get scripts_goal_description => 'A position generation script is split into several subscripts, each of its own kind. \n\nA subscript\'s goal is to check that the generated position follow all of its constraints. \n\nIf at least one condition is not met, then the algorithm will try to \'fix\' the position so that all conditions are met.';
	String get scripts_kinds_head_description => 'There are several types of sub-scripts, and all rules of all defined sub-scripts must be respected by the generated position. \n\nOf course, it must also respect standard chess rules (for example : king of side not in turn musn\'t be in chess).\n\n';
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
}

// Path: home
class _TranslationsHomeEs extends _TranslationsHomeEn {
	_TranslationsHomeEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Inicio';
	@override String get failed_loading_exercise => 'No se pudo cargar el ejercicio: la posición de ajedrez no es válida.';
	@override String get failed_generating_position => 'Falló al generar la posición.';
	@override String get help_message => 'Aquí puedes seleccionar el tipo de posición con la que quieres jugar. Una línea cuyo icono principal es un trofeo generará una posición en la que deberías ganar. De lo contrario, con un icono principal de un apretón de manos, tu objetivo será salvar la partida y hacer empate.';
	@override String get tab_integrated => 'Integrados';
	@override String get tab_added => 'Añadidos';
	@override String get no_game_yet => 'No hay elemento';
	@override String get failed_loading_added_exercises => 'Error al cargar la lista de ejercicios personalizados';
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
	@override String parse_error_dialog_title({required Object Title}) => 'Error de script para ${Title}';
	@override String get type_error => 'Por favor, compruebe que no utiliza un valor int en lugar de un valor booleano y viceversa.';
	@override String get missing_script_type => 'No se pudo generar la posición: compruebe que todas las secciones del script declaran un tipo de script correcto.';
	@override String get misc_error_dialog_title => 'Equivocado global';
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
	@override String get content1 => 'Esta página se utiliza para informarle sobre las políticas con el recopilación, uso y divulgación de información personal para la aplicación, Finales Básicos de Ajedrez. Laurent Bernabe respeta la privacidad de usuarios y se compromete a proteger la información del usuario, ya sea el tuyo o el de tus hijos. Creo que tienes derecho a conocer mi prácticas con respecto a la información que puedo recopilar y usar cuando usted usa mi aplicación.';
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
	@override String get before_exit_title => '¿Cancelar la edición del script?';
	@override String get before_exit_message => '¿Desea salir de esta página y cancelar la edición del script?';
	@override String get syntax_button_label => 'Reglas de sintaxis';
	@override String get variables_button_label => 'Variables predefinidas';
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageEs extends _TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageEs._(_TranslationsEs root) : this._root = root, super._(root);

	@override final _TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Sintaxis de scripts';
	@override String get scripts_goal => 'Objetivo de los scripts';
	@override String get scripts_kinds => 'Tipos de scripts';
	@override String get scripts_format => 'Formato de los scripts';
	@override String get comments => 'Comentarios';
	@override String get variable_creation => 'Creación de variables';
	@override String get predefined_variables_and_values => 'Variables y valores predefinidos';
	@override String get boolean_expressions => 'Expresiones booleanas';
	@override String get int_expressions => 'Expresiones enteras';
	@override String get scripts_goal_description => 'Un script de generación de posiciones se divide en varios subprogramas, cada uno de su propio tipo. \n\nEl objetivo de un subprograma es comprobar que la posición generada cumple con todas sus restricciones. \n\nSi al menos una condición no se cumple, el algoritmo intentará \'arreglar\' la posición para que se cumplan todas las condiciones.';
	@override String get scripts_kinds_head_description => 'Existen varios tipos de subprogramas, y la posición generada debe respetar todas las reglas de todos los subprogramas definidos. \n\nPor supuesto, también debe respetar las reglas estándar del ajedrez (por ejemplo, el rey del lado que no está en turno no puede estar en jaque).\n\n';
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
}

// Path: home
class _TranslationsHomeFr extends _TranslationsHomeEn {
	_TranslationsHomeFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Accueil';
	@override String get failed_loading_exercise => 'Échec de chargement de l\'exerice : la position d\'échecs est invalide.';
	@override String get failed_generating_position => 'Échec de génération de la position.';
	@override String get help_message => 'Ici vous pouvez choisir le type de position avec laquelle vous voulez jouer. Une ligne dont l\'icône est un trophée générera une position où vous devrez gagner. Sinon si la ligne commence par une poignée de main, vous devrez sauver la partie et faire partie nulle.';
	@override String get tab_integrated => 'Intégrés';
	@override String get tab_added => 'Ajoutés';
	@override String get no_game_yet => 'Aucun élément';
	@override String get failed_loading_added_exercises => 'Échec de chargement des exercises personnalisés';
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
	@override String get misc_error_dialog_title => 'Erreur globale';
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
	@override String get content1 => 'Cette page est utilisée pour vous informer sur les politiques de collecte, d\'utilisation et divulgation d\'informations personnelles pour l\'application, Finales d\'Echecs Basiques. Laurent Bernabe respecte la vie privée de utilisateurs et s\'engage à protéger les informations de l\'utilisateur, que ce soit la vôtre ou celle de vos enfants. Je crois que vous avez le droit de connaître mes pratiques concernant les informations que je peux collecter et utiliser lorsque vous utilisez mon application.';
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
	@override String get syntax_button_label => 'Règles de syntaxe';
	@override String get variables_button_label => 'Variables prédéfinies';
}

// Path: syntax_manual_page
class _TranslationsSyntaxManualPageFr extends _TranslationsSyntaxManualPageEn {
	_TranslationsSyntaxManualPageFr._(_TranslationsFr root) : this._root = root, super._(root);

	@override final _TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Syntaxe des scripts';
	@override String get scripts_goal => 'Objectif des scripts';
	@override String get scripts_kinds => 'Types de scripts';
	@override String get scripts_format => 'Format des scripts';
	@override String get comments => 'Commentaires';
	@override String get variable_creation => 'Création de variable';
	@override String get predefined_variables_and_values => 'Variables et valeurs prédéfinies';
	@override String get boolean_expressions => 'Expressions booléennes';
	@override String get int_expressions => 'Expressions entières';
	@override String get scripts_goal_description => 'Un script de génération de position est composé de plusieurs sous-scripts, chacun étant de son propre type. \n\nLe but d\'un sous-script est de vérifier que la position générée respecte toutes ses contraintes. \n\nSi au moins une des conditions n\'est pas respectée, alors l\'algorithme tentera de \'fixer\' la position de telle manière que toutes les contraintes soient respectéees.';
	@override String get scripts_kinds_head_description => 'Il y a plusieurs types de sous-scripts, et toutes les règles définies dans l\'ensemble des sous-scripts doivent être respectées par la position générée. \n\nBien sûr, elle doit aussi respecter les règles standards (par exemple : le roi qui n\'est pas au trait ne doit pas être en échec).\n\n';
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
}
