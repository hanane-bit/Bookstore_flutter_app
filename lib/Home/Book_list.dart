import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/models/providers.dart';


class BooksList extends ConsumerStatefulWidget {
  const BooksList({super.key});

  @override
  ConsumerState<BooksList> createState() => _BooksListState();
}

class _BooksListState extends ConsumerState<BooksList> {
  String selected_category = "ALL";

  void _onSearchTapped() async {
    final books = await ref.read(booksProvider.future);
    showSearch(
      context: context,
      delegate: BookSearchDelegate(books),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ["ALL", "NOVELS", "THRILLER", "SCIENCE", "ROMANTIC"];
    final booksAsync = ref.watch(booksProvider);

    return booksAsync.when(
      data: (books) {
        if (books.isEmpty) return const Center(child: Text("Aucun livre disponible"));

        final filteredBooks = selected_category == "ALL"
            ? books
            : books.where((book) => book.book_category == selected_category).toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF54408C)),
            ),
            title: const Text(
              'Category',
              style: TextStyle(
                color: Color(0xFF54408C),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: _onSearchTapped,
                icon: const Icon(Icons.search, color: Color(0xFF54408C)),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: selected_category == category,
                            onSelected: (value) {
                              if (value) {
                                setState(() {
                                  selected_category = category;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: filteredBooks.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(book.book_image),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.book_title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      book.book_price,
                                      style: const TextStyle(
                                        color: Color(0xFF54408C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (err, stack) => Center(child: Text(err.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List books;
  BookSearchDelegate(this.books);

  @override
  String? get searchFieldLabel => 'Rechercher un livre';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) => book.book_title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: Image.network(book.book_image, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(book.book_title),
          subtitle: Text(book.book_price),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.book_title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          leading: Image.network(book.book_image, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(book.book_title),
          subtitle: Text(book.book_price),
          onTap: () {
            query = book.book_title;
            showResults(context);
          },
        );
      },
    );
  }
}
