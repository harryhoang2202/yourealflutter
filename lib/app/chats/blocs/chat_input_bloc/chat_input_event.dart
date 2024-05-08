part of 'chat_input_bloc.dart';

abstract class ChatInputEvent extends Equatable {
  const ChatInputEvent();
}

class ChatInputOptionChanged extends ChatInputEvent {
  final InputOption option;
  final BuildContext context;
  const ChatInputOptionChanged(this.option, this.context);
  @override
  List<Object?> get props => [option, context];
}

class ChatInputTextFieldExpandedChanged extends ChatInputEvent {
  final bool isExpanded;

  const ChatInputTextFieldExpandedChanged(this.isExpanded);
  @override
  List<Object?> get props => [isExpanded];
}

class ChatInputDealOptionTypeChanged extends ChatInputEvent {
  final DealOptionType optionType;

  const ChatInputDealOptionTypeChanged(this.optionType);
  @override
  List<Object?> get props => [optionType];
}

class ChatInputKeyboardVisibilityChanged extends ChatInputEvent {
  final bool isVisible;

  const ChatInputKeyboardVisibilityChanged(this.isVisible);
  @override
  List<Object?> get props => [isVisible];
}

class ChatInputSlidingPanelStateChanged extends ChatInputEvent {
  final SlidingPanelState panelState;

  const ChatInputSlidingPanelStateChanged(this.panelState);
  @override
  List<Object?> get props => [panelState];
}
