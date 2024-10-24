import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pontodofrango/utils/client_operations.dart';
import 'package:pontodofrango/utils/showCustomOverlay.dart';
import '../../models/client_model.dart';

class ClientManagerDialogs extends StatefulWidget {
  final VoidCallback onClientChanged;

  const ClientManagerDialogs({super.key, required this.onClientChanged});

  @override
  ClientManagerDialogsState createState() => ClientManagerDialogsState();
}

class ClientManagerDialogsState extends State<ClientManagerDialogs> {
  String _dialogState = 'initial';
  String _searchText = '';
  String? _phoneErrorMessage, _nameErrorMessage, _addressErrorMessage;
  int _selectedClientCode = 0;
  List<Client> _filteredClients = [];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController _addressController = TextEditingController();

  bool _isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegExp = RegExp(r'^\(\d{2}\) \d{5}-\d{4}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  void _setDialogState(String state) {
    setState(() {
      _dialogState = state;
    });
  }

  Future<void> _handleAddClient() async {
    String name = _nameController.text;
    String phoneNumber = _phoneController.text;
    String address = _addressController.text;

    if (_validateInputs(name, phoneNumber, address)) {
      await addClient(name, phoneNumber, address);
      if (!mounted) return; // Check if the widget is still mounted
      widget.onClientChanged();
      Navigator.of(context).pop();
      showCustomOverlay(context, 'Cliente Adicionado!');
    }
  }

  Future<void> _handleRemoveClient() async {
    if (_selectedClientCode != 0) {
      await removeClient(_selectedClientCode);
      if (!mounted) return; // Check if the widget is still mounted
      widget.onClientChanged();
      Navigator.of(context).pop();
      showCustomOverlay(context, 'Cliente Removido!');
    }
  }

  Future<void> _handleSearch() async {
    List<Client> allClients = await fetchClients();
    setState(() {
      _filteredClients = allClients
          .where((client) =>
              client.nome.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    });
  }

  bool _validateInputs(String name, String phoneNumber, String address) {
    bool isValid = true;

    setState(() {
      _nameErrorMessage = name.isEmpty ? 'Nome não pode estar vazio' : null;
      _phoneErrorMessage = !_isValidPhoneNumber(phoneNumber)
          ? 'Número Incorreto. Tente novamente'
          : null;
      _addressErrorMessage =
          address.isEmpty ? 'Endereço não pode estar vazio' : null;
    });

    isValid = _nameErrorMessage == null &&
        _phoneErrorMessage == null &&
        _addressErrorMessage == null;

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.88),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: double.maxFinite,
          child: _dialogState == 'add'
              ? _buildAddDialog()
              : _dialogState == 'remove'
                  ? _buildRemoveDialog()
                  : _buildInitialDialog(),
        ),
      ),
    );
  }

  Widget _buildAddDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDialogHeader('Adicionar Cliente'),
        _buildTextField(
            _nameController, 'Nome do Cliente', _nameErrorMessage, 20),
        _buildTextField(_phoneController, 'Nº de Celular', _phoneErrorMessage,
            null, TextInputType.phone),
        _buildTextField(
            _addressController, 'Endereço', _addressErrorMessage, 50),
        SizedBox(height: 10),
        _buildActionButton('Concluir', _handleAddClient),
      ],
    );
  }

  Widget _buildRemoveDialog() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDialogHeader('Remover Cliente'),
        _buildSearchField(),
        SizedBox(height: 10),
        if (_filteredClients.isNotEmpty) _buildClientList(),
        SizedBox(height: 10),
        _buildActionButton('Concluir', _handleRemoveClient),
      ],
    );
  }

  Widget _buildInitialDialog() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogButton('Adicionar Cliente', () => _setDialogState('add')),
          SizedBox(height: 25),
          _buildDialogButton(
              'Remover Cliente', () => _setDialogState('remove')),
        ],
      ),
    );
  }

  Widget _buildDialogHeader(String title) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _setDialogState('initial'),
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, String? errorMessage,
      [int? textSizeLimit, TextInputType? keyboardType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          inputFormatters: [LengthLimitingTextInputFormatter(textSizeLimit)],
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(errorMessage, style: TextStyle(color: Colors.red)),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchText = value),
      decoration: InputDecoration(
        hintText: 'Pesquisar Cliente',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: _buildSearchButton(),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: IconButton(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          iconColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
        ),
        icon: Icon(Icons.search),
        onPressed: _handleSearch,
      ),
    );
  }

  Widget _buildClientList() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        itemCount: _filteredClients.length,
        itemBuilder: (context, index) =>
            _buildClientListItem(_filteredClients[index]),
      ),
    );
  }

  Widget _buildClientListItem(Client client) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: () => setState(() => _selectedClientCode = client.code),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _selectedClientCode == client.code
                ? Colors.yellow
                : Colors.grey[700],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            client.nome,
            style: TextStyle(
              color: _selectedClientCode == client.code
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: TextStyle(color: Colors.black, fontSize: 16)),
    );
  }

  Widget _buildDialogButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(250, 50),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: TextStyle(color: Colors.black, fontSize: 18)),
    );
  }
}