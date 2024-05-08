import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tvt_gallery/tvt_gallery.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/app/chats/widget/chat_option/padding_panel.dart';
import 'package:youreal/app/chats/widget/chat_option/primary_button.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';

part 'chat_input_event.dart';
part 'chat_input_state.dart';

class ChatInputBloc extends Bloc<ChatInputEvent, ChatInputState> {
  ChatInputBloc(BuildContext context) : super(ChatInputState.initial()) {
    _mapEventToState();
    _initGalleryPicker(context);
    dealOptionPanelController = PanelController();
  }

  late final PanelController dealOptionPanelController;

  _initGalleryPicker(context) {
    galleryPickerController = GalleryController(
      gallerySetting: GallerySetting(
        enableCamera: false,
        maximum: 10,
        requestType: RequestType.image,
        actionButton: PrimaryButton(
          onTap: () {
            galleryPickerController.completeTask(context);
          },
          text: 'Gửi',
        ),
        albumTitleStyle: kText14Weight400_Light,
        albumSubTitleStyle: kText14Weight400_Light,
        selectionCountBackgroundColor: yrColorPrimary,
        albumBackground: const ColoredBox(
          color: yrColorSecondary,
        ),
        albumColor: yrColorSecondary,
        crossAxisCount: 4,
      ),
      panelSetting: PanelSetting(
        // background: Image.asset('../assets/bg.jpeg', fit: BoxFit.cover),
        background: const ColoredBox(
          color: yrColorSecondary,
        ),
        minHeight: PaddingPanel.kPanelContainerMinHeight,
        maxHeight: PaddingPanel.kPanelContainerMaxHeight,
      ),
      headerSetting: HeaderSetting(
        headerLeftWidget: Text(
          "Hủy",
          style: kText18Weight400_Light,
        ),
        barSize: Size(100.w, 4.w),
        barColor: yrColorLight,
        headerBackground: const ColoredBox(
          color: yrColorSecondary,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        headerRightWidget: Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Text(
            "Album",
            style: kText14Weight400_Light,
          ),
        ),
        headerCenterWidget: const SizedBox(),
      ),
    );
    galleryPickerController.galleryState.addListener(() {
      if (galleryPickerController.isShowPanel &&
          state.inputOption == InputOption.Picture) {
        emit(state.copyWith(inputOption: InputOption.Idle));
      }
    });
  }

  @override
  Future<void> close() {
    galleryPickerController.dispose();
    return super.close();
  }

  late final GalleryController galleryPickerController;

  _mapEventToState() {
    on<ChatInputTextFieldExpandedChanged>((event, emit) {
      emit(state.copyWith(
          isTextFieldExpanded: event.isExpanded,
          inputOption: InputOption.Idle));
    });
    on<ChatInputOptionChanged>(_chatInputOptionChangedToState);
    on<ChatInputDealOptionTypeChanged>(_dealOptionTypeChangedToState);
    on<ChatInputKeyboardVisibilityChanged>(_keyboardVisibilityChangedToState);
    on<ChatInputSlidingPanelStateChanged>(_slidingPanelStateChangedToState);
  }

  _dealOptionTypeChangedToState(ChatInputDealOptionTypeChanged event, emit) {
    emit(state.copyWith(dealOptionType: event.optionType));
  }

  _chatInputOptionChangedToState(ChatInputOptionChanged event, emit) async {
    emit(state.copyWith(inputOption: event.option));

    //region deal option
    if ((event.option == InputOption.Add ||
            event.option == InputOption.Location) &&
        !dealOptionPanelController.isPanelShown) {
      dealOptionPanelController.show();
      add(const ChatInputSlidingPanelStateChanged(SlidingPanelState.Shown));
    } else if (event.option != InputOption.Add &&
        event.option != InputOption.Location) {
      dealOptionPanelController.hide();
      add(const ChatInputSlidingPanelStateChanged(SlidingPanelState.Hidden));
    }
    //endregion

    //region image picker
    if (event.option == InputOption.Picture &&
        !galleryPickerController.isShowPanel) {
      final pickedImages = await galleryPickerController.pick(event.context);
      galleryPickerController.clearSelection();
      final imagePaths = <String>[];
      for (final image in pickedImages) {
        final file = await image.entity.originFile;
        if (file != null) imagePaths.add(file.path);
      }
      event.context
          .read<ChatDetailBloc>()
          .add(ChatDetailImageMessageSent(imagePaths));
    } else if (galleryPickerController.isShowPanel) {
      galleryPickerController.close();
    }
    //endregion

    //region camera
    if (event.option == InputOption.Camera) {
      final cameraResult = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      emit(
        state.copyWith(inputOption: InputOption.Idle),
      );
      if (cameraResult != null) {
        event.context.read<ChatDetailBloc>().add(
              ChatDetailImageMessageSent(
                [cameraResult.path],
              ),
            );
      }
    }
    //endregion
  }

  FutureOr<void> _keyboardVisibilityChangedToState(
      ChatInputKeyboardVisibilityChanged event, Emitter<ChatInputState> emit) {
    emit(state.copyWith(isKeyboardOpened: event.isVisible));

    if ((state.inputOption == InputOption.Add ||
            state.inputOption == InputOption.Location) &&
        state.panelState == SlidingPanelState.Closed &&
        event.isVisible) {
      dealOptionPanelController.open();
      add(const ChatInputSlidingPanelStateChanged(SlidingPanelState.Opened));
    }
  }

  FutureOr<void> _slidingPanelStateChangedToState(
      ChatInputSlidingPanelStateChanged event, Emitter<ChatInputState> emit) {
    emit(state.copyWith(panelState: event.panelState));
  }
}
