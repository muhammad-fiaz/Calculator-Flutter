import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../providers/calculator_provider.dart';
import '../utils/error_handler.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearHistoryDialog(context),
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search calculations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Statistics
          Consumer<HistoryProvider>(
            builder: (context, history, child) {
              final stats = history.getStatistics();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        stats['totalCalculations'].toString(),
                        context,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Today',
                        stats['todayCalculations'].toString(),
                        context,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'This Week',
                        stats['thisWeekCalculations'].toString(),
                        context,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // History list
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, history, child) {
                final filteredHistory = history.searchHistory(_searchQuery);

                if (filteredHistory.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No calculations yet'
                              : 'No matching calculations',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) {
                    final calculation = filteredHistory[index];
                    return _buildHistoryItem(context, calculation);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, CalculationEntry calculation) {
    // Safety check for null or empty data
    if (calculation.expression.isEmpty && calculation.result.isEmpty) {
      return const SizedBox.shrink(); // Don't show empty entries
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: calculation.expression.isNotEmpty
                    ? calculation.expression
                    : 'N/A',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: ' = ',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              TextSpan(
                text: calculation.result.isNotEmpty
                    ? calculation.result
                    : 'N/A',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          _formatDateTime(calculation.timestamp),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () => _copyToClipboard(context, calculation),
              tooltip: 'Copy to clipboard',
            ),
            IconButton(
              icon: const Icon(Icons.input),
              onPressed: () => _insertIntoCalculator(context, calculation),
              tooltip: 'Insert into calculator',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteCalculation(context, calculation),
              tooltip: 'Delete',
            ),
          ],
        ),
        onTap: () => _insertIntoCalculator(context, calculation),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _insertIntoCalculator(
    BuildContext context,
    CalculationEntry calculation,
  ) {
    try {
      // Safety checks
      if (calculation.expression.isEmpty && calculation.result.isEmpty) {
        ErrorHandler.showWarningToast(
          context,
          'Unable to insert empty calculation',
        );
        return;
      }

      final calculator = Provider.of<CalculatorProvider>(
        context,
        listen: false,
      );

      // Use the expression part only for insertion
      String textToInsert = calculation.expression.isNotEmpty
          ? calculation.expression
          : calculation.result;

      if (textToInsert.isEmpty) {
        ErrorHandler.showWarningToast(context, 'Unable to insert calculation');
        return;
      }

      calculator.insertFromHistory(textToInsert);

      // Navigate back to calculator
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show a brief success message
      ErrorHandler.showSuccessToast(
        context,
        'Inserted: ${calculation.expression}',
      );
    } catch (e) {
      ErrorHandler.showErrorToast(
        context,
        'Error inserting calculation. Please try again.',
      );
      if (kDebugMode) {
        print('Error inserting calculation: $e');
      }
    }
  }

  void _deleteCalculation(
    BuildContext context,
    CalculationEntry calculation,
  ) async {
    try {
      final history = Provider.of<HistoryProvider>(context, listen: false);
      await history.deleteCalculation(calculation.id!);

      if (context.mounted) {
        ErrorHandler.showSuccessToast(context, 'Calculation deleted');
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.showErrorToast(
          context,
          'Failed to delete calculation. Please try again.',
        );
      }
      if (kDebugMode) {
        print('Error deleting calculation: $e');
      }
    }
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text(
            'Are you sure you want to clear all calculation history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await Provider.of<HistoryProvider>(
                    context,
                    listen: false,
                  ).clearHistory();

                  if (context.mounted) {
                    ErrorHandler.showSuccessToast(context, 'History cleared');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ErrorHandler.showErrorToast(
                      context,
                      'Failed to clear history. Please try again.',
                    );
                  }
                  if (kDebugMode) {
                    print('Error clearing history: $e');
                  }
                }
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(
    BuildContext context,
    CalculationEntry calculation,
  ) async {
    try {
      final textToCopy = '${calculation.expression} = ${calculation.result}';
      await Clipboard.setData(ClipboardData(text: textToCopy));

      if (context.mounted) {
        ErrorHandler.showSuccessToast(
          context,
          'Calculation copied to clipboard',
        );
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.showErrorToast(
          context,
          'Failed to copy to clipboard. Please try again.',
        );
      }
      if (kDebugMode) {
        print('Error copying to clipboard: $e');
      }
    }
  }
}
