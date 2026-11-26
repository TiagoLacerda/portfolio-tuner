import 'dart:math';

abstract class ModularLocalizationEntries {
  const ModularLocalizationEntries();

  /// Replaces matches of `RegExp(r'%s')` with given [arguments].
  ///
  /// **example:**
  /// ```dart
  /// print(replaceArguments('I love %s and %s!', ['cakes', 'pie'])) // 'I love cakes and pie!'
  /// ```
  String replaceArguments(
    String string, [
    List<String> arguments = const [],
  ]) {
    var regExp = RegExp(r'%s');

    // Lower between number of arguments and argument slots.
    var limit = min(arguments.length, regExp.allMatches(string).length);

    for (int i = 0; i < limit; i++) {
      string = string.replaceFirst(regExp, arguments[i]);
    }

    return string;
  }

  /// `en`: **"The "**
  ///
  /// `pt`: **"O "**
  String get entry0;

  /// `en`: **"YIN algorithm"**
  ///
  /// `pt`: **"algoritmo YIN"**
  String get entry1;

  /// `en`: **"JavaScript"**
  ///
  /// `pt`: **"JavaScript"**
  String get entry2;

  /// `en`: **" bridge. Pitch estimates are sent to the "**
  ///
  /// `pt`: **". As estimativas de tom são enviadas à interface em "**
  String get entry3;

  /// `en`: **"Flutter"**
  ///
  /// `pt`: **"Flutter"**
  String get entry4;

  /// `en`: **" interface, where they are displayed in real time."**
  ///
  /// `pt`: **", onde são exibidas em tempo real."**
  String get entry5;

  /// `en`: **"Press the button below to set a note as the reference. The standard tuning for a guitar's strings is E2 A2 D3 G3 B3 E4."**
  ///
  /// `pt`: **"Pressione o botão abaixo para fixar uma nota como referência. A afinação padrão das cordas de um violão é E2 A2 D3 G3 B3 E4."**
  String get entry6;

  /// `en`: **" estimates pitch by comparing the sound with slightly shifted versions of itself until it finds the best match, with the inverse of this delay being the signal's "**
  ///
  /// `pt`: **" estima o tom comparando o som com versões levemente deslocadas dele próprio até encontrar a melhor correspondência, sendo o inverso deste atraso a "**
  String get entry7;

  /// `en`: **"estimated frequency"**
  ///
  /// `pt`: **"frequência estimada"**
  String get entry8;

  /// `en`: **"."**
  ///
  /// `pt`: **" do sinal."**
  String get entry9;

  /// `en`: **"Microphone audio is processed by a "**
  ///
  /// `pt`: **"O áudio do microfone é processado por uma "**
  String get entry10;

  /// `en`: **"C++ engine"**
  ///
  /// `pt`: **"engine em C++"**
  String get entry11;

  /// `en`: **", compiled to "**
  ///
  /// `pt`: **", compilada para "**
  String get entry12;

  /// `en`: **"WebAssembly"**
  ///
  /// `pt`: **"WebAssembly"**
  String get entry13;

  /// `en`: **" and integrated into the application through a "**
  ///
  /// `pt`: **" e integrada ao aplicativo por uma ponte em "**
  String get entry14;

  /// `en`: **"Dark/light mode"**
  ///
  /// `pt`: **"Modo claro/escuro"**
  String get entry15;

  /// `en`: **"Tap to tune"**
  ///
  /// `pt`: **"Pressione para afinar"**
  String get entry16;

  /// `en`: **"Homepage"**
  ///
  /// `pt`: **"Página inicial"**
  String get entry17;

  /// `en`: **"Language"**
  ///
  /// `pt`: **"Idioma"**
  String get entry18;

  /// `en`: **"To use the tuner, you need to allow access to the microphone in your browser settings."**
  ///
  /// `pt`: **"Para utilizar o afinador é necessário que você permita o acesso ao microfone nas configurações do seu navegador."**
  String get entry19;

  /// `en`: **"GOT IT"**
  ///
  /// `pt`: **"ENTENDI"**
  String get entry20;

  /// `en`: **"Microphone Access"**
  ///
  /// `pt`: **"Acesso ao Microfone"**
  String get entry21;

  /// `en`: **"CLEAR"**
  ///
  /// `pt`: **"LIMPAR"**
  String get entry22;

  /// `en`: **"SELECT"**
  ///
  /// `pt`: **"SELECIONAR"**
  String get entry23;

  /// `en`: **"SELECT A NOTE"**
  ///
  /// `pt`: **"SELECIONE UMA NOTA"**
  String get entry24;

  /// `en`: **"Play a note"**
  ///
  /// `pt`: **"Toque uma nota"**
  String get entry25;
}
