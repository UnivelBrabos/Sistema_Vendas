using System.Windows;
using System.Windows.Controls;
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

        public void CarregaGraficos()
        {
        }
    }
}
