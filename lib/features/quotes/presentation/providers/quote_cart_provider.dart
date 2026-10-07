import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quote_cart_provider.g.dart';

class QuoteItem {
  final String id;
  final String title;
  final String? imageUrl;
  final String? price;

  QuoteItem({
    required this.id,
    required this.title,
    this.imageUrl,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory QuoteItem.fromJson(Map<String, dynamic> json) {
    return QuoteItem(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}

@riverpod
class QuoteCart extends _$QuoteCart {
  @override
  List<QuoteItem> build() {
    _loadQuotes();
    return [];
  }

  Future<void> _loadQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('quotes_cart_items');
    if (jsonList != null) {
      final List<QuoteItem> loaded = [];
      for (final jsonStr in jsonList) {
        try {
          loaded.add(QuoteItem.fromJson(jsonDecode(jsonStr)));
        } catch (e) {
          // Ignore parse errors
        }
      }
      state = loaded;
    }
  }

  Future<void> addQuote(QuoteItem item) async {
    if (state.any((l) => l.id == item.id)) return;
    state = [...state, item];
    await _saveQuotes();
  }

  Future<void> removeQuote(String id) async {
    state = state.where((l) => l.id != id).toList();
    await _saveQuotes();
  }
  
  Future<void> clearQuotes() async {
    state = [];
    await _saveQuotes();
  }
  
  bool isAdded(String id) {
    return state.any((l) => l.id == id);
  }

  Future<void> _saveQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('quotes_cart_items', jsonList);
  }
}
