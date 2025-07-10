using LiveCharts;
using LiveCharts.Wpf;

namespace Spark.Model.DashboardModel
{
    public class GraficosModel
    {
        // Mais Vendidos
        public string[] LabelsY {  get; set; }
        public RowSeries SeriesMaisVendidos {  get; set; }

        // Paticipação Lucros
        public SeriesCollection SeriesParticipacao { get; set; }

        // Vendas Mensais
        public SeriesCollection SeriesVendas { get; set; }
        public Axis[] VendasEixos { get; set; }

        // Melhores Clientes 
        public SeriesCollection SeriesClientes { get; set; }
    }
}
