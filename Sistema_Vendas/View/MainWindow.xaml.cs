using LiveCharts;
using LiveCharts.Wpf;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;


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
        private List<Produto> lstProdutos;
        private List<Cliente> lstClientes;
        private List<ItensVenda> lstItensVenda;

        public MainWindow()
        {
            InitializeComponent();
            objConnect = new ConnectionDB(); // Inicializa a conexão junto ao sistema

            CarregaDados();

            dtpFinal.DisplayDateEnd = DateTime.Today;
            dtpInicial.DisplayDateEnd = DateTime.Today;
        }

        public async void CarregaDados()
        {
            lstVendedores = await Vendedor.GetVendedores(objConnect);

            lstVendas = await Vendas.GetVendas(objConnect);

            lstProdutos = await Produto.GetProdutos(objConnect);

            lstClientes = await Cliente.GetClientes(objConnect);

            lstItensVenda = await ItensVenda.GetItensVenda(objConnect);

            CarregaGrafico();
        }

        #region :: Carregamento dos gráficos ::
        public void CarregaGrafico(bool filtrar = false)
        {
            string strRetorno;

            try
            {
                if (!GraficoPartLucro(out strRetorno, filtrar))
                {
                    throw new Exception(strRetorno);
                }

                if (!GraficoVendasMes(out strRetorno, filtrar))
                {
                    throw new Exception(strRetorno);
                }

                if (!GraficoClientes(out strRetorno, filtrar))
                {
                    throw new Exception(strRetorno);
                }

                if (!GraficoProdVendas(out strRetorno, filtrar))
                {
                    throw new Exception(strRetorno);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public bool GraficoProdVendas(out string pMensagem, bool filtrar)
        {
            try
            {
                RowSeries rowSeries = new RowSeries
                {
                    Title = "",
                    Values = new ChartValues<double>()
                };

                string[] labelsY = new string[5];
                int i = 0;

                // Filtragem e cálculo dos produtos mais vendidos
                var lstFiltrada = lstProdutos.GroupJoin(
                                    lstItensVenda,
                                    p => p.IdProduto,
                                    v => v.IdProduto,
                                    (p, v) => new
                                    {
                                        Produto = p.Nome,
                                        TotalVendido = v.Sum(t => (t.QuantidadeLote * p.Lote)),
                                        IdentificadorVenda = v.Select(t => t.IdVenda)
                                    })
                                    .OrderByDescending(item => item.TotalVendido);
                if (filtrar)
                {
                    #region :: Por Data ::

                    if (!string.IsNullOrEmpty(dtpInicial.Text) && !string.IsNullOrEmpty(dtpFinal.Text))
                    {
                        DateTime dataInicial = DateTime.Parse(dtpInicial.Text);
                        DateTime dataFinal = DateTime.Parse(dtpFinal.Text).AddDays(1).AddTicks(-1); // Final do dia

                        lstFiltrada = lstProdutos.Select(p => new
                        {
                            Produto = p.Nome,
                            TotalVendido = lstItensVenda
                                .Where(t => t.IdProduto == p.IdProduto &&
                                            lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                               v.DataVenda >= dataInicial &&
                                                               v.DataVenda <= dataFinal))
                                .Sum(t => t.QuantidadeLote * p.Lote),
                            IdentificadorVenda = lstItensVenda
                                .Where(t => t.IdProduto == p.IdProduto &&
                                            lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                               v.DataVenda >= dataInicial &&
                                                               v.DataVenda <= dataFinal))
                                .Select(t => t.IdVenda)
                        })
                        .Where(p => p.IdentificadorVenda.Any()) // Remove produtos sem vendas no período
                        .OrderByDescending(p => p.TotalVendido);
                    }
                    else if (!string.IsNullOrEmpty(dtpInicial.Text))
                    {

                    }
                    else if (!string.IsNullOrEmpty(dtpFinal.Text))
                    {

                    }

                    #endregion :: Por Data ::
                }

                var lstMaisVendidos = lstFiltrada.OrderByDescending(p => p.TotalVendido)
                                           .Take(5)
                                           .ToList();


                foreach (var produto in lstMaisVendidos)
                {
                    rowSeries.Values.Add(Convert.ToDouble(produto.TotalVendido));
                    labelsY[i] = produto.Produto;
                    i++;
                }

                ProdutosCharControl.Series = new SeriesCollection
                {
                    rowSeries
                };

                ProdutosCharControl.AxisY[0].Labels = labelsY;
            }
            catch (Exception ex)
            {
                pMensagem = $"Erro ao carregar produtos mais vendidos: {ex.Message}";
                return false;
            }

            pMensagem = "Sucesso";
            return true;
        }

        public bool GraficoPartLucro(out string pMensagem, bool filtrar)
        {
            try
            {
                VendedoresChartControl.Series = new SeriesCollection();

                for (int i = 0; i < lstVendedores.Count; i++)
                {
                    PieSeries pieSeries = new()
                    {
                        Title = lstVendedores[i].Nome
                    };

                    if (filtrar)
                    {
                        #region :: Por Data ::

                        if (!string.IsNullOrEmpty(dtpInicial.Text) && !string.IsNullOrEmpty(dtpFinal.Text))
                        {
                            DateTime dttInicial = Convert.ToDateTime(dtpInicial.Text);
                            DateTime dttFinal = Convert.ToDateTime(dtpFinal.Text);

                            pieSeries.Values = new ChartValues<double>
                            {
                                Convert.ToDouble(lstVendas.Where(p => p.IdVendedor == lstVendedores[i].IdVendedor && p.DataVenda >= dttInicial && p.DataVenda <= dttFinal)
                                                            .Sum(p => p.TotalVenda))
                            };
                        }

                        #endregion :: Por Data ::
                    }
                    else
                    {
                        pieSeries.Values = new ChartValues<double>
                        {
                            Convert.ToDouble(lstVendas.Where(p => p.IdVendedor == lstVendedores[i].IdVendedor)
                                     .Sum(p => p.TotalVenda))
                        };
                    }

                    VendedoresChartControl.Series.Add(pieSeries);
                }
            }
            catch (Exception ex)
            {
                pMensagem = $"Erro durante calculo de participação de lucros: {ex.Message}";
                return false;
            }

            pMensagem = "Sucesso";
            return true;
        }

        public bool GraficoVendasMes(out string pMensagem, bool filtrar)
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
                        .Select(g => new
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
                        .Select(g => new
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
                pMensagem = $"Erro durante cálculo das vendas por mês: {ex.Message}";
                return false;
            }

            pMensagem = "Sucesso";
            return true;
        }

        public bool GraficoClientes(out string pMensagem, bool filtrar)
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
                pMensagem = $"Erro durante calculo de participação de lucros: {ex.Message}";
                return false;
            }

            pMensagem = "Sucesso";
            return true;
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
            dtpInicial.Text = "";
            dtpFinal.Text = "";
        }

        private void dtpInicial_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!string.IsNullOrEmpty(dtpInicial.Text))
            {
                dtpFinal.DisplayDateStart = Convert.ToDateTime(dtpInicial.Text);

                DateTime dttFinal = string.IsNullOrEmpty(dtpFinal.Text) ? DateTime.Today : Convert.ToDateTime(dtpFinal.Text);
                DateTime dttInicial = Convert.ToDateTime(dtpInicial.Text);

                if (dttFinal < dttInicial)
                {
                    dtpFinal.Text = dtpInicial.Text;
                }
            }
        }
        #endregion :: Eventos ::
    }
}