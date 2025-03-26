using LiveCharts;
using LiveCharts.Wpf;
using Sistema_Vendas.Controller;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;


namespace Sistema_Vendas
{
    public partial class MainWindow : Window
    {
        private readonly ConnectionDB objConnect;

        private GraficosController GraficosController;

        public List<ItensVenda> lstItensVenda;
        public List<Vendedor> lstVendedores;
        public List<Produto> lstProdutos;
        public List<Cliente> lstClientes;
        public List<Vendas> lstVendas;

        public MainWindow()
        {
            InitializeComponent();
            objConnect = new ConnectionDB(); // Inicializa a conexão junto ao sistema

            CarregaDados();

            dtpFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            dtpInicial.Text = "01/01/2025";

            GraficosController = new(this);
        }

        public async void CarregaDados()
        {
            lstVendedores = await Vendedor.GetVendedores(objConnect);

            lstVendas = await Vendas.GetVendas(objConnect);

            lstProdutos = await Produto.GetProdutos(objConnect);

            lstClientes = await Cliente.GetClientes(objConnect);

            lstItensVenda = await ItensVenda.GetItensVenda(objConnect);

            CarregaGrafico();

            CarregaVendedoresComboBox();
        }

        #region :: Carregamento dos gráficos ::
        public void CarregaGrafico(bool filtrar = false, Filtros pFiltros = null)
        {
            List<int> lstVendedoresId = lstVendedores.Select(p => p.IdVendedor).ToList();
            List<int> lstClientesId = lstClientes.Select(p => p.IdCliente).ToList();

            pFiltros = new(Convert.ToDateTime(dtpInicial.Text), Convert.ToDateTime(dtpFinal.Text), lstVendedoresId, lstClientesId);

            GraficoPartLucro(filtrar, pFiltros);

            GraficoVendasMes(filtrar, pFiltros);

            GraficoClientes(filtrar, pFiltros);

            GraficoProdVendas(filtrar, pFiltros);
        }

        public void GraficoProdVendas(bool pFiltrar, Filtros pFiltros)
        {
            if(!GraficosController.MaisVendidos(ref ProdutosCharControl, pFiltrar, pFiltros, out string strRetorno))
            {
                MessageBox.Show(strRetorno);
            }
        }

        public void GraficoPartLucro(bool pFiltrar, Filtros pFiltros)
        {
            if(!GraficosController.ParticipacaoLucros(ref VendedoresChartControl, pFiltrar, pFiltros, out string strMensagem))
            {
                MessageBox.Show(strMensagem);
            }
        }

        public void GraficoVendasMes(bool filtrar, Filtros pFiltros)
        {
            try
            {
                // Limpa os dados anteriores do gráfico
                VendasCharControl.Series.Clear();
                VendasCharControl.AxisX.Clear();
                VendasCharControl.AxisY.Clear();

                // Cria a série de colunas
                ColumnSeries columnSeries = new ColumnSeries()
                {
                    Title = "Total Vendas por mês",
                    Values = new ChartValues<double>() // Usa double em vez de decimal
                };

                // Cria o eixo X dinamicamente
                Axis EixoX = new Axis()
                {
                    Title = "Meses",
                    Labels = new List<string>(), // Correção do tipo correto
                    VerticalAlignment = VerticalAlignment.Center
                };

                // Define o eixo Y
                VendasCharControl.AxisY.Add(new Axis
                {
                    Title = "Vendas",
                    LabelFormatter = value => value.ToString("N")
                });


                if (!filtrar)
                {
                    var lstVendasOrg = lstVendas
                        .GroupBy(p => new { p.DataVenda.Year, p.DataVenda.Month })
                        .Select(g => new VendasMensais
                        {
                            Ano = g.Key.Year,
                            MesNumero = g.Key.Month,
                            MesNome = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(g.Key.Month),
                            Total = (double)g.Sum(v => v.TotalVenda)
                        })
                        .OrderBy(g => g.Ano)
                        .ThenBy(g => g.MesNumero)
                        .ToList();

                    // Preenchendo os valores no gráfico
                    foreach (var venda in lstVendasOrg)
                    {
                        columnSeries.Values.Add(venda.Total);
                        EixoX.Labels.Add(venda.MesNome);
                    }
                }
                else
                {
                    var lstVendasOrg = lstVendas
                        .Where(d => (d.DataVenda >= Convert.ToDateTime(dtpInicial.Text) && (d.DataVenda <= Convert.ToDateTime(dtpFinal.Text))))
                        .GroupBy(p => new { p.DataVenda.Year, p.DataVenda.Month })
                        .Select(g => new VendasMensais
                        {
                            Ano = g.Key.Year,
                            MesNumero = g.Key.Month,
                            MesNome = CultureInfo.CurrentCulture.DateTimeFormat.GetMonthName(g.Key.Month),
                            Total = (double)g.Sum(v => v.TotalVenda)
                        })
                        .OrderBy(g => g.Ano)
                        .ThenBy(g => g.MesNumero)
                        .ToList();

                    foreach (var venda in lstVendasOrg)
                    {
                        columnSeries.Values.Add(venda.Total);
                        EixoX.Labels.Add(venda.MesNome);
                    }
                }

                // Adiciona os eixos e séries ao gráfico
                VendasCharControl.AxisX.Add(EixoX);
                VendasCharControl.Series.Add(columnSeries);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro durante cálculo das vendas por mês: {ex.Message}");
            }
        }

        public void GraficoClientes(bool filtrar, Filtros pFiltros)
        {
            try
            {
                ClientesChartControl.Series = new SeriesCollection();

                // Essa lista é um Inner join de Vendas com Cliente. Para pegar o total que cada cliente comprou
                if (!filtrar)
                {
                    var lstFiltrada = lstClientes.GroupJoin(
                                            lstVendas,
                                            c => c.IdCliente,
                                            v => v.IdCliente,
                                            (c, v) => new
                                            {
                                                Nome = c.Nome,
                                                Total = v.Sum(t => t.TotalVenda)
                                            });

                    foreach (var item in lstFiltrada)
                    {
                        PieSeries pieSeries = new()
                        {
                            Title = item.Nome,
                            Values = new ChartValues<double>
                        {
                            Convert.ToDouble(item.Total)
                        }
                        };

                        ClientesChartControl.Series.Add(pieSeries);
                    }
                }
                else
                {
                    var lstFiltrada = lstClientes.GroupJoin(
                                            lstVendas.Where(d => (d.DataVenda >= Convert.ToDateTime(dtpInicial.Text) && (d.DataVenda <= Convert.ToDateTime(dtpFinal.Text)))),
                                            c => c.IdCliente,
                                            v => v.IdCliente,
                                            (c, v) => new
                                            {
                                                Nome = c.Nome,
                                                Total = v.Sum(t => t.TotalVenda)
                                            });

                    foreach (var item in lstFiltrada)
                    {
                        PieSeries pieSeries = new()
                        {
                            Title = item.Nome,
                            Values = new ChartValues<double>
                        {
                            Convert.ToDouble(item.Total)
                        }
                        };

                        ClientesChartControl.Series.Add(pieSeries);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro durante calculo de participação de lucros: {ex.Message}");
            }
        }

        #endregion :: Carregamento dos gráficos ::

        #region :: Eventos ::

        private void btnFiltrar_Click(object sender, RoutedEventArgs e)
        {
            CarregaGrafico(true);
        }

        private void btnLimpar_Click(object sender, RoutedEventArgs e)
        {
            CarregaGrafico();
            dtpInicial.Text = "01/01/2025";
            dtpFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        }

        private void dtpInicial_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            dtpFinal.DisplayDateStart = Convert.ToDateTime(dtpInicial.Text);

            if (Convert.ToDateTime(dtpInicial.Text) > Convert.ToDateTime(dtpFinal.Text))
            {
                dtpFinal.Text = dtpInicial.Text;
            }
        }

        #endregion :: Eventos ::

        #region :: Métodos ::
        private void CarregaVendedoresComboBox()
        {
            for(int i = 0; i < lstVendedores.Count; i++)
            {
                cmbVendedores.Items.Add(lstVendedores[i].Nome);
            }
        }

        #endregion :: Métodos ::

    }
}