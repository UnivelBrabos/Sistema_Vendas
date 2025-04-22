using Sistema_Vendas.Controller;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Shapes;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Lógica interna para MenuPrincipal.xaml
    /// </summary>
    public partial class MenuPrincipal : Window
    {
        #region << Atributos >>

        public Usuarios UsuarioLogado;

        public List<ItensVenda> lstItensVenda;
        public List<Vendedor> lstVendedores;
        public List<Produto> lstProdutos;
        public List<Cliente> lstClientes;
        public List<Vendas> lstVendas;

        ConnectionDB objConnection;

        DashboardController GraficosController;

        #endregion << Atributos >>

        public MenuPrincipal(Usuarios pUsuario)
        {
            InitializeComponent();

            UsuarioLogado = pUsuario;

            // Banco de dados
            DataContext = this;
            objConnection = new ConnectionDB();

            GraficosController = new(this);

            // Miscellaneous
            CarregaDados();
        }

        #region << Métodos >>

        /// <summary>
        /// Usado para alterar dinâmicamente um botão, e os demais, quando ele é clicado
        /// </summary>
        /// <param name="botaoSelecionado">Botão que vai ser alterado</param>
        /// <param name="retanguloSelecionado">Retangulo que vai ser alterado</param>
        private void DestacarBotao(Button botaoSelecionado, Rectangle retanguloSelecionado = null)
        {
            Button[] botoes = { btnDashboard, btnAuditoria, btnFuncionarios, btnEstoque, btnConfiguracoes, btnUsuario, btnFiltrar };


            foreach (var btn in botoes)
            {
                btn.Opacity = 0;
            }

            Rectangle[] retangulos = { retDashboard, retAuditoria, retFuncionarios, retEstoque };

            foreach (var ret in retangulos)
            {
                ret.Visibility = Visibility.Hidden;
            }

            if (retanguloSelecionado != null)
            {
                retanguloSelecionado.Visibility = Visibility.Visible;
            }

            botaoSelecionado.Opacity = 0.1;
        }

        private void ExibeGrid(Grid gridAMostrar)
        {
            Grid[] Grids = { grdContDashboard };

            for (int i = 0; i < Grids.Length; i++)
            {
                Grids[i].Visibility = Visibility.Hidden;
            }

            gridAMostrar.Visibility = Visibility.Visible;
        }

        public async void CarregaDados()
        {
            lblNomeUsuario.Content = UsuarioLogado.NomeUsuario; 

            lstVendedores = await Vendedor.GetVendedores(objConnection);

            lstVendas = await Vendas.GetVendas(objConnection);

            lstProdutos = await Produto.GetProdutos(objConnection);

            lstClientes = await Cliente.GetClientes(objConnection);

            lstItensVenda = await ItensVenda.GetItensVenda(objConnection);

            //CarregaCheckBox();
        }

        public void CarregaGrafico(bool filtrar = false)
        {
            List<int> lstVendedoresId = new();
            List<int> lstClientesId = new();

            /*if (ItemscCheckBox != null)
            {
                lstVendedoresId = ItemscCheckBox
                    .Where(v => v.IsSelected)
                    .Select(v => v.Id)
                    .ToList();
            }

            if (ItemsClientesCheckBox != null)
            {
                lstClientesId = ItemsClientesCheckBox
                    .Where(v => v.IsSelected)
                    .Select(v => v.Id)
                    .ToList();
            }*/

            Filtros objFiltros = new(Convert.ToDateTime("01/01/2025"), Convert.ToDateTime("08/04/2025"), lstVendedoresId, lstClientesId);

            Graficos(filtrar, objFiltros);
        }

        public void Graficos(bool pFiltrar, Filtros pFiltros)
        {
            string strMensagem;

            if (!GraficosController.MaisVendidos(ref ProdutosCharControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.ParticipacaoLucros(ref VendedoresChartControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.VendasMensais(ref VendasCharControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.MelhoresClientes(ref ClientesChartControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.CarregaCards(pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }
        }

        public void CarregaDataVendas()
        {
            dgvAuxiliar.ItemsSource = lstVendas;
            lblAuxiliar.Content = "Vendas"; 
            AdicionaColunaAuxiliar("Vendas");
        }

        public void AdicionaColunaAuxiliar(string pDgvAtivo)
        {
            DataGridTextColumn colAuxiliar = new();

            colAuxiliar.Header = "DataGridAtivo";

            dgvAuxiliar.Columns.Add(colAuxiliar);

            dgvAuxiliar.Columns[-1].
        }

        #endregion << Métodos >>

        #region << Eventos >>
        private void btnDashboard_Click(object sender, RoutedEventArgs e)
        {
            if (grdContDashboard.Visibility == Visibility.Hidden)
            {
                DestacarBotao(btnDashboard, retDashboard);
                ExibeGrid(grdContDashboard);
                CarregaGrafico();
            }
        }

        private void btnAuditoria_Click(object sender, RoutedEventArgs e)
        {
            if (grdContAuditoria.Visibility == Visibility.Hidden)
            {
                DestacarBotao(btnAuditoria, retAuditoria);
                ExibeGrid(grdContAuditoria);
                CarregaDataVendas();
            }
        }

        private void btnFuncionarios_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnFuncionarios, retFuncionarios);
        }

        private void btnEstoque_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnEstoque, retEstoque);
        }

        private void btnConfiguracoes_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnConfiguracoes);
        }

        private void btnUsuario_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnUsuario);
        }

        private void btnFiltrar_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnFiltrar);
        }

        #endregion << Eventos >>

        private void dgvDadosVendas_Selected(object sender, RoutedEventArgs e)
        {
            /*Vendas objVendaSelecionada = (Vendas)dgvDadosVendas.SelectedItem[0];

            lblVenda.Content = $"Venda #{dgvDadosVendas.SelectedItem}";*/
        }

        private void txtIdVenda_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }
    }
}
