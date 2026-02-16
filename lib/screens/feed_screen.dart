import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/topics_provider.dart';
import '../models/flashcard.dart';
import '../models/topic.dart';

class FeedScreen extends StatefulWidget {
  final String topicId;

  const FeedScreen({super.key, required this.topicId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  DateTime? _sessionStart;
  Set<int> _viewedCards = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _sessionStart = DateTime.now();
  }

  @override
  void dispose() {
    _saveProgress();
    _pageController.dispose();
    super.dispose();
  }

  void _saveProgress() {
    if (_sessionStart != null) {
      final duration = DateTime.now().difference(_sessionStart!).inSeconds;
      context.read<TopicsProvider>().updateTopicProgress(
            widget.topicId,
            _viewedCards.length,
            duration,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = context.watch<TopicsProvider>().getFlashcards(widget.topicId);
    
    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('No flashcards available'),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: flashcards.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _viewedCards.add(index);
              });
            },
            itemBuilder: (context, index) {
              return _FlashcardView(
                flashcard: flashcards[index],
                index: index,
                total: flashcards.length,
              );
            },
          ),

          // Top overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopBar(topicId: widget.topicId),
          ),

          // Right sidebar actions
          Positioned(
            right: 16,
            bottom: 120,
            child: _SideActions(),
          ),

          // Pagination dots
          Positioned(
            right: 4,
            top: MediaQuery.of(context).size.height / 2 - 40,
            child: _PaginationDots(
              currentIndex: _currentIndex,
              total: flashcards.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String topicId;

  const _TopBar({required this.topicId});

  @override
  Widget build(BuildContext context) {
    final topic = context.watch<TopicsProvider>().topics.firstWhere(
          (t) => t.id == topicId,
        );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.topic,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  topic.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _FlashcardView extends StatefulWidget {
  final Flashcard flashcard;
  final int index;
  final int total;

  const _FlashcardView({
    required this.flashcard,
    required this.index,
    required this.total,
  });

  @override
  State<_FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<_FlashcardView> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              
              // Card type badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  _getCardTypeLabel(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              Text(
                widget.flashcard.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
              ),
              
              const SizedBox(height: 24),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          widget.flashcard.content,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                              ),
                        ),
                      ),
                      
                      if (widget.flashcard.type == FlashcardType.question) ...[
                        const SizedBox(height: 20),
                        if (!_showAnswer)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => setState(() => _showAnswer = true),
                              icon: const Icon(Icons.visibility),
                              label: const Text('Reveal Answer'),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Answer:',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.flashcard.answer ?? 'No answer provided',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Swipe hint
              if (widget.index < widget.total - 1)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe for next card',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: Text(
                    'Last card',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              
              const SizedBox(height: 8),
              
              // Bottom indicator
              Center(
                child: Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700]?.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCardTypeLabel() {
    switch (widget.flashcard.type) {
      case FlashcardType.concept:
        return 'CONCEPT CARD';
      case FlashcardType.diagram:
        return 'DIAGRAM CARD';
      case FlashcardType.question:
        return 'QUESTION CARD';
    }
  }
}

class _SideActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionButton(
          icon: Icons.favorite_border,
          label: '2.4k',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _ActionButton(
          icon: Icons.bookmark_border,
          label: 'Save',
          onTap: () {},
        ),
        const SizedBox(height: 16),
        _ActionButton(
          icon: Icons.share,
          label: 'Share',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PaginationDots extends StatelessWidget {
  final int currentIndex;
  final int total;

  const _PaginationDots({
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        total > 5 ? 5 : total,
        (index) {
          final isActive = index == currentIndex;
          return Container(
            width: isActive ? 6 : 4,
            height: isActive ? 6 : 4,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          );
        },
      ),
    );
  }
}
