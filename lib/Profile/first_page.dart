import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/Profile/HelpCenter.dart';
import 'package:projet_final/Profile/address.dart';
import 'package:projet_final/auth/auth_controller.dart';
import 'package:projet_final/Sign_pages/sign_in.dart';
import 'package:projet_final/models/models.dart';
import 'package:projet_final/models/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projet_final/Profile/my_account.dart';
import 'Offers_promos.dart';
import 'package:projet_final/Home/wishlist.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: usersAsync.when(
        data: (users) {
          if (currentUser == null) {
            return const Center(child: Text("No user logged in"));
          }

          final currentUserData = users.firstWhere(
            (u) => u.id == currentUser.id,
            orElse: () => user(id: '', name: '', phone: '', avatar: ''),
          );

          final avatarList = [
            'assets/avatars/image1.png',
            'assets/avatars/image2.png',
            'assets/avatars/image3.png',
            'assets/avatars/image4.png',
          ];

          void _showAvatarSheet() {

            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: avatarList.length,
                  itemBuilder: (context, index) {
                    final avatar= avatarList[index];
                    return GestureDetector(
                      onTap: () async {
                        await ref
                            .read(usersProvider.notifier)
                            .updateUserData(currentUser.id, avatarUrl:avatar);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(avatar),
                      ),
                    );
                  },
                );
              },
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Divider(),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height:10),
                        GestureDetector(
                          onTap: _showAvatarSheet,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: currentUserData.avatar.isNotEmpty
                                ? AssetImage(currentUserData.avatar)
                                : const AssetImage('assets/avatars/default.png'),
                          ),
                        ),
                        const SizedBox(height: 4),
                       
                         Text(
                            "Click to change",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF54408C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUserData.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            currentUserData.phone.isNotEmpty
                                ? currentUserData.phone
                                : '',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                       Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const SignInPage()),
);

                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color.fromARGB(255, 216, 214, 214)),
                SizedBox(height:12),
                _Menu(
                  icon: Icons.person_outline,
                  title: 'My Account',
                  onTap: () {
                   Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const MyAccountPage()),
);

                  },
                ),
                _Menu(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  onTap: () {
                   Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AddressPage()),
);

                  },
                ),
                _Menu(
                  icon: Icons.favorite_border,
                  title: 'Your Favorites',
                  onTap: () {
                    Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const WishList()),
);

                  },
                ),
                 _Menu(
                  icon: Icons.local_offer_outlined,
                  title: 'Offers & Promos',
                  onTap: () {
                     Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const OffersPromosPage()),
);

                  },
                ), 

                _Menu(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  onTap: () {
                     Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const HelpCenterPage()),
);
                  },
                ),
               
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _Menu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: Color(0xFF54408C)),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
        SizedBox(height:20),
      ],
    );
  }
}
