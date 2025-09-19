
//  SPECIAL OFFERS 
class SpecialOffer{
    final int id ; 
    final int discount ; 
    final String offer_image;



SpecialOffer({required this.id , required this.discount , required this.offer_image});

factory SpecialOffer.fromJson(Map<String , dynamic > json){
    return SpecialOffer(
        id:json['id'], 
        discount:json['discount'] , 
        offer_image:json['offer_image'],
    );
}
}

//TOP of the week 
class Books{
    final int id ; 
    final String book_price; 
    final String book_image;
    final String book_title;
    final String is_top ;
    final String book_category;
    final String vendor_image;
    final String book_description ;
    final int book_rating;



Books({required this.id , required this.book_price , required this.book_image , required this.book_title , required this.is_top , required this.book_category , required this.vendor_image , required this.book_description , required this.book_rating});

factory Books.fromJson(Map<String , dynamic > json){
    return Books(
        id:json['id'], 
        book_price:json['book_price'] , 
        book_image:json['book_image'],
        book_title:json['book_title'] , 
        is_top:json['is_top'],
        book_category:json['book_category'],
         vendor_image: json['Vendors']?['vendor_image'],
         book_description :json['book_description'],
         book_rating:json['book_rating'],
    );
}
}


//BEST VENDORS 
class Vendors{
    final int id ; 
    final String vendor_image;
    final String vendor_title;
    final String is_best ;
    final String vendor_category;
    final int vendor_rating ;



Vendors({required this.id , required this.vendor_title , required this.vendor_image , required this.is_best , required this.vendor_category , required this.vendor_rating});

factory Vendors.fromJson(Map<String , dynamic > json){
    return  Vendors(
        id:json['id'], 
       vendor_rating: json['vendor_rating'],
        vendor_image:json['vendor_image'],
        vendor_title:json['vendor_title'] , 
        is_best:json['is_best'],
        vendor_category:json['vendor_category'],
    );
}
}


//WISHLIST 

class Wishlist {
  final int id;
  final String user_id;
  final int book_id;
  final String book_image ;
  final String book_price ;
  final String book_title ;

  Wishlist({
    required this.id,
    required this.user_id,
    required this.book_id,
    required this.book_image,
    required this.book_price,
    required this.book_title


  });

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      id: json['id'] ?? 0,
      user_id: json['user_id'] ?? '',
        book_id: json['book_id'] ?? 0,   
        book_price: json['Books']?['book_price'] ?? '',
        book_image: json['Books']?['book_image'] ?? '',
        book_title: json['Books']?['book_title'] ?? '',
     
    );
  }

  
  
}

class user {
  final String id;
  final String name;
  final String phone;
   final String avatar;

  user({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatar,
  });

  
  
  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      id: json['id'],
      name: json['name'] ,
      phone: json['phone'] ??'',
      avatar:json['avatar_url']?? '',
    );
  }}


