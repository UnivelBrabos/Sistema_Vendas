using System.Windows;
using System.Windows.Controls;
using Sistema_Vendas.Controller;
using Sistema_Vendas.Model.FilteredModel;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Interação lógica para DashBoardView.xam
    /// </summary>
    public partial class DashBoardView : UserControl
    {
        DashboardController GraficosController;

        public DashBoardView()
        {
            InitializeComponent();

            GraficosController = new();

            Graficos(false, null);
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
    }
}
