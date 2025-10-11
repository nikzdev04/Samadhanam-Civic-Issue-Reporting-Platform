import 'package:flutter/material.dart';

class FilterAndSearchBar extends StatefulWidget {
  // 1. Define callbacks for search and filter actions
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilter;

  const FilterAndSearchBar({
    super.key,
    this.onSearch,
    this.onFilter,
  });

  @override
  State<FilterAndSearchBar> createState() => _FilterAndSearchBarState();
}

class _FilterAndSearchBarState extends State<FilterAndSearchBar> {
  // 2. Create a TextEditingController
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 3. Listen for text changes and call the onSearch callback
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // 4. Dispose of the controller to prevent memory leaks
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Call the provided onSearch callback with the current text
    widget.onSearch?.call(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // 5. Attach the controller to the TextField
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ID or title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              // Optional: Submit when user presses 'Done'/'Search' on keyboard
              onSubmitted: (value) => widget.onSearch?.call(value),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            // 6. Use the dynamic onFilter callback
            onPressed: widget.onFilter,
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(12.0),
            ),
          ),
        ],
      ),
    );
  }
}