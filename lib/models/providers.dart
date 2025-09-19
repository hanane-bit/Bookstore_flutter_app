import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/main.dart';

import 'package:projet_final/models/models.dart';




class SpecialOffersController extends AsyncNotifier<List<SpecialOffer>> {
  @override
  Future<List<SpecialOffer>> build() async {
    return fetchSpecialOffers();
  }

  Future<List<SpecialOffer>> fetchSpecialOffers() async {
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase.from('Special_offers').select();
    final data = res as List<dynamic>;
    return data.map((e) => SpecialOffer.fromJson(e)).toList();
  }
}

final specialOffersProvider = AsyncNotifierProvider<SpecialOffersController, List<SpecialOffer>>(
  SpecialOffersController.new,
);


//Books
class BooksController extends AsyncNotifier<List<Books>> {
  @override
  Future<List<Books>> build() async {
    return fetchBooks();
  }

  Future<List<Books>> fetchBooks() async {
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase
        .from('Books')
        .select('id, book_price, book_image, book_title, is_top, book_category, book_description, book_rating, vendor_id, Vendors(vendor_image)');
    final data = res as List<dynamic>;
    return data.map((e) => Books.fromJson(e)).toList();
  }
}

final booksProvider = AsyncNotifierProvider<BooksController, List<Books>>(
  BooksController.new,
);


//  VENDORS
class VendorsController extends AsyncNotifier<List<Vendors>> {
  @override
  Future<List<Vendors>> build() async {
    return fetchVendors();
  }

  Future<List<Vendors>> fetchVendors() async {
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase.from('Vendors').select();
    final data = res as List<dynamic>;
    return data.map((e) => Vendors.fromJson(e)).toList();
  }
}

final vendorsProvider = AsyncNotifierProvider<VendorsController, List<Vendors>>(
  VendorsController.new,
);


// WISHLIST
class WishlistController extends AsyncNotifier<List<Wishlist>> {
  @override
  Future<List<Wishlist>> build() async {
    return fetchWishlist();
  }

  Future<List<Wishlist>> fetchWishlist() async {
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase
        .from('WishList')
        .select('id, book_id, Books(book_price, book_image, book_title)');
    final data = res as List<dynamic>;
    return data.map((e) => Wishlist.fromJson(e)).toList();
  }

  Future<void> addToWishlist(Books book) async {
    final supabase = ref.read(supabaseClientProvider);
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User is not logged in");

    await supabase.from('WishList').insert({
      'user_id': user.id,
      'book_id': book.id,
    });

    final newWishlist = Wishlist(
      id: 0,
      user_id: user.id,
      book_id: book.id,
      book_image: book.book_image,
      book_price: book.book_price,
      book_title: book.book_title,
    );

    state = AsyncValue.data([...(state.value ?? []), newWishlist]);
  }

  Future<void> removeFromWishlist(int bookId) async {
    final supabase = ref.read(supabaseClientProvider);
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await supabase
        .from('WishList')
        .delete()
        .eq('user_id', user.id)
        .eq('book_id', bookId);

    state = AsyncValue.data(
      state.value!.where((item) => item.book_id != bookId).toList(),
    );
  }
}

final wishlistProvider = AsyncNotifierProvider<WishlistController, List<Wishlist>>(
  WishlistController.new,
);



class usersController extends AsyncNotifier<List<user>> {
  @override
  Future<List<user>> build() async {
    return fetchusers();
  }

  Future<List<user>> fetchusers() async {
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase.from('Users').select(); 
    final data = res as List<dynamic>;
    return data.map((e) => user.fromJson(e)).toList();
  }

  Future<void> adduser(user user) async {
    final supabase = ref.read(supabaseClientProvider);
    await supabase.from('Users').insert({
      'id': user.id,
      'name': user.name,
      'phone': user.phone,
    });

    state = AsyncValue.data([...(state.value ?? []), user]);
  }

Future<void> updateUserData(
  String userId, {
  String? name,
  String? phone,
  String? avatarUrl,
}) async {
  final supabase = ref.read(supabaseClientProvider);
  final currentList = state.value ?? [];


  final updates = <String, dynamic>{};
  if (name != null) updates['name'] = name;
  if (phone != null) updates['phone'] = phone;
  if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

  if (updates.isEmpty) return; 

  state = const AsyncLoading();

  state = await AsyncValue.guard(() async {
    await supabase.from('Users').update(updates).eq('id', userId);

   
    final updated = currentList.map((u) {
      if (u.id == userId) {
        return user(
          id: u.id,
          name: name ?? u.name,
          phone: phone ?? u.phone,
          avatar: avatarUrl ?? u.avatar,
        );
      }
      return u;
    }).toList();

    return updated;
  });
}

}


final usersProvider = AsyncNotifierProvider<usersController, List<user>>(
  usersController.new,
);



