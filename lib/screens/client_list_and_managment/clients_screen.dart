import 'package:flutter/material.dart';
import 'package:pontodofrango/utils/client_operations.dart';
import '../../models/client_model.dart';
import 'floating_button.dart';

class ClientScreen extends StatefulWidget {
  final Function(Client) onClientSelected;
  const ClientScreen({super.key, required this.onClientSelected});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  late Future<List<Client>> _clientsFuture;
  Client? _selectedClient;

  @override
  void initState() {
    super.initState();
    _clientsFuture = _loadClients();
  }

  Future<List<Client>> _loadClients() async {
    final fetchedClients = await fetchClients();
    fetchedClients.sort((a, b) => a.nome.compareTo(b.nome));
    return fetchedClients;
  }

  void _refreshClientList() {
    setState(() {
      _clientsFuture = _loadClients();
      _selectedClient = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Lista de Clientes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: _buildClientListView()),
          ],
        ),
      ),
      floatingActionButton: _selectedClient == null
          ? FloatingButton(refreshClientList: _refreshClientList)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildClientListView() {
    return FutureBuilder<List<Client>>(
      future: _clientsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.yellow,
            strokeWidth: 5.0,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
            'Nenhum cliente encontrado.',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ));
        } else {
          return _buildClientList(snapshot.data!);
        }
      },
    );
  }

  Widget _buildClientList(List<Client> clients) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final showHeader =
            index == 0 || clients[index].nome[0] != clients[index - 1].nome[0];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) _buildHeader(clients[index].nome[0]),
            _buildClientTile(clients[index]),
          ],
        );
      },
    );
  }

  Widget _buildHeader(String letter) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildClientTile(Client client) {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              client.nome,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              '#${client.code.toString().padLeft(3, '0')}',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      onTap: () => widget.onClientSelected(client),
    );
  }
}
