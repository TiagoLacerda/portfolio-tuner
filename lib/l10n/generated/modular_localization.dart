import 'modular_localization_delegate.dart';
import 'modular_localization_entries.dart';
import 'modular_localization_entries_en.dart';

abstract class ModularLocalization {
  const ModularLocalization();

  static ModularLocalizationEntries entries = const ModularLocalizationEntriesEn();

  /// modular_localization's `LocalizationsDelegate`.
  static const delegate = ModularLocalizationDelegate();

  /// Localized resources.
  static const ModularLocalizationInternalClass0 localizations =
      ModularLocalizationInternalClass0();
}

class ModularLocalizationInternalClass0 implements ModularLocalization {
  const ModularLocalizationInternalClass0();

  /// **.home**: `...`
  ///
  ModularLocalizationInternalClass1 get modules => const ModularLocalizationInternalClass1();
}

class ModularLocalizationInternalClass1 implements ModularLocalization {
  const ModularLocalizationInternalClass1();

  /// **.homeView**: `...`
  ///
  /// **.widgets**: `...`
  ///
  ModularLocalizationInternalClass2 get home => const ModularLocalizationInternalClass2();
}

class ModularLocalizationInternalClass2 implements ModularLocalization {
  const ModularLocalizationInternalClass2();

  /// **.body0**
  ///
  /// `en`: **"The "**
  ///
  /// `pt`: **"O "**
  ///
  /// **.body1**
  ///
  /// `en`: **"YIN algorithm"**
  ///
  /// `pt`: **"algoritmo YIN"**
  ///
  /// **.body10**
  ///
  /// `en`: **"JavaScript"**
  ///
  /// `pt`: **"JavaScript"**
  ///
  /// **.body11**
  ///
  /// `en`: **" bridge. Pitch estimates are sent to the "**
  ///
  /// `pt`: **". As estimativas de tom são enviadas à interface em "**
  ///
  /// **.body12**
  ///
  /// `en`: **"Flutter"**
  ///
  /// `pt`: **"Flutter"**
  ///
  /// **.body13**
  ///
  /// `en`: **" interface, where they are displayed in real time."**
  ///
  /// `pt`: **", onde são exibidas em tempo real."**
  ///
  /// **.body14**
  ///
  /// `en`: **"Press the button below to set a note as the reference. The standard tuning for a guitar's strings is E2 A2 D3 G3 B3 E4."**
  ///
  /// `pt`: **"Pressione o botão abaixo para fixar uma nota como referência. A afinação padrão das cordas de um violão é E2 A2 D3 G3 B3 E4."**
  ///
  /// **.body2**
  ///
  /// `en`: **" estimates pitch by comparing the sound with slightly shifted versions of itself until it finds the best match, with the inverse of this delay being the signal's "**
  ///
  /// `pt`: **" estima o tom comparando o som com versões levemente deslocadas dele próprio até encontrar a melhor correspondência, sendo o inverso deste atraso a "**
  ///
  /// **.body3**
  ///
  /// `en`: **"estimated frequency"**
  ///
  /// `pt`: **"frequência estimada"**
  ///
  /// **.body4**
  ///
  /// `en`: **"."**
  ///
  /// `pt`: **" do sinal."**
  ///
  /// **.body5**
  ///
  /// `en`: **"Microphone audio is processed by a "**
  ///
  /// `pt`: **"O áudio do microfone é processado por uma "**
  ///
  /// **.body6**
  ///
  /// `en`: **"C++ engine"**
  ///
  /// `pt`: **"engine em C++"**
  ///
  /// **.body7**
  ///
  /// `en`: **", compiled to "**
  ///
  /// `pt`: **", compilada para "**
  ///
  /// **.body8**
  ///
  /// `en`: **"WebAssembly"**
  ///
  /// `pt`: **"WebAssembly"**
  ///
  /// **.body9**
  ///
  /// `en`: **" and integrated into the application through a "**
  ///
  /// `pt`: **" e integrada ao aplicativo por uma ponte em "**
  ///
  /// **.brightnessSwitchTooltip**
  ///
  /// `en`: **"Dark/light mode"**
  ///
  /// `pt`: **"Modo claro/escuro"**
  ///
  /// **.button**
  ///
  /// `en`: **"Tap to tune"**
  ///
  /// `pt`: **"Pressione para afinar"**
  ///
  /// **.homeButtonTooltip**
  ///
  /// `en`: **"Homepage"**
  ///
  /// `pt`: **"Página inicial"**
  ///
  /// **.localeButtonTooltip**
  ///
  /// `en`: **"Language"**
  ///
  /// `pt`: **"Idioma"**
  ///
  ModularLocalizationInternalClass3 get homeView => const ModularLocalizationInternalClass3();
  /// **.microphoneAccessDialog**: `...`
  ///
  /// **.tunerTargetDialog**: `...`
  ///
  /// **.tunerWidget**: `...`
  ///
  ModularLocalizationInternalClass4 get widgets => const ModularLocalizationInternalClass4();
}

class ModularLocalizationInternalClass3 implements ModularLocalization {
  const ModularLocalizationInternalClass3();

  /// `en`: **"The "**
  ///
  /// `pt`: **"O "**
  ///
  String get body0 => ModularLocalization.entries.entry0;

  /// `en`: **"YIN algorithm"**
  ///
  /// `pt`: **"algoritmo YIN"**
  ///
  String get body1 => ModularLocalization.entries.entry1;

  /// `en`: **"JavaScript"**
  ///
  /// `pt`: **"JavaScript"**
  ///
  String get body10 => ModularLocalization.entries.entry2;

  /// `en`: **" bridge. Pitch estimates are sent to the "**
  ///
  /// `pt`: **". As estimativas de tom são enviadas à interface em "**
  ///
  String get body11 => ModularLocalization.entries.entry3;

  /// `en`: **"Flutter"**
  ///
  /// `pt`: **"Flutter"**
  ///
  String get body12 => ModularLocalization.entries.entry4;

  /// `en`: **" interface, where they are displayed in real time."**
  ///
  /// `pt`: **", onde são exibidas em tempo real."**
  ///
  String get body13 => ModularLocalization.entries.entry5;

  /// `en`: **"Press the button below to set a note as the reference. The standard tuning for a guitar's strings is E2 A2 D3 G3 B3 E4."**
  ///
  /// `pt`: **"Pressione o botão abaixo para fixar uma nota como referência. A afinação padrão das cordas de um violão é E2 A2 D3 G3 B3 E4."**
  ///
  String get body14 => ModularLocalization.entries.entry6;

  /// `en`: **" estimates pitch by comparing the sound with slightly shifted versions of itself until it finds the best match, with the inverse of this delay being the signal's "**
  ///
  /// `pt`: **" estima o tom comparando o som com versões levemente deslocadas dele próprio até encontrar a melhor correspondência, sendo o inverso deste atraso a "**
  ///
  String get body2 => ModularLocalization.entries.entry7;

  /// `en`: **"estimated frequency"**
  ///
  /// `pt`: **"frequência estimada"**
  ///
  String get body3 => ModularLocalization.entries.entry8;

  /// `en`: **"."**
  ///
  /// `pt`: **" do sinal."**
  ///
  String get body4 => ModularLocalization.entries.entry9;

  /// `en`: **"Microphone audio is processed by a "**
  ///
  /// `pt`: **"O áudio do microfone é processado por uma "**
  ///
  String get body5 => ModularLocalization.entries.entry10;

  /// `en`: **"C++ engine"**
  ///
  /// `pt`: **"engine em C++"**
  ///
  String get body6 => ModularLocalization.entries.entry11;

  /// `en`: **", compiled to "**
  ///
  /// `pt`: **", compilada para "**
  ///
  String get body7 => ModularLocalization.entries.entry12;

  /// `en`: **"WebAssembly"**
  ///
  /// `pt`: **"WebAssembly"**
  ///
  String get body8 => ModularLocalization.entries.entry13;

  /// `en`: **" and integrated into the application through a "**
  ///
  /// `pt`: **" e integrada ao aplicativo por uma ponte em "**
  ///
  String get body9 => ModularLocalization.entries.entry14;

  /// `en`: **"Dark/light mode"**
  ///
  /// `pt`: **"Modo claro/escuro"**
  ///
  String get brightnessSwitchTooltip => ModularLocalization.entries.entry15;

  /// `en`: **"Tap to tune"**
  ///
  /// `pt`: **"Pressione para afinar"**
  ///
  String get button => ModularLocalization.entries.entry16;

  /// `en`: **"Homepage"**
  ///
  /// `pt`: **"Página inicial"**
  ///
  String get homeButtonTooltip => ModularLocalization.entries.entry17;

  /// `en`: **"Language"**
  ///
  /// `pt`: **"Idioma"**
  ///
  String get localeButtonTooltip => ModularLocalization.entries.entry18;

}

class ModularLocalizationInternalClass4 implements ModularLocalization {
  const ModularLocalizationInternalClass4();

  /// **.body**
  ///
  /// `en`: **"To use the tuner, you need to allow access to the microphone in your browser settings."**
  ///
  /// `pt`: **"Para utilizar o afinador é necessário que você permita o acesso ao microfone nas configurações do seu navegador."**
  ///
  /// **.button**
  ///
  /// `en`: **"GOT IT"**
  ///
  /// `pt`: **"ENTENDI"**
  ///
  /// **.title**
  ///
  /// `en`: **"Microphone Access"**
  ///
  /// `pt`: **"Acesso ao Microfone"**
  ///
  ModularLocalizationInternalClass5 get microphoneAccessDialog => const ModularLocalizationInternalClass5();
  /// **.clear**
  ///
  /// `en`: **"CLEAR"**
  ///
  /// `pt`: **"LIMPAR"**
  ///
  /// **.select**
  ///
  /// `en`: **"SELECT"**
  ///
  /// `pt`: **"SELECIONAR"**
  ///
  /// **.title**
  ///
  /// `en`: **"SELECT A NOTE"**
  ///
  /// `pt`: **"SELECIONE UMA NOTA"**
  ///
  ModularLocalizationInternalClass6 get tunerTargetDialog => const ModularLocalizationInternalClass6();
  /// **.hint**
  ///
  /// `en`: **"Play a note"**
  ///
  /// `pt`: **"Toque uma nota"**
  ///
  ModularLocalizationInternalClass7 get tunerWidget => const ModularLocalizationInternalClass7();
}

class ModularLocalizationInternalClass5 implements ModularLocalization {
  const ModularLocalizationInternalClass5();

  /// `en`: **"To use the tuner, you need to allow access to the microphone in your browser settings."**
  ///
  /// `pt`: **"Para utilizar o afinador é necessário que você permita o acesso ao microfone nas configurações do seu navegador."**
  ///
  String get body => ModularLocalization.entries.entry19;

  /// `en`: **"GOT IT"**
  ///
  /// `pt`: **"ENTENDI"**
  ///
  String get button => ModularLocalization.entries.entry20;

  /// `en`: **"Microphone Access"**
  ///
  /// `pt`: **"Acesso ao Microfone"**
  ///
  String get title => ModularLocalization.entries.entry21;

}

class ModularLocalizationInternalClass6 implements ModularLocalization {
  const ModularLocalizationInternalClass6();

  /// `en`: **"CLEAR"**
  ///
  /// `pt`: **"LIMPAR"**
  ///
  String get clear => ModularLocalization.entries.entry22;

  /// `en`: **"SELECT"**
  ///
  /// `pt`: **"SELECIONAR"**
  ///
  String get select => ModularLocalization.entries.entry23;

  /// `en`: **"SELECT A NOTE"**
  ///
  /// `pt`: **"SELECIONE UMA NOTA"**
  ///
  String get title => ModularLocalization.entries.entry24;

}

class ModularLocalizationInternalClass7 implements ModularLocalization {
  const ModularLocalizationInternalClass7();

  /// `en`: **"Play a note"**
  ///
  /// `pt`: **"Toque uma nota"**
  ///
  String get hint => ModularLocalization.entries.entry25;

}


