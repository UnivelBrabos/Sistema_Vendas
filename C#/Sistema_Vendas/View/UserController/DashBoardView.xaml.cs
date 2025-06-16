using System.Windows;
using System.Windows.Controls;
using LiveCharts.Wpf;
using Sistema_Vendas.Controller;
using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DashboardModel;
using Sistema_Vendas.Model.FilteredModel;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Interação lógica para DashBoardView.xam
    /// </summary>
    public partial class DashBoardView : UserControl, IDashboard
    {
        public event EventHandler EventLoaded;

        public DashBoardView()
        {
            InitializeComponent();

            uscDashboard.Loaded += (s, e) => EventLoaded?.Invoke(this, EventArgs.Empty);
        }

        public void CarregaCards(Cards pCards)
        {
            lblMelhorCliente.Content = pCards.MelhorCliente;
            lblTotalRecebido.Content = pCards.TotalVendido;
            lblTotalVendas.Content = pCards.TotalVendas;
        }

        public void CarregaGraficos(GraficosModel pGraficos)
        {
            CarregaVendasMensais(pGraficos);
            CarregaMelhoresVendedores(pGraficos);
            CarregaMelhoresClientes(pGraficos);
            CarregaMelhoresProdutos(pGraficos);
        }

        private void CarregaVendasMensais(GraficosModel pGraficos)
        {
            VendasMensalCharControl.AxisX.Clear();
            VendasMensalCharControl.AxisY.Clear();
            VendasMensalCharControl.Series.Clear();

            VendasMensalCharControl.AxisY.Add(new Axis
            {
                Title = "Vendas",
                LabelFormatter = value => value.ToString("N")
            });

            VendasMensalCharControl.AxisX.Add(pGraficos.VendasEixos[0]);
            VendasMensalCharControl.Series = pGraficos.SeriesVendas;
        }

        private void CarregaMelhoresVendedores(GraficosModel pGraficos)
        {
            MelhoresVendedoresChartControl.Series.Clear();
            MelhoresVendedoresChartControl.Series = pGraficos.SeriesParticipacao;
        }

        private void CarregaMelhoresClientes(GraficosModel pGraficos)
        {
            MelhoresClientesChartControl.Series.Clear();
            MelhoresClientesChartControl.Series = pGraficos.SeriesClientes;
        }

        private void CarregaMelhoresProdutos(GraficosModel pGraficos)
        {
            MelhoresProdutosCharControl.Series.Clear();
            MelhoresProdutosCharControl.AxisY.Clear();

            MelhoresProdutosCharControl.Series.Add(pGraficos.SeriesMaisVendidos);
            MelhoresProdutosCharControl.AxisY.Add(new());

            MelhoresProdutosCharControl.AxisY[0].Labels = pGraficos.LabelsY;
        }
    }
}
