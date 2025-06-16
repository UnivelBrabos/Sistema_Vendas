using Sistema_Vendas.Model.DashboardModel;
using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IDashboard
    {
        event EventHandler EventLoaded;

        void CarregaGraficos(GraficosModel pGraficos);

        void CarregaCards(Cards pCards);
    }
}