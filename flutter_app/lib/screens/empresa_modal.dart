import 'package:flutter/material.dart';
import '../models/projeto_model.dart';

class EmpresaModal extends StatefulWidget {
  final EmpresaInfo empresa;
  final ClienteInfo cliente;

  const EmpresaModal({
    super.key,
    required this.empresa,
    required this.cliente,
  });

  @override
  State<EmpresaModal> createState() => _EmpresaModalState();
}

class _EmpresaModalState extends State<EmpresaModal> {
  late final TextEditingController _empresaNome;
  late final TextEditingController _empresaCnpj;
  late final TextEditingController _clienteNome;
  late final TextEditingController _clienteTel;
  late final TextEditingController _clienteObs;

  @override
  void initState() {
    super.initState();
    _empresaNome = TextEditingController(text: widget.empresa.nome);
    _empresaCnpj = TextEditingController(text: widget.empresa.cnpj);
    _clienteNome = TextEditingController(text: widget.cliente.nome);
    _clienteTel = TextEditingController(text: widget.cliente.telefone);
    _clienteObs = TextEditingController(text: widget.cliente.obs);
  }

  @override
  void dispose() {
    _empresaNome.dispose();
    _empresaCnpj.dispose();
    _clienteNome.dispose();
    _clienteTel.dispose();
    _clienteObs.dispose();
    super.dispose();
  }

  void _confirmar() {
    widget.empresa.nome = _empresaNome.text;
    widget.empresa.cnpj = _empresaCnpj.text;
    widget.cliente.nome = _clienteNome.text;
    widget.cliente.telefone = _clienteTel.text;
    widget.cliente.obs = _clienteObs.text;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Dados para o PDF'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EMPRESA (opcional)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _empresaNome,
              decoration: const InputDecoration(
                labelText: 'Nome da Empresa',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _empresaCnpj,
              decoration: const InputDecoration(
                labelText: 'CNPJ',
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CLIENTE (opcional)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _clienteNome,
              decoration: const InputDecoration(
                labelText: 'Nome do Cliente',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _clienteTel,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                isDense: true,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _clienteObs,
              decoration: const InputDecoration(
                labelText: 'Observações',
                isDense: true,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _confirmar,
          child: const Text('Gerar PDF'),
        ),
      ],
    );
  }
}
