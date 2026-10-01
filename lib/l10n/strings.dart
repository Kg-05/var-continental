// lib/l10n/strings.dart
// Traduções Português/Inglês — só estes dois idiomas têm texto real; os
// restantes listados em Definições > Idioma caem para Português (ver
// AppStrings.t) até serem adicionados aqui.
import '../services/locale_service.dart';

const Map<String, Map<String, String>> _traducoes = {
  // ── Navegação (barra inferior) ──────────────────────────────
  'nav.inicio':    {'pt': 'Início',    'en': 'Home'},
  'nav.dashboard': {'pt': 'Dashboard', 'en': 'Dashboard'},
  'nav.alertas':   {'pt': 'Alertas',   'en': 'Alerts'},
  'nav.perfil':    {'pt': 'Perfil',    'en': 'Profile'},

  // ── Início ───────────────────────────────────────────────────
  'home.alertasRecentes':  {'pt': 'Alertas recentes', 'en': 'Recent alerts'},
  'home.pesquisar':        {'pt': 'Pesquisar equipamento ou alerta...', 'en': 'Search equipment or alert...'},
  'home.chip.todos':       {'pt': 'Todos', 'en': 'All'},
  'home.chip.criticos':    {'pt': 'Críticos', 'en': 'Critical'},
  'home.chip.naoLidos':    {'pt': 'Não lidos', 'en': 'Unread'},
  'home.semAlertas':       {'pt': 'Sem alertas recentes', 'en': 'No recent alerts'},
  'home.nenhumEncontrado': {'pt': 'Nenhum alerta encontrado', 'en': 'No alerts found'},
  'home.equipamentosOperacionais': {'pt': 'Equipamentos\nOperacionais', 'en': 'Operational\nEquipment'},
  'home.operacional':      {'pt': 'operacional', 'en': 'operational'},
  'home.hoje':             {'pt': 'Hoje', 'en': 'Today'},
  'home.alertasCriticos':  {'pt': 'Alertas\nCríticos', 'en': 'Critical\nAlerts'},
  'home.alertasNaoLidos':  {'pt': 'Alertas\nNão Lidos', 'en': 'Unread\nAlerts'},

  // ── Dashboard ────────────────────────────────────────────────
  'dashboard.titulo':             {'pt': 'Dashboard', 'en': 'Dashboard'},
  'dashboard.totalEquipamentos':  {'pt': 'Total de Equipamentos\nMonitorados', 'en': 'Total Monitored\nEquipment'},
  'dashboard.comAlertas':         {'pt': 'Equipamentos com\nAlertas por Resolver', 'en': 'Equipment with\nUnresolved Alerts'},
  'dashboard.alertasCriticos':    {'pt': 'Alertas\nCríticos', 'en': 'Critical\nAlerts'},
  'dashboard.alertasNaoLidos':    {'pt': 'Alertas\nNão Lidos', 'en': 'Unread\nAlerts'},
  'dashboard.emManutencao':       {'pt': 'Equipamentos\nem Manutenção', 'en': 'Equipment\nunder Maintenance'},
  'dashboard.distribuicaoEstado': {'pt': 'Distribuição\npor Estado', 'en': 'Distribution\nby Status'},
  'dashboard.operacional':        {'pt': 'Operacional', 'en': 'Operational'},
  'dashboard.manutencao':         {'pt': 'Manutenção', 'en': 'Maintenance'},

  // ── Alertas ──────────────────────────────────────────────────
  'alertas.titulo':     {'pt': 'Alertas', 'en': 'Alerts'},
  'alertas.pesquisar':  {'pt': 'Pesquisar alertas...', 'en': 'Search alerts...'},
  'alertas.nenhum':     {'pt': 'Nenhum alerta encontrado', 'en': 'No alerts found'},
  'alertas.tentarNovamente': {'pt': 'Tentar novamente', 'en': 'Try again'},

  // ── Definições ───────────────────────────────────────────────
  'definicoes.titulo':        {'pt': 'Definições', 'en': 'Settings'},
  'definicoes.secaoAlertas':  {'pt': 'ALERTAS', 'en': 'ALERTS'},
  'definicoes.secaoFiltro':   {'pt': 'FILTRO DE ALERTA', 'en': 'ALERT FILTER'},
  'definicoes.secaoConta':    {'pt': 'CONTA', 'en': 'ACCOUNT'},
  'definicoes.receberAlertas':    {'pt': 'Receber Alertas', 'en': 'Receive Alerts'},
  'definicoes.somAlerta':         {'pt': 'Som de alerta', 'en': 'Alert sound'},
  'definicoes.frequencia':        {'pt': 'Frequência de Atualização', 'en': 'Update Frequency'},
  'definicoes.tipoMaterial':      {'pt': 'Tipo de Material', 'en': 'Material Type'},
  'definicoes.localizacao':       {'pt': 'Localização do Equipamento', 'en': 'Equipment Location'},
  'definicoes.perfilUtilizador':  {'pt': 'Perfil do Utilizador', 'en': 'User Profile'},
  'definicoes.seguranca':         {'pt': 'Segurança', 'en': 'Security'},

  // ── Login ────────────────────────────────────────────────────
  'login.bemVindo':   {'pt': 'Bem-vindo', 'en': 'Welcome'},
  'login.subtitulo':  {'pt': 'Entra com o teu email de técnico', 'en': 'Sign in with your technician email'},
  'login.emailHint':  {'pt': 'Digite o teu email', 'en': 'Enter your email'},
  'login.senhaHint':  {'pt': 'Digite a tua senha', 'en': 'Enter your password'},
  'login.entrar':     {'pt': 'Entrar', 'en': 'Log in'},
  'login.camposObrigatorios': {'pt': 'Preencha todos os campos!', 'en': 'Fill in all fields!'},
  'login.boasVindas': {'pt': '👋 Bem-vindo ao sistema!', 'en': '👋 Welcome to the system!'},
  'login.erroGenerico': {'pt': 'Não foi possível iniciar sessão. Tenta novamente.', 'en': 'Could not sign in. Please try again.'},
};

class AppStrings {
  AppStrings._();

  static String t(String chave) {
    final codigo = idiomasTraduzidos.contains(LocaleController.instance.codigo)
        ? LocaleController.instance.codigo
        : 'pt';
    return _traducoes[chave]?[codigo] ?? _traducoes[chave]?['pt'] ?? chave;
  }
}
