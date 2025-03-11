using LiveCharts;
using LiveCharts.Wpf;
using System.Windows;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;


namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private readonly ConnectionDB objConnect;

        private List<Vendedor> lstVendedores;
        private List<Vendas> lstVendas;

        public MainWindow()
        {
            InitializeComponent();

            // Inicializa a conexão junto ao sistema
            objConnect = new ConnectionDB();

            CarregaDados();
        }

        public void CarregaGrafico()
        {
            VendedoresChartControl.Series = new SeriesCollection();
            /*
            {
                new PieSeries { Title = "Slice 1", Values = new ChartValues<double> { 50 } },
                new PieSeries { Title = "Slice 2", Values = new ChartValues<double> { 30 } },
                new PieSeries { Title = "Slice 3", Values = new ChartValues<double> { 20 } },
                new PieSeries { Title = "Slice 4", Values = new ChartValues<double> { 90 } },
                new PieSeries { Title = "Slice 5", Values = new ChartValues<double> { 10 } }
            };*/

            for(int i = 0; i < lstVendedores.Count; i++)
            {
                PieSeries pieSeries = new()
                {
                    Title = lstVendedores[i].Nome,
                    Values = new ChartValues<double>
                    {
                        Convert.ToDouble(lstVendas.Where(p => p.IdVendedor == lstVendedores[i].IdVendedor)
                                 .Sum(p => p.TotalVenda))
                    }
                };

                VendedoresChartControl.Series.Add(pieSeries);
            }

            VendedoresChartControl.ChartLegend.SetValue(TopProperty, true);
        }

        public async void CarregaDados()
        {
            lstVendedores = await Vendedor.GetVendedores(objConnect);

            lstVendas = await Vendas.GetVendas(objConnect);

            for(int i =0; i < lstVendas.Count; i++)
            {
                MessageBox.Show(lstVendas[i].TotalVenda.ToString());
            }

            CarregaGrafico();
        }
    }
}