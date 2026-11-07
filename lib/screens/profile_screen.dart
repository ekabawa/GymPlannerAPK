import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/workout_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color backgroundColor = Color(0xFF131326);
  static const Color cardColor = Color(0xFF1D2B39);
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color successColor = Color(0xFF10B981);

  String _name = 'I Putu Eka Bawa Utama';
  String _nim = '2415051008';
  String _kelas = 'PTI 5A';
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _name = prefs.getString('user_profile_name') ?? 'I Putu Eka Bawa Utama';
        _nim = prefs.getString('user_profile_nim') ?? '2415051008';
        _kelas = prefs.getString('user_profile_kelas') ?? 'PTI 5A';
        _imagePath = prefs.getString('user_profile_image_path');
      });
    } catch (_) {}
  }

  Future<void> _saveProfileData({
    required String name,
    required String nim,
    required String kelas,
    required String? imagePath,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile_name', name);
      await prefs.setString('user_profile_nim', nim);
      await prefs.setString('user_profile_kelas', kelas);

      if (imagePath != null && imagePath.isNotEmpty) {
        await prefs.setString('user_profile_image_path', imagePath);
      } else {
        await prefs.remove('user_profile_image_path');
      }

      if (!mounted) return;
      setState(() {
        _name = name;
        _nim = nim;
        _kelas = kelas;
        _imagePath = imagePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Profile Updated Successfully!'),
            ],
          ),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (_) {}
  }

  Future<String?> _pickImageFromFile() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return picked?.path;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih file gambar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return null;
    }
  }

  void _showEditProfileModal() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: _name);
    final nimController = TextEditingController(text: _nim);
    final kelasController = TextEditingController(text: _kelas);
    String? tempImagePath = _imagePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final hasImage = tempImagePath != null &&
                tempImagePath!.isNotEmpty &&
                File(tempImagePath!).existsSync();

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF171F2A),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Header Modal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white60),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Preview Avatar & Opsi Foto File
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final path = await _pickImageFromFile();
                                  if (path != null) {
                                    setModalState(() {
                                      tempImagePath = path;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withValues(alpha: 0.35),
                                        blurRadius: 16,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: cardColor,
                                    backgroundImage: hasImage
                                        ? FileImage(File(tempImagePath!))
                                        : null,
                                    child: !hasImage
                                        ? const Icon(
                                            Icons.person,
                                            size: 55,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final path = await _pickImageFromFile();
                                  if (path != null) {
                                    setModalState(() {
                                      tempImagePath = path;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF171F2A),
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Tombol Cari Foto di File
                          Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final path = await _pickImageFromFile();
                                  if (path != null) {
                                    setModalState(() {
                                      tempImagePath = path;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor.withValues(alpha: 0.2),
                                  foregroundColor: const Color(0xFF60A5FA),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                icon: const Icon(Icons.folder_open, size: 18),
                                label: const Text(
                                  'Browse Photos in Files',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (hasImage)
                                OutlinedButton.icon(
                                  onPressed: () {
                                    setModalState(() {
                                      tempImagePath = null;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    side: BorderSide(
                                      color: Colors.redAccent.withValues(alpha: 0.5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  label: const Text(
                                    'Hapus',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form Data Profil
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Name'),
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: _modalInputDecoration(
                              hint: 'Enter Your Name.',
                              icon: Icons.person_outline,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Name Is Required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          _buildFieldLabel('NIM'),
                          TextFormField(
                            controller: nimController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: _modalInputDecoration(
                              hint: 'Masukkan NIM',
                              icon: Icons.badge_outlined,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'NIM wajib diisi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          _buildFieldLabel('Class'),
                          TextFormField(
                            controller: kelasController,
                            textCapitalization: TextCapitalization.characters,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: _modalInputDecoration(
                              hint: 'Contoh: PTI 5A',
                              icon: Icons.school_outlined,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Class Is Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol Aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: const BorderSide(color: Color(0xFF2D3A48)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final newName = nameController.text.trim();
                                final newNim = nimController.text.trim();
                                final newKelas = kelasController.text.trim();

                                Navigator.pop(context);

                                _saveProfileData(
                                  name: newName,
                                  nim: newNim,
                                  kelas: newKelas,
                                  imagePath: tempImagePath,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _modalInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF60A5FA), size: 20),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF131D28),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D3A48)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2D3A48)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _imagePath != null &&
        _imagePath!.isNotEmpty &&
        File(_imagePath!).existsSync();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showEditProfileModal,
            icon: const Icon(Icons.edit_note, color: Colors.white),
            tooltip: 'Edit Profile',
          ),
        ],
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Avatar Profil dengan Foto dari File & Badge Edit
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _showEditProfileModal,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.25),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: cardColor,
                      backgroundImage:
                          hasImage ? FileImage(File(_imagePath!)) : null,
                      child: !hasImage
                          ? const Icon(
                              Icons.person,
                              size: 65,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _showEditProfileModal,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: backgroundColor,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Nama Pengguna
            Text(
              _name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // NIM
            Text(
              _nim,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 6),

            // Kelas
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _kelas,
                style: const TextStyle(
                  color: Color(0xFF60A5FA),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Edit Profil
            OutlinedButton.icon(
              onPressed: _showEditProfileModal,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFF2D3A48),
                  width: 1.5,
                ),
                backgroundColor: cardColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFF60A5FA),
              ),
              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Statistik Workout
            Consumer<WorkoutProvider>(
              builder: (context, provider, child) {
                final totalWorkout = provider.workouts.length;

                final completedWorkout = provider.workouts
                    .where((workout) => workout.isCompleted)
                    .length;

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.fitness_center,
                        value: provider.isLoading
                            ? '...'
                            : '$totalWorkout',
                        label: 'Workout',
                        iconColor: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.check_circle,
                        value: provider.isLoading
                            ? '...'
                            : '$completedWorkout',
                        label: 'Completed',
                        iconColor: successColor,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Informasi Aplikasi
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'App Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2D3A48),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF2D3A48),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/images/Logo.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/Logo.png.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.fitness_center,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GYMPLANNER',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Workout Planning Application',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(
                    color: Color(0xFF2D3A48),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'GYMPLANNER is a mobile application '
                    'that helps users manage workout schedules, '
                    'view exercise lists, and monitor workout '
                    'history and progress.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Icon(
                        Icons.phone_android,
                        color: Colors.white54,
                        size: 20,
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Platform',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const Text(
                        'Flutter Mobile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(
                        Icons.storage,
                        color: Colors.white54,
                        size: 20,
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Backend',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const Text(
                        'Supabase',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2D3A48),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
