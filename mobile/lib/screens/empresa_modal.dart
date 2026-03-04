import 'package:flutter/material.dart';
import '../models/projeto.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

class EmpresaModal extends StatefulWidget {
  const EmpresaModal({super.key});

  @override
  State<EmpresaModal> createState() => _EmpresaModalState();
}

class _EmpresaModalState extends State<EmpresaModal> {
  final _storage = StorageService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeCtrl;
  late TextEditingController _cnpjCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _endCtrl;

  bool _loading = true;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController();
    _cnpjCtrl = TextEditingController();
    _telCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _endCtrl = TextEditingController();
    _carregar();
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cnpjCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final empresa = await _storage.carregarEmpresa();
    if (mounted && empresa != null) {
      _nomeCtrl.text = empresa.nome;
      _cnpjCtrl.text = empresa.cnpj;
      _telCtrl.text = empresa.telefone;
      _emailCtrl.text = empresa.email;
      _endCtrl.text = empresa.endereco;
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    await _storage.salvarEmpresa(EmpresaInfo(
      nome: _nomeCtrl.text,
      cnpj: _cnpjCtrl.text,
      telefone: _telCtrl.text,
      email: _emailCtrl.text,
      endereco: _endCtrl.text,
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados da empresa salvos!'), backgroundColor: AppColors.teal),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 20,
        right: 20,
        top: 16,
      ),
      child: _loading
          ? const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.navy.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.business_outlined, color: AppColors.navy),
                        ),
                        const SizedBox(width: 12),
                        Text('Dados da Empresa', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Estas informações aparecem no cabeçalho do PDF',
                      style: TextStyle(fontSize: 12, color: AppColors.darkGray),
                    ),
                    const SizedBox(height: 20),

                    // Campos
                    TextFormField(
                      controller: _nomeCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Empresa *',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (v) => (v?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cnpjCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'CNPJ',
                        prefixIcon: Icon(Icons.numbers),
                        hintText: 'XX.XXX.XXX/XXXX-XX',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _telCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _endCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _salvando ? null : _salvar,
                        icon: _salvando
                            ? const SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(_salvando ? 'Salvando...' : 'Salvar'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
    );
  }
}
