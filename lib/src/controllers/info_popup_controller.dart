import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:info_popup/info_popup.dart';

import '../painters/arrow_indicator_painter.dart';

part '../overlays/overlay_entry_layout.dart';

part '../painters/high_lighter.dart';

/// Popup manager for the InfoPopup widget.
/// [InfoPopupController] is used to show and dismiss the popup.
class InfoPopupController {
  /// Creates a [InfoPopupController] widget.
  InfoPopupController({
    required this.context,
    required RenderBox targetRenderBox,
    required this.areaBackgroundColor,
    required this.arrowTheme,
    required this.contentTheme,
    required this.layerLink,
    required this.dismissTriggerBehavior,
    required this.enableHighlight,
    required this.highLightTheme,
    this.infoPopupDismissed,
    this.contentTitle,
    this.customContent,
    this.onAreaPressed,
    this.onLayoutMounted,
    this.contentOffset = Offset.zero,
    this.indicatorOffset = Offset.zero,
    this.contentMaxWidth,
  }) : _targetRenderBox = targetRenderBox;

  /// The [layerLink] is the layer link of the popup.
  final LayerLink layerLink;

  /// The context of the widget.
  final BuildContext context;

  /// The [_targetRenderBox] is the render box of the info text.
  RenderBox _targetRenderBox;

  /// The [infoPopupDismissed] is the callback function when the popup is dismissed.
  final VoidCallback? infoPopupDismissed;

  /// The [contentTitle] to show in the popup.
  final String? contentTitle;

  /// The [customContent] is the widget that will be custom shown in the popup.
  final Widget? customContent;

  /// The [areaBackgroundColor] is the background color of the area that
  final Color areaBackgroundColor;

  /// [arrowTheme] is the arrow theme of the popup.
  final InfoPopupArrowTheme arrowTheme;

  /// [contentTheme] is the content theme of the popup.
  final InfoPopupContentTheme contentTheme;

  /// [onAreaPressed] Called when the area outside the popup is pressed.
  final OnAreaPressed? onAreaPressed;

  /// [onLayoutMounted] Called when the info layout is mounted.
  final Function(Size size)? onLayoutMounted;

  /// The [contentOffset] is the offset of the content.
  final Offset contentOffset;

  /// The [indicatorOffset] is the offset of the indicator.
  final Offset indicatorOffset;

  /// The [dismissTriggerBehavior] is the dismissing behavior of the popup.
  final PopupDismissTriggerBehavior dismissTriggerBehavior;

  /// The [infoPopupOverlayEntry] is the overlay entry of the popup.
  OverlayEntry? infoPopupOverlayEntry;

  /// The [infoPopupContainerSize] is the size of the popup.
  Size? infoPopupContainerSize;

  /// [contentMaxWidth] is the max width of the content that is shown.
  /// If the [contentMaxWidth] is null, the max width will be eighty percent
  /// of the screen.
  final double? contentMaxWidth;

  /// The [enableHighlight] is the boolean value that indicates whether the
  /// highlight is enabled or not.
  final bool enableHighlight;

  /// The [highLightTheme] is the theme of the highlight. Can customize the
  /// highlight border radius and the padding.
  final HighLightTheme highLightTheme;

  /// The [show] method is used to show the popup.
  void show() {
    infoPopupOverlayEntry = OverlayEntry(
      builder: (_) {
        return OverlayInfoPopup(
          targetRenderBox: _targetRenderBox,
          contentTitle: contentTitle,
          layerLink: layerLink,
          customContent: customContent,
          areaBackgroundColor: areaBackgroundColor,
          indicatorTheme: arrowTheme,
          contentTheme: contentTheme,
          contentOffset: contentOffset,
          indicatorOffset: indicatorOffset,
          enableHighlight: enableHighlight,
          highlightTheme: highLightTheme,
          dismissTriggerBehavior: dismissTriggerBehavior,
          contentMaxWidth: contentMaxWidth,
          hideOverlay: dismissInfoPopup,
          onLayoutMounted: (Size size) {
            Future<void>.delayed(
              const Duration(milliseconds: 30),
              () {
                infoPopupContainerSize = size;
                infoPopupOverlayEntry?.markNeedsBuild();

                if (onLayoutMounted != null) {
                  onLayoutMounted!.call(size);
                }
              },
            );
          },
          onAreaPressed: () {
            if (onAreaPressed != null) {
              onAreaPressed!.call(this);
              return;
            }

            dismissInfoPopup();
          },
        );
      },
    );

    Overlay.of(context).insert(infoPopupOverlayEntry!);
  }

  /// The [isShowing] method is used to check if the popup is showing.
  bool get isShowing => infoPopupOverlayEntry != null;

  /// [dismissInfoPopup] is used to dismiss the popup.
  void dismissInfoPopup() {
    if (infoPopupOverlayEntry != null) {
      infoPopupOverlayEntry!.remove();
      infoPopupOverlayEntry = null;

      if (infoPopupDismissed != null) {
        infoPopupDismissed!.call();
      }
    }
  }

  /// [updateInfoPopupTargetRenderBox] is used to update the render box of the info text.
  void updateInfoPopupTargetRenderBox(RenderBox renderBox) {
    _targetRenderBox = renderBox;
    infoPopupOverlayEntry?.markNeedsBuild();
  }
}