import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';

class EstadiasScreen extends StatefulWidget {
  final bool isGuest;
  const EstadiasScreen({super.key, this.isGuest = false});

  @override
  State<EstadiasScreen> createState() => _EstadiasScreenState();
}

class _EstadiasScreenState extends State<EstadiasScreen> {
  List<dynamic> _estadias = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEstadias();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEstadias({String? search}) async {
    setState(() => _loading = true);
    try {
      final data = await AuthService.getEstadias(search: search);
      setState(() {
        _estadias = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false); //Arreglar error de carga de estadías
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search a company...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF488C61)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _loadEstadias();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color(0xFF488C61),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color(0xFF488C61),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (value) => _loadEstadias(search: value),
          ),
        ),

        // Lista de estadías
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _estadias.isEmpty
              ? const Center(
                  child: Text(
                    'Not found any companies',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadEstadias(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _estadias.length,
                    itemBuilder: (context, index) {
                      final estadia = _estadias[index];
                      return EstadiaCard(estadia: estadia);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

// Widget personalizado para las Tarjetas de Empresa
class EstadiaCard extends StatelessWidget {
  final Map<String, dynamic> estadia;

  const EstadiaCard({super.key, required this.estadia});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.business, color: Colors.black, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estadia['empresa'] ?? 'Sin nombre',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      estadia['carrera'] ?? 'No career',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            estadia['giro'] ?? 'No description',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 180,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(estadia['empresa'] ?? ''),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _detailRow(Icons.work, 'Giro', estadia['giro']),
                          _detailRow(
                            Icons.person,
                            'Contacto',
                            estadia['contacto'],
                          ),
                          _detailRow(Icons.email, 'Correo', estadia['correo']),
                          _detailRow(
                            Icons.phone,
                            'Teléfono',
                            estadia['telefono'],
                          ),
                          _detailRow(
                            Icons.location_on,
                            'Dirección',
                            estadia['direccion'],
                          ),
                          _detailRow(
                            Icons.school,
                            'Carrera',
                            estadia['carrera'],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cerrar',
                            style: TextStyle(color: Color(0xFF488C61)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF488C61),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'See details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF488C61)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  value ?? 'Not available',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
