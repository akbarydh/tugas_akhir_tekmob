import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tontonan_provider.dart';
import '../models/tontonan.dart';

class EditTontonanScreen extends StatefulWidget {
  final String id;

  const EditTontonanScreen({super.key, required this.id});

  @override
  State<EditTontonanScreen> createState() => _EditTontonanScreenState();
}

class _EditTontonanScreenState extends State<EditTontonanScreen> {
  bool _isLoading = true;
  bool _sudahDitonton = false;
  final _ratingController = TextEditingController();
  final _catatanController = TextEditingController();
  late Tontonan _tontonan;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final tontonanProvider = Provider.of<TontonanProvider>(context);
      tontonanProvider.cariById(widget.id).then((tontonan) {
        if (tontonan != null) {
          setState(() {
            _tontonan = tontonan;
            _sudahDitonton = tontonan.sudahDitonton;
            _ratingController.text = tontonan.ratingPribadi.toString();
            _catatanController.text = tontonan.catatanPribadi;
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _ratingController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    final inputText = _ratingController.text.trim();
    final parsedRating = double.tryParse(inputText);

    if (parsedRating == null || parsedRating < 0 || parsedRating > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating harus angka antara 0.0 sampai 10.0'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await Provider.of<TontonanProvider>(context, listen: false).updateTontonan(
      widget.id,
      sudahDitonton: _sudahDitonton,
      ratingPribadi: parsedRating,
      catatanPribadi: _catatanController.text,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Tontonan'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _tontonan.poster,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _tontonan.judul,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Divider(color: Colors.white24, height: 30),
              SwitchListTile(
                activeColor: Colors.amber,
                title: const Text(
                  'Sudah Ditonton?',
                  style: TextStyle(color: Colors.white),
                ),
                value: _sudahDitonton,
                onChanged: (val) {
                  setState(() {
                    _sudahDitonton = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Rating Pribadi (0.0–10.0):',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _ratingController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  hintText: 'Contoh: 7.5',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Catatan Pribadi:',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _catatanController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  hintText: 'Masukkan catatan pribadi...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 246, 186, 6),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _simpanPerubahan,
                icon: const Icon(Icons.save),
                label: const Text('SIMPAN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
