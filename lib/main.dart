import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulir Data Pengguna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // WARNA: diganti dari biru muda ke teal
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ).copyWith(
          primary: Colors.teal.shade600,
          onPrimary: Colors.white, // warna teks/ikon di atas warna utama
        ),
        scaffoldBackgroundColor: const Color(0xFFF1FAF8),
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _namaC = TextEditingController();
  final _npmC = TextEditingController();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  // State pilihan
  bool _obscure = true;
  String? _jenisKelamin;
  String? _programStudi;
  bool _setuju = false;

  // HOBI: ubah daftar ini kalau ingin ganti/tambah hobi
  final Map<String, bool> _hobi = {
    'Musik': false,
    'Gaming': false,
    'Traveling': false,
    'Memasak': false,
    'Menggambar': false,
  };

  // Pesan error untuk komponen non-TextFormField
  bool _showGenderError = false;
  bool _showHobiError = false;
  bool _showSetujuError = false;

  // PROGRAM STUDI: ubah daftar ini kalau ingin ganti pilihan
  final _programList = const [
    'Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Industri',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    _namaC.dispose();
    _npmC.dispose();
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  List<String> get _hobiTerpilih =>
      _hobi.entries.where((e) => e.value).map((e) => e.key).toList();

  void _simpan() {
    // Validasi field teks + dropdown lewat Form
    final formValid = _formKey.currentState!.validate();

    // Validasi manual untuk radio, checkbox hobi, dan persetujuan
    setState(() {
      _showGenderError = _jenisKelamin == null;
      _showHobiError = _hobiTerpilih.isEmpty;
      _showSetujuError = !_setuju;
    });

    if (formValid &&
        !_showGenderError &&
        !_showHobiError &&
        !_showSetujuError) {
      _tampilkanRingkasan();
    }
  }

  void _tampilkanRingkasan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ringkasan Data'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _baris('Nama Lengkap', _namaC.text.trim()),
              _baris('NPM', _npmC.text.trim()),
              _baris('Email', _emailC.text.trim()),
              _baris('Password', '•' * _passwordC.text.length),
              _baris('Jenis Kelamin', _jenisKelamin!),
              _baris('Hobi', _hobiTerpilih.join(', ')),
              _baris('Program Studi', _programStudi!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _reset();
            },
            child: const Text('Isi Ulang'),
          ),
        ],
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(nilai, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _reset() {
    _formKey.currentState!.reset();
    _namaC.clear();
    _npmC.clear();
    _emailC.clear();
    _passwordC.clear();
    setState(() {
      _jenisKelamin = null;
      _hobi.updateAll((key, value) => false);
      _programStudi = null;
      _setuju = false;
      _showGenderError = _showHobiError = _showSetujuError = false;
    });
  }

  Widget _errorText(String msg) => Padding(
        padding: const EdgeInsets.only(left: 12, top: 2, bottom: 4),
        child: Text(msg,
            style: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 12)),
      );

  Widget _judul(String teks) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text(teks,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Data Pengguna'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama lengkap
                TextFormField(
                  controller: _namaC,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // NPM
                TextFormField(
                  controller: _npmC,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'NPM',
                    hintText: 'Minimal 8 digit angka',
                    prefixIcon: Icon(Icons.badge),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'NPM wajib diisi';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                      return 'NPM hanya boleh berisi angka';
                    }
                    if (value.trim().length < 8) {
                      return 'NPM minimal 8 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'nama@email.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email wajib diisi';
                    }
                    final emailRegex =
                        RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordC,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),

                // Jenis kelamin (Radio)
                _judul('Jenis Kelamin'),
                RadioListTile<String>(
                  title: const Text('Laki-laki'),
                  value: 'Laki-laki',
                  groupValue: _jenisKelamin,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setState(() {
                    _jenisKelamin = value;
                    _showGenderError = false;
                  }),
                ),
                RadioListTile<String>(
                  title: const Text('Perempuan'),
                  value: 'Perempuan',
                  groupValue: _jenisKelamin,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setState(() {
                    _jenisKelamin = value;
                    _showGenderError = false;
                  }),
                ),
                if (_showGenderError) _errorText('Pilih jenis kelamin'),

                // Hobi (Checkbox)
                _judul('Hobi (boleh lebih dari satu)'),
                ..._hobi.keys.map(
                  (nama) => CheckboxListTile(
                    title: Text(nama),
                    value: _hobi[nama],
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) => setState(() {
                      _hobi[nama] = value!;
                      _showHobiError = false;
                    }),
                  ),
                ),
                if (_showHobiError) _errorText('Pilih minimal satu hobi'),

                // Program studi (Dropdown)
                _judul('Program Studi'),
                DropdownButtonFormField<String>(
                  initialValue: _programStudi,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(),
                  ),
                  hint: const Text('Pilih program studi'),
                  items: _programList
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) => setState(() => _programStudi = value),
                  validator: (value) =>
                      value == null ? 'Program studi wajib dipilih' : null,
                ),
                const SizedBox(height: 8),

                // Syarat dan ketentuan
                CheckboxListTile(
                  title: const Text('Saya menyetujui syarat dan ketentuan'),
                  value: _setuju,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) => setState(() {
                    _setuju = value!;
                    _showSetujuError = false;
                  }),
                ),
                if (_showSetujuError)
                  _errorText('Anda harus menyetujui syarat dan ketentuan'),
                const SizedBox(height: 16),

                // Tombol simpan
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _simpan,
                    icon: const Icon(Icons.send),
                    label: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}