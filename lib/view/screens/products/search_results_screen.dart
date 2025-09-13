import 'package:flutter/material.dart';
import 'package:store_app_v2/data/data_source/repo.dart';
import 'package:store_app_v2/data/data_source/product_repository.dart';
import 'package:store_app_v2/data/model/product.dart';
import 'package:store_app_v2/view/global%20widget/product_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;

  const SearchResultsScreen({super.key, required this.initialQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _controller;
  List<Product> _results = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _runSearch(widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ensureProductsLoaded() async {
    final ProductRepository repo = Repo.product;
    if (!repo.isProductsFetched) {
      setState(() => _loading = true);
      await repo.fetchAllProducts();
      setState(() => _loading = false);
    }
  }

  Future<void> _runSearch(String query) async {
    await _ensureProductsLoaded();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }
    final products = Repo.product.fetchedProducts;
    final filtered = products.where((p) {
      final title = p.title.toLowerCase();
      final category = p.category.toLowerCase();
      return title.contains(q) || category.contains(q);
    }).toList();
    setState(() => _results = filtered);
  }

  void _onSubmit(String value) {
    _runSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextField(
            controller: _controller,
            autofocus: false,
            decoration: const InputDecoration(
              hintText: 'Search products...',
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: _onSubmit,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _onSubmit(_controller.text),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              _runSearch('');
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? const Center(child: Text('No results'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    const horizontalPadding = 16.0;
                    const gridSpacing = 12.0;
                    final availableWidth = constraints.maxWidth - (horizontalPadding * 2) - gridSpacing;
                    final itemWidth = availableWidth / 2;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: gridSpacing,
                          crossAxisSpacing: gridSpacing,
                          childAspectRatio: 0.70,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final product = _results[index];
                          return ProductCard(
                            width: itemWidth,
                            product: product,
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
