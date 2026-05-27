import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _mediaFile;
  bool _isVideo = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  Future<void> _pickMedia(ImageSource source, bool isVideo) async {
    final XFile? file = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);

    if (file != null) {
      setState(() {
        _mediaFile = File(file.path);
        _isVideo = isVideo;
      });
    }
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería - Imagen'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Galería - Video'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.gallery, true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara - Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera, false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Cámara - Video'),
              onTap: () {
                Navigator.pop(context);
                _pickMedia(ImageSource.camera, true);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Área de imagen/video
          GestureDetector(
            onTap: _showMediaOptions,
            child: Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: _mediaFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _isVideo
                          ? const Center(
                              child: Icon(
                                Icons.videocam,
                                size: 64,
                                color: Colors.grey,
                              ),
                            )
                          : Image.file(_mediaFile!, fit: BoxFit.cover),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Toca para agregar imagen o video',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Descripción
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Escribe una descripción...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tags
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              hintText: '#tags separados por espacio',
              prefixIcon: const Icon(Icons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botón publicar
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: enviar al backend
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B962D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Publicar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
