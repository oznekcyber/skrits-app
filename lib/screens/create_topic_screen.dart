import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/topics_provider.dart';
import '../models/flashcard.dart';

class CreateTopicScreen extends StatefulWidget {
  const CreateTopicScreen({super.key});

  @override
  State<CreateTopicScreen> createState() => _CreateTopicScreenState();
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final _topicController = TextEditingController();
  String _difficulty = 'Intermediate';
  bool _isGenerating = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _generateFlashcards() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 3));

    // Generate sample flashcards
    final flashcards = _createSampleFlashcards(_topicController.text);

    if (mounted) {
      setState(() => _isGenerating = false);

      // Create topic
      final topic = await context.read<TopicsProvider>().createTopic(
            _topicController.text,
            flashcards,
          );

      // Navigate to feed
      Navigator.of(context).pushReplacementNamed('/feed', arguments: topic.id);
    }
  }

  List<Flashcard> _createSampleFlashcards(String topicName) {
    const uuid = Uuid();
    final topicId = uuid.v4();

    return [
      Flashcard(
        id: uuid.v4(),
        topicId: topicId,
        type: FlashcardType.concept,
        title: 'Introduction to $topicName',
        content:
            'This is a foundational concept card explaining the basics of $topicName. '
            'It provides key definitions and core principles that are essential for understanding this topic.',
      ),
      Flashcard(
        id: uuid.v4(),
        topicId: topicId,
        type: FlashcardType.concept,
        title: 'Key Principles',
        content:
            'Understanding the key principles of $topicName is crucial. '
            'These principles form the foundation for more advanced concepts and practical applications.',
      ),
      Flashcard(
        id: uuid.v4(),
        topicId: topicId,
        type: FlashcardType.question,
        title: 'What is the main purpose of $topicName?',
        content: 'Test your understanding with this question.',
        answer:
            'The main purpose is to understand and apply the core concepts effectively in real-world scenarios.',
      ),
      Flashcard(
        id: uuid.v4(),
        topicId: topicId,
        type: FlashcardType.concept,
        title: 'Practical Applications',
        content:
            'In real-world scenarios, $topicName is applied in various contexts. '
            'Understanding these applications helps bridge theory and practice.',
      ),
      Flashcard(
        id: uuid.v4(),
        topicId: topicId,
        type: FlashcardType.question,
        title: 'How would you apply this concept?',
        content: 'Think about practical examples and use cases.',
        answer:
            'You can apply this by following best practices and adapting the principles to your specific context.',
      ),
      Flashcard(
        id: uuid.v4(),
        topicId: topicId,
        type: FlashcardType.concept,
        title: 'Advanced Concepts',
        content:
            'Once you master the basics, you can explore more advanced topics in $topicName. '
            'These build upon the foundational knowledge you\'ve gained.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isGenerating) {
      return const _GeneratingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Study Feed'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What do you want to learn?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),

              // Topic Selection Cards
              _SelectionCard(
                icon: Icons.edit_note,
                title: 'Enter Topic Manually',
                description: 'Quick AI-generated flashcards',
                isSelected: true,
                onTap: () {},
              ),

              const SizedBox(height: 16),

              _SelectionCard(
                icon: Icons.upload_file,
                title: 'Upload Lecture Material',
                description: 'Coming soon',
                isSelected: false,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Topic Input
              TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  labelText: 'Topic Name',
                  hintText: 'e.g., Quantum Physics, Machine Learning',
                  prefixIcon: const Icon(Icons.topic),
                ),
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 24),

              // Difficulty Dropdown
              DropdownButtonFormField<String>(
                value: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty Level',
                  prefixIcon: Icon(Icons.tune),
                ),
                items: ['Beginner', 'Intermediate', 'Advanced']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _difficulty = value);
                  }
                },
              ),

              const Spacer(),

              // Generate Button
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _generateFlashcards,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate Flashcards'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[600],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeneratingScreen extends StatefulWidget {
  const _GeneratingScreen();

  @override
  State<_GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<_GeneratingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentStep = 0;
  final List<String> _steps = [
    'Analyzing content...',
    'Extracting key concepts...',
    'Generating flashcards...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _startStepAnimation();
  }

  void _startStepAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && _currentStep < _steps.length - 1) {
        setState(() => _currentStep++);
        _startStepAnimation();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: _controller,
                child: Icon(
                  Icons.auto_awesome,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                _steps[_currentStep],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: (_currentStep + 1) / _steps.length,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
