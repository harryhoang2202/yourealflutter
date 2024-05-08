part of 'chat_input_bloc.dart';

class ChatInputState extends Equatable {
  final bool isTextFieldExpanded;
  final InputOption inputOption;
  final DealOptionType dealOptionType;
  final bool isKeyboardOpened;
  final SlidingPanelState panelState;

  @override
  List<Object?> get props => [
        isTextFieldExpanded,
        inputOption,
        dealOptionType,
        isKeyboardOpened,
        panelState,
      ];
  factory ChatInputState.initial() => const ChatInputState(
        isTextFieldExpanded: false,
        inputOption: InputOption.Idle,
        dealOptionType: DealOptionType.Modify,
        isKeyboardOpened: false,
        panelState: SlidingPanelState.Closed,
      );

//<editor-fold desc="Data Methods">

  const ChatInputState({
    required this.isTextFieldExpanded,
    required this.inputOption,
    required this.dealOptionType,
    required this.isKeyboardOpened,
    required this.panelState,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatInputState &&
          runtimeType == other.runtimeType &&
          isTextFieldExpanded == other.isTextFieldExpanded &&
          inputOption == other.inputOption &&
          dealOptionType == other.dealOptionType &&
          isKeyboardOpened == other.isKeyboardOpened &&
          panelState == other.panelState);

  @override
  int get hashCode =>
      isTextFieldExpanded.hashCode ^
      inputOption.hashCode ^
      dealOptionType.hashCode ^
      isKeyboardOpened.hashCode ^
      panelState.hashCode;

  @override
  String toString() {
    return 'ChatInputState{' +
        ' isTextFieldExpanded: $isTextFieldExpanded,' +
        ' inputOption: $inputOption,' +
        ' dealOptionType: $dealOptionType,' +
        ' isKeyboardOpened: $isKeyboardOpened,' +
        ' panelState: $panelState,' +
        '}';
  }

  ChatInputState copyWith({
    bool? isTextFieldExpanded,
    InputOption? inputOption,
    DealOptionType? dealOptionType,
    bool? isKeyboardOpened,
    SlidingPanelState? panelState,
  }) {
    return ChatInputState(
      isTextFieldExpanded: isTextFieldExpanded ?? this.isTextFieldExpanded,
      inputOption: inputOption ?? this.inputOption,
      dealOptionType: dealOptionType ?? this.dealOptionType,
      isKeyboardOpened: isKeyboardOpened ?? this.isKeyboardOpened,
      panelState: panelState ?? this.panelState,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isTextFieldExpanded': isTextFieldExpanded,
      'inputOption': inputOption,
      'dealOptionType': dealOptionType,
      'isKeyboardOpened': isKeyboardOpened,
      'panelState': panelState,
    };
  }

  factory ChatInputState.fromMap(Map<String, dynamic> map) {
    return ChatInputState(
      isTextFieldExpanded: map['isTextFieldExpanded'] as bool,
      inputOption: map['inputOption'] as InputOption,
      dealOptionType: map['dealOptionType'] as DealOptionType,
      isKeyboardOpened: map['isKeyboardOpened'] as bool,
      panelState: map['panelState'] as SlidingPanelState,
    );
  }

//</editor-fold>
}
