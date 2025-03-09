using System.Windows;
using OxyPlot;
using OxyPlot.Series;


namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            CarregaGrafico();
        }

        public void CarregaGrafico()
        {
            PlotModel Plot = new PlotModel { Title = "Testes" };

            var series = new PieSeries
            {
                Title = "Teste",
                StrokeThickness = 0
            };

            // Adicionando fatias.
            series.Slices.Add(new PieSlice("Slice 1", 50));
            series.Slices.Add(new PieSlice("Slice 2", 30));
            series.Slices.Add(new PieSlice("Slice 3", 20));
            series.Slices.Add(new PieSlice("Slice 4", 90));
            series.Slices.Add(new PieSlice("Slice 5", 10));

            Plot.Series.Add(series);

            Pizza.Model = Plot;
        }
    }
}