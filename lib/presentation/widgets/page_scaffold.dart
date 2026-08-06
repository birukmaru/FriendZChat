/// Shared widget: wraps [Scaffold] with a responsive content-width
/// constraint and an optional [PageHeader] at the top.
///
/// Every screen that previously did its own padding + custom AppBar should
/// use this scaffold for consistency.
library;

import 'package:flutter/material.dart';

import 'package:friendzchat/theme/app_dimensions.dart';
import 'package:friendzchat/presentation/widgets/page_header.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    this.appBar,
    this.header,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.l),
    this.extendBody = false,
  });

  final PreferredSizeWidget? appBar;
  final PageHeader? header;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsetsGeometry padding;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = contentMaxWidth(width);

    Widget? child = body;
    if (child != null && maxWidth < double.infinity) {
      child = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) header!,
            if (child != null)
              Expanded(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}