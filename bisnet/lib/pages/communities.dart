import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/pages/community_detail.dart';
import 'package:bisnet/L10n/app_localizations.dart';

class ComunidadesScreen extends StatefulWidget {
  const ComunidadesScreen({super.key});

  @override
  State<ComunidadesScreen> createState() => _ComunidadesScreenState();
}

class _ComunidadesScreenState extends State<ComunidadesScreen> {
  List<dynamic> _communities = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> get _visibleCommunities {
    final query = _searchQuery.toLowerCase().trim();
    if (query.isEmpty) return _communities;
    return _communities.where((community) {
      final name = (community['name'] ?? '').toString().toLowerCase();
      final description = (community['description'] ?? '').toString().toLowerCase();
      return name.contains(query) || description.contains(query);
    }).toList();
  }

  Future<void> _loadCommunities() async {
    try {
      final data = await AuthService.getCommunities();
      if (!mounted) return;
      setState(() {
        _communities = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String selectedType = 'public';

    showDialog(
      context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            scrollable: true, //permite scroll en pantallas pequeñas
            title: const Text('Nueva Comunidad'),
          content: SingleChildScrollView(
            //evita overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Tipo: '),
                    ChoiceChip(
                      label: const Text('Pública'),
                      selected: selectedType == 'public',
                      onSelected: (_) =>
                          setDialogState(() => selectedType = 'public'),
                      selectedColor: const Color(0xFF488C61),
                      labelStyle: TextStyle(
                        color: selectedType == 'public'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    ChoiceChip(
                      label: const Text('Privada'),
                      selected: selectedType == 'private',
                      onSelected: (_) =>
                          setDialogState(() => selectedType = 'private'),
                      selectedColor: const Color(0xFF488C61),
                      labelStyle: TextStyle(
                        color: selectedType == 'private'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                //debug para ver qué tiene el campo
                debugPrint('Nombre: ${nameController.text}');
                debugPrint('Tipo: $selectedType');

                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El nombre es obligatorio')),
                  );
                  return;
                }

                Navigator.pop(context); // cierra el dialog

                try {
                  final response = await AuthService.createCommunity(
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    type: selectedType,
                  );
                  debugPrint('Respuesta: $response');

                  if (!mounted) return;
                  _loadCommunities(); // recarga la lista
                } catch (e) {
                  debugPrint('Error: $e');
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF488C61),
              ),
              child: const Text('Crear', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        title: const Text(
          'Comunidades',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showCreateDialog,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) =>
                        setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF488C61),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
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
                  ),
                ),
                Expanded(
                  child: _visibleCommunities.isEmpty
                      ? Center(
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? AppLocalizations.of(context)!
                                    .noCommunitiesResults
                                : 'No hay comunidades aún',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadCommunities,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _visibleCommunities.length,
                            itemBuilder: (context, index) {
                              final community =
                                  _visibleCommunities[index];
                              return CommunityCard(
                                community: community,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CommunityDetailScreen(
                                              community: community),
                                    ),
                                  );
                                  _loadCommunities();
                                },
                                onJoin: () async {
                                  await AuthService.joinCommunity(
                                      community['id']);
                                  _loadCommunities();
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

// =========================================================================
// WIDGET: TARJETA DE COMUNIDAD
// =========================================================================
class CommunityCard extends StatelessWidget {
  final Map<String, dynamic> community;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  const CommunityCard({
    super.key,
    required this.community,
    required this.onTap,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final isMember = community['is_member'] == true;
    final isPrivate = community['type'] == 'private';

    return GestureDetector(
      onTap: isMember ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF488C61),
              child: community['image'] != null
                  ? ClipOval(
                      child: Image.network(
                        '${AuthService.storageUrl}/${community['image']}',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.group, color: Colors.white),
                      ),
                    )
                  : const Icon(Icons.group, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          community['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        isPrivate ? Icons.lock : Icons.lock_open,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Text(
                    community['description'] ?? '',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${community['approved_members_count'] ?? 0} miembros',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (!isMember)
              ElevatedButton(
                onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF488C61),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  isPrivate ? 'Solicitar' : 'Unirse',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            else
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
