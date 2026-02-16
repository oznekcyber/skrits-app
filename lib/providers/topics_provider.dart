import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/topic.dart';
import '../models/flashcard.dart';

class TopicsProvider extends ChangeNotifier {
  List<Topic> _topics = [];
  Map<String, List<Flashcard>> _flashcards = {};
  
  List<Topic> get topics => _topics;
  
  TopicsProvider() {
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final topicsJson = prefs.getString('topics');
    if (topicsJson != null) {
      final List<dynamic> decoded = json.decode(topicsJson);
      _topics = decoded.map((json) => Topic.fromJson(json)).toList();
    }
    
    // Load flashcards
    for (var topic in _topics) {
      final cardsJson = prefs.getString('flashcards_${topic.id}');
      if (cardsJson != null) {
        final List<dynamic> decoded = json.decode(cardsJson);
        _flashcards[topic.id] = decoded.map((json) => Flashcard.fromJson(json)).toList();
      }
    }
    
    notifyListeners();
  }

  Future<void> _saveTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_topics.map((t) => t.toJson()).toList());
    await prefs.setString('topics', encoded);
  }

  Future<void> _saveFlashcards(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final cards = _flashcards[topicId] ?? [];
    final encoded = json.encode(cards.map((c) => c.toJson()).toList());
    await prefs.setString('flashcards_$topicId', encoded);
  }

  Future<Topic> createTopic(String title, List<Flashcard> flashcards) async {
    final uuid = const Uuid();
    final topic = Topic(
      id: uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
      lastStudied: DateTime.now(),
      totalCards: flashcards.length,
    );
    
    _topics.add(topic);
    _flashcards[topic.id] = flashcards;
    
    await _saveTopics();
    await _saveFlashcards(topic.id);
    notifyListeners();
    
    return topic;
  }

  List<Flashcard> getFlashcards(String topicId) {
    return _flashcards[topicId] ?? [];
  }

  Future<void> updateTopicProgress(String topicId, int completedCards, int studyTime) async {
    final topic = _topics.firstWhere((t) => t.id == topicId);
    topic.completedCards = completedCards;
    topic.totalStudyTime += studyTime;
    topic.lastStudied = DateTime.now();
    await _saveTopics();
    notifyListeners();
  }

  Future<void> deleteTopic(String topicId) async {
    _topics.removeWhere((t) => t.id == topicId);
    _flashcards.remove(topicId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('flashcards_$topicId');
    await _saveTopics();
    notifyListeners();
  }

  Topic? getMostRecentTopic() {
    if (_topics.isEmpty) return null;
    return _topics.reduce((a, b) => a.lastStudied.isAfter(b.lastStudied) ? a : b);
  }
}
