import React, { useState } from 'react';
import { SplashScreen } from './SplashScreen';
import { ProfileMenu } from './ProfileMenu';
import { MeasurementForm } from './MeasurementForm';
import { ProjectList } from './ProjectList';
import { EmpresaModal } from './EmpresaModal';
import { Projeto, EmpresaInfo, ClienteInfo } from '@/types/projeto';
import { gerarPDF } from '@/utils/pdfGenerator';

type Screen = 'splash' | 'menu' | 'form' | 'list';

export const MetalCalcPro: React.FC = () => {
  const [screen, setScreen] = useState<Screen>('splash');
  const [perfil, setPerfil] = useState<string | null>(null);
  const [projetos, setProjetos] = useState<Projeto[]>([]);
  const [empresa, setEmpresa] = useState<EmpresaInfo>({ nome: '', cnpj: '' });
  const [cliente, setCliente] = useState<ClienteInfo>({ nome: '', telefone: '', obs: '' });
  const [showEmpresa, setShowEmpresa] = useState(false);

  const addProjeto = (p: Projeto) => {
    setProjetos([...projetos, p]);
  };

  const delProjeto = (id: number) => {
    setProjetos(projetos.filter(p => p.id !== id));
  };

  const handleGerarPDF = () => {
    gerarPDF(projetos, empresa, cliente);
    setShowEmpresa(false);
  };

  return (
    <div className="min-h-screen">
      {screen === 'splash' && <SplashScreen onStart={() => setScreen('menu')} />}
      
      {screen === 'menu' && (
        <ProfileMenu
          onSelect={(k) => { setPerfil(k); setScreen('form'); }}
          onViewList={() => setScreen('list')}
          onBack={() => setScreen('splash')}
          projetosCount={projetos.length}
        />
      )}
      
      {screen === 'form' && perfil && (
        <MeasurementForm
          tipoPerfil={perfil}
          onBack={() => setScreen('menu')}
          onAddToList={addProjeto}
          onViewList={() => setScreen('list')}
          projetosCount={projetos.length}
        />
      )}
      
      {screen === 'list' && (
        <ProjectList
          projetos={projetos}
          onBack={() => setScreen('menu')}
          onDelete={delProjeto}
          onPDF={() => setShowEmpresa(true)}
        />
      )}

      {showEmpresa && (
        <EmpresaModal
          empresa={empresa}
          cliente={cliente}
          onEmpresaChange={setEmpresa}
          onClienteChange={setCliente}
          onConfirm={handleGerarPDF}
          onClose={() => setShowEmpresa(false)}
        />
      )}
    </div>
  );
};
