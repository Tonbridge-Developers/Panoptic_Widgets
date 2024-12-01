import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panoptic_widgets/panoptic_widgets.dart';
import 'package:panoptic_widgets/src/static/core_values.dart';

class PanopticDecimalFormField extends PanopticFormFieldDecoration<String> {
  final TextEditingController? controller;
  PanopticDecimalFormField({
    super.key,
    super.onSaved,
    super.validator,
    required super.name,
    super.enabled = true,
    super.onChanged,
    bool autoValidate = false,
    this.controller,
    bool forceColumn = false,
    double? initialValue,
    String? label,
    String? hintText,
    Widget? icon,
    bool autocorrect = true,
    bool autofocus = false,
    bool readOnly = false,
    bool showCursor = true,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(17),
    EdgeInsetsGeometry leadingPadding = const EdgeInsets.all(5),
    Function(double?)? onFieldSubmitted,
    Function(double?)? onChangedDouble,

    //Use the alternative bg color
    alternative = false,
    bool fullWidth = false,
    String? currency,
  }) : super(
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          initialValue:
              controller != null ? controller.text : initialValue.toString(),
          builder: (FormFieldState<String> field) {
            final state = field as PanopticFormDecimalFieldState;
            return KeyboardAction(
              focusNode: FocusScope.of(state.context),
              child: fullWidth
                  ? TextFormField(
                      enabled: enabled,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Only support number input
                      autocorrect: autocorrect,
                      autofocus: autofocus,

                      readOnly: readOnly,
                      showCursor: showCursor,
                      controller: state._effectiveController,

                      onChanged: (value) {
                        if (value.isEmpty) {
                          state.didChange(null);
                        } else {
                          state.didChange(value);
                          onChangedDouble?.call(double.tryParse(value));
                        }
                      },
                      onFieldSubmitted: (value) {
                        if (onFieldSubmitted != null) {
                          onFieldSubmitted(double.tryParse(value));
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: icon,
                        prefixText: currency, // Add currency prefix
                        fillColor: (alternative
                                ? Theme.of(state.context)
                                    .colorScheme
                                    .surfaceContainer
                                : Theme.of(state.context).colorScheme.surface)
                            .withAlpha(55),
                        filled: true,
                        contentPadding: contentPadding,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CoreValues.cornerRadius * 0.8),
                          borderSide: BorderSide(
                              color: state.hasError
                                  ? Theme.of(state.context).colorScheme.error
                                  : Theme.of(state.context)
                                      .colorScheme
                                      .onSurface),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CoreValues.cornerRadius * 0.8),
                          borderSide: BorderSide(
                            width: 1,
                            color: state.hasError
                                ? Theme.of(state.context).colorScheme.error
                                : Theme.of(state.context).colorScheme.onSurface,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CoreValues.cornerRadius * 0.8),
                          borderSide: BorderSide(
                            width: 1,
                            color: state.hasError
                                ? Theme.of(state.context).colorScheme.error
                                : Theme.of(state.context).colorScheme.onSurface,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CoreValues.cornerRadius * 0.8),
                          borderSide: BorderSide(
                              color: state.hasError
                                  ? Theme.of(state.context).colorScheme.error
                                  : Theme.of(state.context)
                                      .colorScheme
                                      .onSurface),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              CoreValues.cornerRadius * 0.8),
                          borderSide: BorderSide(
                            width: 1,
                            color: state.hasError
                                ? Theme.of(state.context).colorScheme.error
                                : Theme.of(state.context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    style: Theme.of(state.context)
                                        .textTheme
                                        .bodyLarge,
                                  ),
                                  if (hintText != null) ...{
                                    Tooltip(
                                      message: hintText,
                                      preferBelow: true,
                                      verticalOffset: 10,
                                      triggerMode: kIsWeb
                                          ? null
                                          : TooltipTriggerMode.tap,
                                      child: PanopticIcon(
                                        icon: PanopticIcons.infoRound,
                                        size: 15,
                                        margin: const EdgeInsets.only(
                                            left: 5, top: 2),
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
                                maxWidth:
                                    MediaQuery.of(state.context).size.width,
                              ),
                              width: forceColumn ? null : 400,
                              child: TextFormField(
                                enabled: enabled,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'))
                                ],
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal:
                                            true), // Only support number input
                                autocorrect: autocorrect,
                                autofocus: autofocus,

                                readOnly: readOnly,
                                showCursor: showCursor,
                                controller: state._effectiveController,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    state.didChange(null);
                                  } else {
                                    state.didChange(value);
                                    onChangedDouble
                                        ?.call(double.tryParse(value));
                                  }
                                },
                                onFieldSubmitted: (value) {
                                  if (onFieldSubmitted != null) {
                                    onFieldSubmitted(double.tryParse(value));
                                  }
                                },
                                decoration: InputDecoration(
                                  prefixIcon: icon,
                                  prefixText: currency, // Add currency prefix
                                  fillColor: (alternative
                                          ? Theme.of(state.context)
                                              .colorScheme
                                              .surfaceContainer
                                          : Theme.of(state.context)
                                              .colorScheme
                                              .surface)
                                      .withAlpha(55),
                                  filled: true,
                                  contentPadding: contentPadding,
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CoreValues.cornerRadius * 0.8),
                                    borderSide: BorderSide(
                                        color: state.hasError
                                            ? Theme.of(state.context)
                                                .colorScheme
                                                .error
                                            : Theme.of(state.context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CoreValues.cornerRadius * 0.8),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: state.hasError
                                          ? Theme.of(state.context)
                                              .colorScheme
                                              .error
                                          : Theme.of(state.context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CoreValues.cornerRadius * 0.8),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: state.hasError
                                          ? Theme.of(state.context)
                                              .colorScheme
                                              .error
                                          : Theme.of(state.context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CoreValues.cornerRadius * 0.8),
                                    borderSide: BorderSide(
                                        color: state.hasError
                                            ? Theme.of(state.context)
                                                .colorScheme
                                                .error
                                            : Theme.of(state.context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CoreValues.cornerRadius * 0.8),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: state.hasError
                                          ? Theme.of(state.context)
                                              .colorScheme
                                              .error
                                          : Theme.of(state.context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                              )
                            ],
                          )
                      ],
                    ),
            );
          },
        );
  @override
  PanopticFormFieldDecorationState<PanopticDecimalFormField, String>
      createState() => PanopticFormDecimalFieldState();
}

class PanopticFormDecimalFieldState
    extends PanopticFormFieldDecorationState<PanopticDecimalFormField, String> {
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
