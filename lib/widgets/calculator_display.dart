import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class CalculatorDisplay extends StatefulWidget {
  const CalculatorDisplay({super.key});

  @override
  State<CalculatorDisplay> createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay>
    with TickerProviderStateMixin {
  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _previewScrollController = ScrollController();
  final ScrollController _resultScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _cursorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cursorController, curve: Curves.easeInOut),
    );
    _cursorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _previewScrollController.dispose();
    _resultScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calculator, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16), // Reduced from 24
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Expression display with editable input and cursor
              Container(
                width: double.infinity,
                height: 60, // Increased height for larger text
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: const BoxDecoration(
                  // Transparent background with no border
                  color: Colors.transparent,
                ),
                child: GestureDetector(
                  onTapDown: (details) {
                    // Calculate cursor position based on tap
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final localPosition = renderBox.globalToLocal(
                      details.globalPosition,
                    );

                    // Adjust for container padding and scroll offset
                    final adjustedX =
                        localPosition.dx - 8 + _scrollController.offset;

                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: calculator.expression,
                        style: const TextStyle(
                          fontSize: 32,
                        ), // Increased font size
                      ),
                      textDirection: TextDirection.ltr,
                    );
                    textPainter.layout();

                    final position = textPainter.getPositionForOffset(
                      Offset(adjustedX, 0),
                    );
                    calculator.setCursorPosition(position.offset);
                    _focusNode.requestFocus();
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 64,
                      ),
                      child: _buildEditableExpression(context, calculator),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Preview display (live calculation preview)
              if (calculator.preview.isNotEmpty && calculator.result.isEmpty)
                Container(
                  width: double.infinity,
                  height: 50, // Increased height for larger text
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    controller: _previewScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    child: Container(
                      alignment: Alignment.centerRight,
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 64,
                      ),
                      child: Text(
                        '= ${calculator.preview}',
                        style: TextStyle(
                          fontSize: 24, // Increased from 18
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),

              // Result display (final answer)
              Container(
                width: double.infinity,
                height: calculator.result.isNotEmpty
                    ? 100
                    : 80, // Increased height
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: calculator.result.isNotEmpty
                      ? Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  controller: _resultScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  child: Container(
                    alignment: Alignment.centerRight,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 64,
                    ),
                    child: Text(
                      calculator.result.isEmpty
                          ? (calculator.expression.isEmpty ? '0' : '')
                          : calculator.result,
                      style: TextStyle(
                        fontSize: calculator.result.isNotEmpty
                            ? 56
                            : 40, // Increased font sizes
                        color: calculator.hasError
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditableExpression(
    BuildContext context,
    CalculatorProvider calculator,
  ) {
    final expression = calculator.expression;
    final cursorPosition = calculator.cursorPosition;

    // Auto-scroll to cursor position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && expression.isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: expression.substring(0, cursorPosition),
            style: const TextStyle(
              fontSize: 32,
            ), // Updated to match input font size
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final cursorOffset = textPainter.width;

        final screenWidth = MediaQuery.of(context).size.width - 48;
        if (cursorOffset > screenWidth) {
          _scrollController.animateTo(
            cursorOffset - screenWidth + 50, // Scroll with some padding
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        } else if (cursorOffset < _scrollController.offset) {
          _scrollController.animateTo(
            cursorOffset - 50, // Scroll with some padding
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    if (expression.isEmpty) {
      return AnimatedBuilder(
        animation: _cursorAnimation,
        builder: (context, child) {
          return Text(
            '|',
            style: TextStyle(
              fontSize: 32, // Increased font size
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: _cursorAnimation.value),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.end,
          );
        },
      );
    }

    final beforeCursor = expression.substring(0, cursorPosition);
    final afterCursor = expression.substring(cursorPosition);

    return AnimatedBuilder(
      animation: _cursorAnimation,
      builder: (context, child) {
        return RichText(
          textAlign: TextAlign.left, // Changed from end to left for scrolling
          text: TextSpan(
            style: TextStyle(
              fontSize: 32, // Increased font size
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.9,
              ), // Slightly more visible
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(text: beforeCursor),
              TextSpan(
                text: '|',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withValues(
                    alpha: _cursorAnimation.value,
                  ),
                ),
              ),
              TextSpan(text: afterCursor),
            ],
          ),
        );
      },
    );
  }
}
