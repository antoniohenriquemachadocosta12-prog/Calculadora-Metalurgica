import '../models/material_model.dart';

/// Base de dados com 150 materiais metálicos.
/// Dados de densidade conforme normas ABNT/ASTM/DIN.
/// Preços em R$/kg são estimativas de mercado (atualizáveis).
final List<MaterialMetal> todosMateriais = [
  // ============================================================
  // AÇO CARBONO (1-25)
  // ============================================================
  const MaterialMetal(id: 'aco_1006', nome: 'Aço Carbono SAE 1006', densidade: 7870, precoKg: 7.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1008', nome: 'Aço Carbono SAE 1008', densidade: 7870, precoKg: 7.20, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1010', nome: 'Aço Carbono SAE 1010', densidade: 7870, precoKg: 7.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1012', nome: 'Aço Carbono SAE 1012', densidade: 7870, precoKg: 7.60, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1015', nome: 'Aço Carbono SAE 1015', densidade: 7870, precoKg: 7.80, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1018', nome: 'Aço Carbono SAE 1018', densidade: 7870, precoKg: 8.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1020', nome: 'Aço Carbono SAE 1020', densidade: 7850, precoKg: 8.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1025', nome: 'Aço Carbono SAE 1025', densidade: 7850, precoKg: 8.80, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1030', nome: 'Aço Carbono SAE 1030', densidade: 7850, precoKg: 9.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1035', nome: 'Aço Carbono SAE 1035', densidade: 7850, precoKg: 9.10, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1040', nome: 'Aço Carbono SAE 1040', densidade: 7845, precoKg: 9.20, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1045', nome: 'Aço Carbono SAE 1045', densidade: 7850, precoKg: 9.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1050', nome: 'Aço Carbono SAE 1050', densidade: 7850, precoKg: 9.80, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1060', nome: 'Aço Carbono SAE 1060', densidade: 7850, precoKg: 10.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1070', nome: 'Aço Carbono SAE 1070', densidade: 7850, precoKg: 10.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1080', nome: 'Aço Carbono SAE 1080', densidade: 7850, precoKg: 11.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1090', nome: 'Aço Carbono SAE 1090', densidade: 7850, precoKg: 11.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1095', nome: 'Aço Carbono SAE 1095', densidade: 7850, precoKg: 12.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1117', nome: 'Aço Ressulfurado SAE 1117', densidade: 7870, precoKg: 8.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1137', nome: 'Aço Ressulfurado SAE 1137', densidade: 7850, precoKg: 9.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1141', nome: 'Aço Ressulfurado SAE 1141', densidade: 7850, precoKg: 9.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_1144', nome: 'Aço Ressulfurado SAE 1144', densidade: 7850, precoKg: 10.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_12l14', nome: 'Aço Corte Fácil SAE 12L14', densidade: 7870, precoKg: 11.00, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_a36', nome: 'Aço Estrutural ASTM A36', densidade: 7850, precoKg: 7.50, categoria: 'Aço Carbono'),
  const MaterialMetal(id: 'aco_a572', nome: 'Aço Estrutural ASTM A572 Gr50', densidade: 7850, precoKg: 8.50, categoria: 'Aço Carbono'),

  // ============================================================
  // AÇO LIGA (26-45)
  // ============================================================
  const MaterialMetal(id: 'aco_4130', nome: 'Aço Liga SAE 4130', densidade: 7850, precoKg: 14.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_4140', nome: 'Aço Liga SAE 4140', densidade: 7850, precoKg: 14.50, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_4340', nome: 'Aço Liga SAE 4340', densidade: 7850, precoKg: 16.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_5160', nome: 'Aço Liga SAE 5160 (mola)', densidade: 7850, precoKg: 13.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_6150', nome: 'Aço Liga SAE 6150', densidade: 7850, precoKg: 15.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_8620', nome: 'Aço Liga SAE 8620', densidade: 7850, precoKg: 13.50, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_8640', nome: 'Aço Liga SAE 8640', densidade: 7850, precoKg: 14.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_9260', nome: 'Aço Liga SAE 9260 (mola)', densidade: 7850, precoKg: 14.50, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_52100', nome: 'Aço Rolamento SAE 52100', densidade: 7830, precoKg: 18.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_300m', nome: 'Aço Liga 300M', densidade: 7890, precoKg: 25.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_maraging250', nome: 'Aço Maraging 250', densidade: 8000, precoKg: 60.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_maraging300', nome: 'Aço Maraging 300', densidade: 8000, precoKg: 70.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_mn_hadfield', nome: 'Aço Manganês Hadfield', densidade: 7800, precoKg: 15.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_crmo_p22', nome: 'Aço CrMo ASTM A335 P22', densidade: 7850, precoKg: 18.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_crmo_p91', nome: 'Aço CrMo ASTM A335 P91', densidade: 7770, precoKg: 22.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_ar400', nome: 'Aço Antidesgaste AR400', densidade: 7850, precoKg: 12.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_ar500', nome: 'Aço Antidesgaste AR500', densidade: 7850, precoKg: 14.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_domex700', nome: 'Aço Alta Resistência Domex 700', densidade: 7850, precoKg: 13.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_corten_a', nome: 'Aço Corten A (patinável)', densidade: 7850, precoKg: 10.00, categoria: 'Aço Liga'),
  const MaterialMetal(id: 'aco_corten_b', nome: 'Aço Corten B (patinável)', densidade: 7850, precoKg: 10.50, categoria: 'Aço Liga'),

  // ============================================================
  // AÇO INOXIDÁVEL (46-70)
  // ============================================================
  const MaterialMetal(id: 'inox_301', nome: 'Aço Inox AISI 301', densidade: 7880, precoKg: 25.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_302', nome: 'Aço Inox AISI 302', densidade: 7920, precoKg: 26.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_303', nome: 'Aço Inox AISI 303', densidade: 7920, precoKg: 27.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_304', nome: 'Aço Inox AISI 304', densidade: 8000, precoKg: 28.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_304l', nome: 'Aço Inox AISI 304L', densidade: 8000, precoKg: 29.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_309', nome: 'Aço Inox AISI 309', densidade: 7980, precoKg: 38.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_310', nome: 'Aço Inox AISI 310', densidade: 7980, precoKg: 42.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_316', nome: 'Aço Inox AISI 316', densidade: 8000, precoKg: 35.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_316l', nome: 'Aço Inox AISI 316L', densidade: 8000, precoKg: 36.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_317l', nome: 'Aço Inox AISI 317L', densidade: 8000, precoKg: 45.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_321', nome: 'Aço Inox AISI 321', densidade: 7920, precoKg: 40.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_347', nome: 'Aço Inox AISI 347', densidade: 7960, precoKg: 42.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_410', nome: 'Aço Inox AISI 410', densidade: 7740, precoKg: 22.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_420', nome: 'Aço Inox AISI 420', densidade: 7740, precoKg: 23.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_430', nome: 'Aço Inox AISI 430', densidade: 7700, precoKg: 20.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_439', nome: 'Aço Inox AISI 439', densidade: 7700, precoKg: 21.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_441', nome: 'Aço Inox AISI 441', densidade: 7700, precoKg: 22.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_444', nome: 'Aço Inox AISI 444', densidade: 7750, precoKg: 24.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_duplex_2205', nome: 'Aço Inox Duplex 2205', densidade: 7820, precoKg: 50.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_superduplex', nome: 'Aço Inox Super Duplex 2507', densidade: 7800, precoKg: 65.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_904l', nome: 'Aço Inox AISI 904L', densidade: 7990, precoKg: 55.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_17_4ph', nome: 'Aço Inox 17-4 PH', densidade: 7780, precoKg: 48.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_15_5ph', nome: 'Aço Inox 15-5 PH', densidade: 7780, precoKg: 50.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_201', nome: 'Aço Inox AISI 201', densidade: 7930, precoKg: 18.00, categoria: 'Aço Inoxidável'),
  const MaterialMetal(id: 'inox_202', nome: 'Aço Inox AISI 202', densidade: 7930, precoKg: 19.00, categoria: 'Aço Inoxidável'),

  // ============================================================
  // AÇO FERRAMENTA (71-85)
  // ============================================================
  const MaterialMetal(id: 'fer_d2', nome: 'Aço Ferramenta AISI D2', densidade: 7700, precoKg: 30.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_d6', nome: 'Aço Ferramenta AISI D6', densidade: 7700, precoKg: 32.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_h13', nome: 'Aço Ferramenta AISI H13', densidade: 7800, precoKg: 28.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_m2', nome: 'Aço Rápido AISI M2', densidade: 8160, precoKg: 45.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_m35', nome: 'Aço Rápido AISI M35', densidade: 8160, precoKg: 55.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_o1', nome: 'Aço Ferramenta AISI O1', densidade: 7850, precoKg: 25.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_s7', nome: 'Aço Ferramenta AISI S7', densidade: 7840, precoKg: 30.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_a2', nome: 'Aço Ferramenta AISI A2', densidade: 7860, precoKg: 28.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_w1', nome: 'Aço Ferramenta AISI W1', densidade: 7850, precoKg: 20.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_p20', nome: 'Aço Para Molde AISI P20', densidade: 7850, precoKg: 15.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_vd2', nome: 'Aço Ferramenta VD2 (Villares)', densidade: 7700, precoKg: 32.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_vc131', nome: 'Aço Ferramenta VC131 (Villares)', densidade: 7700, precoKg: 30.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_vf800', nome: 'Aço Ferramenta VF800 (Villares)', densidade: 7850, precoKg: 18.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_vh13', nome: 'Aço Ferramenta VH13 (Villares)', densidade: 7800, precoKg: 30.00, categoria: 'Aço Ferramenta'),
  const MaterialMetal(id: 'fer_vw3', nome: 'Aço Ferramenta VW3 (Villares)', densidade: 7850, precoKg: 22.00, categoria: 'Aço Ferramenta'),

  // ============================================================
  // ALUMÍNIO (86-110)
  // ============================================================
  const MaterialMetal(id: 'al_1050', nome: 'Alumínio 1050 (puro comercial)', densidade: 2710, precoKg: 18.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_1060', nome: 'Alumínio 1060', densidade: 2705, precoKg: 18.50, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_1100', nome: 'Alumínio 1100', densidade: 2710, precoKg: 19.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_2011', nome: 'Alumínio 2011 (usinagem)', densidade: 2830, precoKg: 28.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_2017', nome: 'Alumínio 2017 (Duralumínio)', densidade: 2790, precoKg: 26.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_2024', nome: 'Alumínio 2024 (aeronáutico)', densidade: 2780, precoKg: 32.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_3003', nome: 'Alumínio 3003', densidade: 2730, precoKg: 20.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_5052', nome: 'Alumínio 5052', densidade: 2680, precoKg: 22.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_5083', nome: 'Alumínio 5083 (naval)', densidade: 2660, precoKg: 25.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_5086', nome: 'Alumínio 5086', densidade: 2660, precoKg: 24.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_6005', nome: 'Alumínio 6005', densidade: 2700, precoKg: 21.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_6060', nome: 'Alumínio 6060', densidade: 2700, precoKg: 20.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_6061', nome: 'Alumínio 6061', densidade: 2700, precoKg: 22.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_6063', nome: 'Alumínio 6063', densidade: 2700, precoKg: 20.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_6082', nome: 'Alumínio 6082', densidade: 2710, precoKg: 23.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_6351', nome: 'Alumínio 6351', densidade: 2710, precoKg: 22.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_7020', nome: 'Alumínio 7020', densidade: 2780, precoKg: 28.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_7050', nome: 'Alumínio 7050', densidade: 2830, precoKg: 40.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_7075', nome: 'Alumínio 7075 (aeronáutico)', densidade: 2810, precoKg: 38.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_8011', nome: 'Alumínio 8011 (embalagem)', densidade: 2710, precoKg: 19.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_fund_a356', nome: 'Alumínio Fundido A356', densidade: 2680, precoKg: 24.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_fund_a380', nome: 'Alumínio Fundido A380', densidade: 2740, precoKg: 22.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_fund_zamac3', nome: 'Zamac 3 (Zn-Al)', densidade: 6600, precoKg: 18.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_fund_zamac5', nome: 'Zamac 5 (Zn-Al)', densidade: 6600, precoKg: 19.00, categoria: 'Alumínio'),
  const MaterialMetal(id: 'al_fund_silumin', nome: 'Silumínio (Al-Si)', densidade: 2650, precoKg: 23.00, categoria: 'Alumínio'),

  // ============================================================
  // COBRE E LIGAS (111-130)
  // ============================================================
  const MaterialMetal(id: 'cu_eletro', nome: 'Cobre Eletrolítico (C110)', densidade: 8960, precoKg: 45.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'cu_fosforoso', nome: 'Cobre Fosforoso (C510)', densidade: 8860, precoKg: 48.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'cu_berilho', nome: 'Cobre Berílio (C172)', densidade: 8260, precoKg: 85.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'cu_cromo', nome: 'Cobre Cromo (C182)', densidade: 8890, precoKg: 55.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'cu_telúrio', nome: 'Cobre Telúrio (C145)', densidade: 8940, precoKg: 50.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'latao_360', nome: 'Latão C360 (usinagem livre)', densidade: 8500, precoKg: 38.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'latao_260', nome: 'Latão C260 (cartucho)', densidade: 8530, precoKg: 35.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'latao_270', nome: 'Latão C270', densidade: 8530, precoKg: 36.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'latao_280', nome: 'Latão C280 (Muntz)', densidade: 8390, precoKg: 34.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'latao_naval', nome: 'Latão Naval C464', densidade: 8410, precoKg: 42.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'bronze_sae65', nome: 'Bronze SAE 65 (Sn)', densidade: 8800, precoKg: 55.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'bronze_sae68', nome: 'Bronze SAE 68 (Pb-Sn)', densidade: 8900, precoKg: 50.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'bronze_aluminio', nome: 'Bronze Alumínio C630', densidade: 7580, precoKg: 52.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'bronze_fosforoso', nome: 'Bronze Fosforoso C510', densidade: 8860, precoKg: 58.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'bronze_manganes', nome: 'Bronze Manganês C675', densidade: 8360, precoKg: 48.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'bronze_silicio', nome: 'Bronze Silício C655', densidade: 8530, precoKg: 50.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'cupro_niquel_70_30', nome: 'Cuproníquel 70/30 (C715)', densidade: 8940, precoKg: 60.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'cupro_niquel_90_10', nome: 'Cuproníquel 90/10 (C706)', densidade: 8940, precoKg: 55.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'alpaca', nome: 'Alpaca (Cu-Ni-Zn)', densidade: 8700, precoKg: 45.00, categoria: 'Cobre e Ligas'),
  const MaterialMetal(id: 'maillechort', nome: 'Maillechort (Prata Alemã)', densidade: 8700, precoKg: 48.00, categoria: 'Cobre e Ligas'),

  // ============================================================
  // FERRO FUNDIDO E AÇO FUNDIDO (131-140)
  // ============================================================
  const MaterialMetal(id: 'ff_cinzento_fc200', nome: 'Ferro Fundido Cinzento FC200', densidade: 7200, precoKg: 6.50, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_cinzento_fc250', nome: 'Ferro Fundido Cinzento FC250', densidade: 7200, precoKg: 7.00, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_cinzento_fc300', nome: 'Ferro Fundido Cinzento FC300', densidade: 7250, precoKg: 7.50, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_nodular_fuco_4512', nome: 'Ferro Fundido Nodular FE 45012', densidade: 7100, precoKg: 8.00, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_nodular_fuco_6002', nome: 'Ferro Fundido Nodular FE 60003', densidade: 7100, precoKg: 8.50, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_nodular_fuco_7002', nome: 'Ferro Fundido Nodular FE 70002', densidade: 7100, precoKg: 9.00, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_branco', nome: 'Ferro Fundido Branco', densidade: 7700, precoKg: 7.00, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_maleavel_preto', nome: 'Ferro Fundido Maleável Preto', densidade: 7300, precoKg: 8.50, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_maleavel_branco', nome: 'Ferro Fundido Maleável Branco', densidade: 7500, precoKg: 9.00, categoria: 'Ferro Fundido'),
  const MaterialMetal(id: 'ff_vermicular', nome: 'Ferro Fundido Vermicular (CGI)', densidade: 7100, precoKg: 10.00, categoria: 'Ferro Fundido'),

  // ============================================================
  // METAIS ESPECIAIS E OUTROS (141-150)
  // ============================================================
  const MaterialMetal(id: 'titanio_gr2', nome: 'Titânio Grau 2 (puro comercial)', densidade: 4510, precoKg: 120.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'titanio_gr5', nome: 'Titânio Grau 5 (Ti-6Al-4V)', densidade: 4430, precoKg: 150.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'niquel_200', nome: 'Níquel 200 (puro)', densidade: 8890, precoKg: 80.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'inconel_625', nome: 'Inconel 625 (Ni-Cr-Mo)', densidade: 8440, precoKg: 120.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'inconel_718', nome: 'Inconel 718', densidade: 8190, precoKg: 140.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'monel_400', nome: 'Monel 400 (Ni-Cu)', densidade: 8800, precoKg: 95.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'hastelloy_c276', nome: 'Hastelloy C276', densidade: 8890, precoKg: 160.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'estanho_puro', nome: 'Estanho Puro (Sn)', densidade: 7310, precoKg: 90.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'zinco_puro', nome: 'Zinco Puro (Zn)', densidade: 7130, precoKg: 15.00, categoria: 'Metais Especiais'),
  const MaterialMetal(id: 'chumbo_puro', nome: 'Chumbo Puro (Pb)', densidade: 11340, precoKg: 12.00, categoria: 'Metais Especiais'),
];

/// Retorna materiais agrupados por categoria
Map<String, List<MaterialMetal>> materiaisPorCategoria() {
  final map = <String, List<MaterialMetal>>{};
  for (final m in todosMateriais) {
    map.putIfAbsent(m.categoria, () => []).add(m);
  }
  return map;
}

/// Busca materiais por texto (nome ou categoria)
List<MaterialMetal> buscarMateriais(String query) {
  if (query.isEmpty) return todosMateriais;
  final q = query.toLowerCase();
  return todosMateriais
      .where((m) =>
          m.nome.toLowerCase().contains(q) ||
          m.categoria.toLowerCase().contains(q))
      .toList();
}

/// Retorna lista de todas as categorias disponíveis
List<String> categoriasDisponiveis() {
  return materiaisPorCategoria().keys.toList()..sort();
}
