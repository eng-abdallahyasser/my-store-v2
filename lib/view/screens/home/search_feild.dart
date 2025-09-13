import 'package:flutter/material.dart';
import 'package:store_app_v2/core/constants.dart';
import 'package:get/get.dart';
import 'package:store_app_v2/view/screens/products/search_results_screen.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goSearch([String? query]) {
    final q = (query ?? _controller.text).trim();
    if (q.isEmpty) return;
    Get.to(() => SearchResultsScreen(initialQuery: q));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: _goSearch,
        decoration: InputDecoration(
          filled: true,
          fillColor: MyColors.mainColor.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          border: searchOutlineInputBorder,
          focusedBorder: searchOutlineInputBorder,
          enabledBorder: searchOutlineInputBorder,
          hintText: "Search product",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _goSearch,
          ),
        ),
      ),
    );
  }
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);
