using Sistema_Vendas.Controller;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Shapes;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Lógica interna para MenuPrincipal.xaml
    /// </summary>
    public partial class MenuPrincipal : Window
    {
        #region << Atributos >>

        public List<ItensVenda> lstItensVenda;
        public List<Vendedor> lstVendedores;
        public List<Produto> lstProdutos;
        public List<Cliente> lstClientes;
        public List<Vendas> lstVendas;

        ConnectionDB objConnection;

        GraficosController GraficosController;

        #endregion << Atributos >>

        public MenuPrincipal()
        {
            InitializeComponent();

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

        public async void CarregaDados()
        {
            lstVendedores = await Vendedor.GetVendedores(objConnection);

            lstVendas = await Vendas.GetVendas(objConnection);

            lstProdutos = await Produto.GetProdutos(objConnection);

            lstClientes = await Cliente.GetClientes(objConnection);

            lstItensVenda = await ItensVenda.GetItensVenda(objConnection);

            CarregaGrafico();

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

            /*if (!GraficosController.MaisVendidos(ref ProdutosCharControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }*/

            if (!GraficosController.ParticipacaoLucros(ref VendedoresChartControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.VendasMensais(ref VendasCharControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            /*if (!GraficosController.MelhoresClientes(ref ClientesChartControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }*/
        }

        #endregion << Métodos >>

        #region << Eventos >>
        private void btnDashboard_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnDashboard, retDashboard);
        }

        private void btnAuditoria_Click(object sender, RoutedEventArgs e)
        {
            DestacarBotao(btnAuditoria, retAuditoria);
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
    }
}
