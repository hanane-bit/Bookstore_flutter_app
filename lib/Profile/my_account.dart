import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projet_final/models/models.dart';
import 'package:projet_final/models/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:projet_final/auth/auth_controller.dart';

class MyAccountPage extends ConsumerStatefulWidget {
  const MyAccountPage({super.key});

  @override
  ConsumerState<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends ConsumerState<MyAccountPage> {
  bool obscure = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final avatarList = [
    'assets/avatars/image1.png',
    'assets/avatars/image2.png',
    'assets/avatars/image3.png',
    'assets/avatars/image4.png',
  ];

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
                    final avatarPath = avatarList[index];
                    return GestureDetector(
                      onTap: () async {
                        await ref
                            .read(usersProvider.notifier)
                            .updateUserData(currentUser.id, avatarUrl: avatarPath);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(avatarPath),
                      ),
                    );
                  },
                );
              },
            );
          }

          Future<void> _saveChanges() async {
            try {
              await ref.read(usersProvider.notifier).updateUserData(
                    currentUser.id,
                    name: nameController.text,
                    phone: phoneController.text,
                  );

              if (emailController.text.isNotEmpty &&
                  emailController.text != (currentUser.email ?? '')) {
                await ref
                    .read(authControllerProvider.notifier)
                    .updateEmail(emailController.text);
              }

              if (passwordController.text.isNotEmpty) {
                await ref
                    .read(authControllerProvider.notifier)
                    .updatePassword(passwordController.text);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Changes saved successfully")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showAvatarSheet,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: currentUserData.avatar.isNotEmpty
                        ? AssetImage(currentUserData.avatar)
                        : const AssetImage('assets/avatars/default.png'),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Change Avatar",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF54408C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField("Name", nameController, Icons.person_outline),
                const SizedBox(height: 16),
                _buildTextField("Email", emailController, Icons.email_outlined),
                const SizedBox(height: 16),
                _buildTextField(
                    "Phone Number", phoneController, Icons.phone_outlined),
                const SizedBox(height: 16),
                _buildPasswordField("Password", passwordController),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54408C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
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

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF54408C), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade400,
              ),
              onPressed: () {
                setState(() => obscure = !obscure);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF54408C), width: 1.5),
            ),
          ),
        );
      },
    );
  }
}
