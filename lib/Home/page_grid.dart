import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/Home/book_details.dart';
import 'package:projet_final/Home/home_page.dart';
import 'package:projet_final/models/providers.dart';
import 'package:projet_final/models/models.dart';


class SeeAllPage extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final bool isvendors;

   const SeeAllPage({
    super.key,
    required this.isvendors,
    required this.subtitle,
    required this.title,
  });

  @override
  ConsumerState<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends ConsumerState<SeeAllPage> {
  String selected_category = "ALL";
  String searchQuery = "";
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final categories = widget.isvendors
        ? ["ALL", "BOOKS", "POEMS", "SPECIAL FOR YOU", "JOURNALS"]
        : ["ALL", "NOVELS", "THRILLER", "SCIENCE", "ROMANTIC"];

    final asyncData =
        widget.isvendors ? ref.watch(vendorsProvider) : ref.watch(booksProvider);

    return asyncData.when(
      data: (items) {
       
        final filteredItems = selected_category == "ALL"
            ? items
            : items.where((item) =>
                    widget.isvendors
                        ? (item as Vendors).vendor_category == selected_category
                        : (item as Books).book_category == selected_category)
                .toList();

      
        final displayedItems = searchQuery.isEmpty
            ? filteredItems
            : filteredItems.where((item) {
                if (widget.isvendors) {
                  return (item as Vendors)
                      .vendor_title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                } else {
                  return (item as Books)
                      .book_title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }
              }).toList();

        if (items.isEmpty) {
          return Scaffold(
            appBar: buildAppbar(context),
            body: const Center(child: Text('Aucun element disponible')),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppbar(context),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSearching) ...[
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: Color(0xFF54408C),
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
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
                ],
              

                Flexible(
                  child: displayedItems.isEmpty
                      ? const Center(child: Text("Aucun résultat trouvé"))
                      : GridView.builder(
                          itemCount: displayedItems.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final item = displayedItems[index];
                            return widget.isvendors
                                ? VendorsCard(vendor: item as Vendors)
                                : BooksCard(book: item as Books);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
      error: (err, stack) => Scaffold(
        appBar: buildAppbar(context),
        body: Center(child: Text('Error : $err')),
      ),
      loading: () => Scaffold(
        appBar: buildAppbar(context),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: isSearching
          ? TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            )
          : Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) searchQuery = "";
            });
          },
          icon: Icon(isSearching ? Icons.close : Icons.search),
        ),
      ],
    );
  }
}

class VendorsCard extends StatelessWidget {
  final Vendors vendor;
  const VendorsCard({required this.vendor, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(vendor.vendor_image),
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
                  vendor.vendor_title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) {
                      return Icon(
                        index < vendor.vendor_rating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.yellow.shade700,
                        size: 16,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BooksCard extends StatelessWidget {
  final Books book;
  const BooksCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showBookDetails(context, book);
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.book_price,
                    style: const TextStyle(
                        color: Color(0xFF54408C),
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
