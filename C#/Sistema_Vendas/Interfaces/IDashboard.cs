using Spark.Model.DashboardModel;
using System.Windows.Controls;

namespace Spark.Interfaces
{
    public interface IDashboard
    {
        event EventHandler EventLoaded;

        void CarregaGraficos(GraficosModel pGraficos);

        void CarregaCards(Cards pCards);
    }
}