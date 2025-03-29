// ignore_for_file: invalid_use_of_protected_member, use_build_context_synchronously, implementation_imports

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panoptic_widgets/panoptic_widgets.dart';
import 'package:panoptic_widgets/src/static/core_values.dart';

class PanopticCheckedTextFormField extends PanopticFormFieldDecoration<String> {
  final TextEditingController? controller;

  PanopticCheckedTextFormField({
    super.key,
    super.onSaved,
    required super.name,
    super.enabled,
    super.onChanged,
    this.controller,
    bool autoValidate = false,
    initialValue,
    String? label,
    String? hintText,
    String? placeholder,
    Widget? icon,
    bool obscureText = false,
    bool autocorrect = true,
    bool autofocus = false,
    bool readOnly = false,
    bool showCursor = true,
    bool checkedEnabled = false,
    bool copyButton = false,
    String? Function(String?)? validator,
    int? maxLines,
    int? minLines,
    int? maxLength,
    int? maxCharacters,
    int? minCharacters,
    bool isDense = false,
    double width = 400,
    bool forceColumn = false,
    int alpha = 255,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(17),
    EdgeInsetsGeometry leadingPadding = const EdgeInsets.all(5),
    Function(String)? onFieldSubmitted,
    List<String> autoFillHints = const [],
    List<TextInputFormatter> inputFormatters = const [],
    Widget? trailing,
    //Use the alternative bg color
    alternative = false,
  }) : super(
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          initialValue: controller != null ? controller.text : initialValue,
          validator: checkedEnabled && enabled ? validator : null,
          builder: (FormFieldState<String> field) {
            final state = field as PanopticFormTextFieldState;
            return Column(
              children: [
                PanopticResponsiveLayout(
                  forceColumn: forceColumn,
                  childrenPadding: const EdgeInsets.all(2),
                  rowCrossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (label != null)
                      Row(
                        children: [
                          Text(
                            label,
                            style: Theme.of(state.context).textTheme.bodyLarge,
                          ),
                          if (hintText != null) ...{
                            Tooltip(
                              message: hintText,
                              preferBelow: true,
                              verticalOffset: 10,
                              triggerMode:
                                  kIsWeb ? null : TooltipTriggerMode.tap,
                              child: PanopticIcon(
                                icon: PanopticIcons.infoRound,
                                size: 15,
                                margin: const EdgeInsets.only(left: 5, top: 2),
                                color: Theme.of(state.context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(100),
                              ),
                            )
                          }
                        ],
                      ),
                    Padding(padding: leadingPadding),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(state.context).size.width,
                      ),
                      width: forceColumn ? null : width,
                      child: Row(
                        children: [
                          PanopticExpanded(
                            // expandOnDesktop: checked || copyButton,
                            // expandOnMobile: checked || copyButton,
                            flex: 4,
                            child: _buildTextField(
                              state,
                              checkedEnabled,
                              enabled,
                              placeholder,
                              icon,
                              trailing,
                              obscureText,
                              autocorrect,
                              autofocus,
                              readOnly,
                              showCursor,
                              maxLines,
                              minLines,
                              maxLength,
                              isDense,
                              alpha,
                              contentPadding,
                              onChanged,
                              onFieldSubmitted,
                              alternative,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (!checkedEnabled) ...{
                            PanopticIconButton(
                              icon: PanopticIcons.edit,
                              size: 50,
                              isDisabled: !enabled,
                              onTap: () {
                                checkedEnabled = true;
                                state.setState(() {});
                              },
                            )
                          } else ...{
                            PanopticIconButton(
                              icon: PanopticIcons.undo,
                              size: 50,
                              isDisabled: !enabled,
                              onTap: () {
                                checkedEnabled = false;
                                state.didChange(initialValue);
                                state.setState(() {});
                              },
                            ),
                          },
                        ],
                      ),
                    ),
                    if (state.hasError)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            state.errorText ?? 'An error occurred',
                            style: Theme.of(state.context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(state.context)
                                        .colorScheme
                                        .error),
                          ),
                        ],
                      ),
                  ],
                )
              ],
            );
          },
        );

  static Widget _buildTextField(
    PanopticFormTextFieldState state,
    bool checkedEnabled,
    bool enabled,
    String? placeholder,
    Widget? icon,
    Widget? trailing,
    bool obscureText,
    bool autocorrect,
    bool autofocus,
    bool readOnly,
    bool showCursor,
    int? maxLines,
    int? minLines,
    int? maxLength,
    bool isDense,
    int alpha,
    EdgeInsetsGeometry contentPadding,
    Function(String)? onChanged,
    Function(String)? onFieldSubmitted,
    bool alternative,
  ) {
    return TextFormField(
      enabled: checkedEnabled && enabled,
      obscureText: obscureText,
      controller: state._effectiveController,
      autocorrect: autocorrect,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: (value) {
        onChanged?.call(value);
        state.didChange(value);
      },
      onFieldSubmitted: (value) {
        onFieldSubmitted?.call(value);
      },
      decoration: InputDecoration(
        hintText: placeholder,
        prefixIcon: icon,
        suffixIcon: trailing,
        fillColor: (alternative
                ? Theme.of(state.context).colorScheme.surfaceContainer
                : Theme.of(state.context).colorScheme.surface)
            .withAlpha(alpha),
        filled: true,
        contentPadding: contentPadding,
        isDense: isDense,
        focusedErrorBorder: _border(state),
        focusedBorder: _border(state),
        enabledBorder: _border(state),
        errorBorder: _border(state),
        border: _border(state),
      ),
    );
  }

  static OutlineInputBorder _border(PanopticFormTextFieldState state) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(CoreValues.cornerRadius * 0.8),
      borderSide: BorderSide(
        width: 1,
        color: state.hasError
            ? Theme.of(state.context).colorScheme.error
            : Theme.of(state.context).colorScheme.onSurface,
      ),
    );
  }

  @override
  PanopticFormFieldDecorationState<PanopticCheckedTextFormField, String>
      createState() => PanopticFormTextFieldState();
}

class PanopticFormTextFieldState extends PanopticFormFieldDecorationState<
    PanopticCheckedTextFormField, String> {
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    //setting this to value instead of initialValue here is OK since we handle initial value in the parent class
    _controller = widget.controller ?? TextEditingController(text: value);
    _controller!.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    // Dispose the _controller when initState created it
    _controller!.removeListener(_handleControllerChanged);
    if (null == widget.controller) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = initialValue ?? '';
    });
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
    setState(() {});
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController!.text != (value ?? '')) {
      didChange(_effectiveController!.text);
    }
  }
}
