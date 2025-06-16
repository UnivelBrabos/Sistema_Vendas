using LiveCharts;
using LiveCharts.Wpf;
using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DashboardModel;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Model.FilteredModel;
using Sistema_Vendas.Service;
using System.Globalization;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    public class DashboardController
    {
        private IDashboard _Dashboard;
        private Filtros Filtros;

        public DashboardController(IDashboard Dashboard)
        {
            _Dashboard = Dashboard;
            _Dashboard.EventLoaded += TrataDashboard;
        }

        private void TrataDashboard(object sender, EventArgs e)
        {
            Filtros = App.Filtro;

            DadosGraficos();
            CarregaCards();
        }

        public void CarregaCards()
        {
            List<Cliente> lstClientes = PersistDataService.Instance.lstClientes.Where(p => Filtros.IdClientes.Contains(p.IdCliente)).ToList();
            List<Vendas> lstVendas = PersistDataService.Instance.lstVendas.Where(p => Filtros.IdClientes.Contains(p.IdCliente) && (p.DataVenda >= Filtros.Inicial && p.DataVenda <= Filtros.Final)).ToList();

            try
            {
                Cards cards = new Cards();

                cards.TotalVendas = lstVendas.Count.ToString();
                cards.TotalVendido = lstVendas.Sum(p => p.TotalVenda).ToString();

                cards.MelhorCliente = lstClientes
                                        .GroupJoin(lstVendas,
                                                   c => c.IdCliente,
                                                   v => v.IdCliente,
                                                   (c, v) => new
                                                   {
                                                       Nome = c.Nome,
                                                       Total = v.Sum(t => t.TotalVenda)
                                                   })
                                        .OrderByDescending(c => c.Total)
                                        .ToList()
                                        .Take(1)
                                        .FirstOrDefault().Nome;

                _Dashboard.CarregaCards(cards);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao carrega Cards: {ex.Message}");
            }
        }

        private void DadosGraficos()
        {
            GraficosModel GraficosAuxiliar = new();
            string strMensagemRetorno = string.Empty;

            try
            {
                if (!MaisVendidos(ref GraficosAuxiliar, out strMensagemRetorno))
                {
                    throw new Exception(strMensagemRetorno);
                }

                if (!ParticipacaoLucros(ref GraficosAuxiliar, out strMensagemRetorno))
                {
                    throw new Exception(strMensagemRetorno);
                }

                if (!VendasMensais(ref GraficosAuxiliar, out strMensagemRetorno))
                {
                    throw new Exception(strMensagemRetorno);
                }

                if (!MelhoresClientes(ref GraficosAuxiliar, out strMensagemRetorno))
                {
                    throw new Exception(strMensagemRetorno);
                }

                _Dashboard.CarregaGraficos(GraficosAuxiliar);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao carregar gráficos: {ex.Message}");
            }
        }

        public bool MaisVendidos(ref GraficosModel pGraficosAuxiliar, out string strRetorno)
        {
            try
            {
                RowSeries rowSeries = new RowSeries
                {
                    Title = "",
                    Values = new ChartValues<double>()
                };

                string[] labelsY = new string[5];

                var lstFiltrada = GraficoMainVendidos();

                lstFiltrada = FiltrarVendidosPorData(lstFiltrada);


                var lstMaisVendidos = lstFiltrada.OrderByDescending(p => p.TotalVendido)
                                      .Take(5)
                                      .ToList();


                for (int i = 0; i < lstMaisVendidos.Count; i++)
                {
                    rowSeries.Values.Add(Convert.ToDouble(lstMaisVendidos[i].TotalVendido));
                    labelsY[i] = lstMaisVendidos[i].Produto;
                }

                pGraficosAuxiliar.SeriesMaisVendidos = rowSeries;
                pGraficosAuxiliar.LabelsY = labelsY;
            }
            catch (Exception ex)
            {
                strRetorno = $"Erro ao criar gráfico de vendas: {ex.Message}";
                return false;
            }

            strRetorno = "Sucesso";
            return true;
        }

        public bool ParticipacaoLucros(ref GraficosModel pGraficosAuxiliar, out string strRetorno)
        {
            try
            {
                SeriesCollection Series = new SeriesCollection();

                List<Vendas> lstAuxiliar = new();
                List<Vendedor> lstVendedoresAuxiliar = new();

                lstAuxiliar = PersistDataService.Instance.lstVendas.Where(p => (p.DataVenda >= Filtros.Inicial &&
                                                          p.DataVenda <= Filtros.Final) &&
                                                          Filtros.IdVendedores.Contains(p.IdVendedor) &&
                                                          Filtros.IdClientes.Contains(p.IdCliente)).ToList();

                lstVendedoresAuxiliar = PersistDataService.Instance.lstVendedores.Where(p => Filtros.IdVendedores.Contains(p.IdVendedor)).ToList();

                for (int i = 0; i < lstVendedoresAuxiliar.Count; i++)
                {
                    PieSeries pieSeries = new()
                    {
                        Title = lstVendedoresAuxiliar[i].Nome
                    };

                    pieSeries.Values = new ChartValues<double>
                        {
                            Convert.ToDouble(lstAuxiliar.Where(p => p.IdVendedor == lstVendedoresAuxiliar[i].IdVendedor)
                                     .Sum(p => p.TotalVenda))
                        };

                    Series.Add(pieSeries);
                }

                pGraficosAuxiliar.SeriesParticipacao = Series;
            }
            catch (Exception ex)
            {
                strRetorno = $"Erro ao carregar gráfico de participação: {ex.Message}";
                return false;
            }

            strRetorno = "Sucesso";
            return true;
        }

        public bool VendasMensais(ref GraficosModel pGraficosAuxiliar, out string strRetorno)
        {
            List<Vendas> lstAuxiliar = new();

            try
            {
                pGraficosAuxiliar.SeriesVendas = new();

                Axis AxisY = new()
                {
                    Title = "Vendas",
                    LabelFormatter = value => value.ToString("N")
                };

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


                lstAuxiliar = PersistDataService.Instance.lstVendas
                                    .Where(d => ((d.DataVenda >= Convert.ToDateTime(Filtros.Inicial) &&
                                                (d.DataVenda <= Convert.ToDateTime(Filtros.Final)))) &&
                                                 Filtros.IdVendedores.Contains(d.IdVendedor) &&
                                                 Filtros.IdClientes.Contains(d.IdCliente)).ToList();

                var lstVendasOrg = lstAuxiliar
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

                pGraficosAuxiliar.SeriesVendas.Add(columnSeries);
                pGraficosAuxiliar.VendasEixos = [EixoX];
            }
            catch (Exception ex)
            {
                strRetorno = $"Erro durante cálculo das vendas por mês: {ex.Message}";

                return false;
            }

            strRetorno = "Sucesso";
            return true;
        }

        public bool MelhoresClientes(ref GraficosModel pGraficosAuxiliar, out string strRetorno)
        {
            try
            {
                SeriesCollection Series = new SeriesCollection();
                List<Vendas> lstAuxiliar = new();
                List<Cliente> lstClientesAuxiliar = new();


                lstAuxiliar = PersistDataService.Instance.lstVendas.Where(d => (d.DataVenda >= Convert.ToDateTime(Filtros.Inicial) &&
                                                          d.DataVenda <= Convert.ToDateTime(Filtros.Final)) &&
                                                          Filtros.IdVendedores.Contains(d.IdVendedor) &&
                                                          Filtros.IdClientes.Contains(d.IdCliente)).ToList();

                lstClientesAuxiliar = PersistDataService.Instance.lstClientes.Where(p => Filtros.IdClientes.Contains(p.IdCliente)).ToList();

                var lstFiltrada = lstClientesAuxiliar
                    .GroupJoin(lstAuxiliar,
                               c => c.IdCliente,
                               v => v.IdCliente,
                               (c, v) => new
                               {
                                   Nome = c.Nome,
                                   Total = v.Sum(t => t.TotalVenda)
                               })
                    .OrderByDescending(c => c.Total)
                    .ToList();


                var topClientes = lstFiltrada.Take(5).ToList();

                decimal outrosTotal = lstFiltrada.Skip(5).Sum(c => c.Total);

                foreach (var item in topClientes)
                {
                    Series.Add(new PieSeries
                    {
                        Title = item.Nome,
                        Values = new ChartValues<double> { Convert.ToDouble(item.Total) }
                    });
                }

                if (lstFiltrada.Count > 5)
                {
                    Series.Add(new PieSeries
                    {
                        Title = "Outros",
                        Values = new ChartValues<double> { Convert.ToDouble(outrosTotal) }
                    });
                }

                pGraficosAuxiliar.SeriesClientes = Series;
            }
            catch (Exception ex)
            {
                strRetorno = $"Erro durante cálculo de participação de lucros: {ex.Message}";
                return false;
            }

            strRetorno = "Sucesso";
            return true;
        }

        public IOrderedEnumerable<MaisVendidos> GraficoMainVendidos()
        {
            return PersistDataService.Instance.lstProdutos.GroupJoin(
                                    PersistDataService.Instance.lstItensVenda,
                                    p => p.IdProduto,
                                    v => v.IdProduto,
                                    (p, v) => new MaisVendidos
                                    {
                                        Produto = p.Nome,
                                        TotalVendido = v.Sum(t => (t.QuantidadeLote * p.Lote)),
                                        IdentificadorVenda = v.Select(t => t.IdVenda)
                                    })
                                    .OrderByDescending(item => item.TotalVendido);
        }

        public IOrderedEnumerable<MaisVendidos> FiltrarVendidosPorData(IEnumerable<dynamic> pListaFiltrada)
        {
            return PersistDataService.Instance.lstProdutos.Select(p => new MaisVendidos
            {
                Produto = p.Nome,
                TotalVendido = PersistDataService.Instance.lstItensVenda
                                       .Where(t => t.IdProduto == p.IdProduto &&
                                              PersistDataService.Instance.lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                                  v.DataVenda >= Filtros.Inicial &&
                                                                  v.DataVenda <= Filtros.Final &&
                                                                  Filtros.IdVendedores.Contains(v.IdVendedor) &&
                                                                  Filtros.IdClientes.Contains(v.IdCliente)))
                                       .Sum(t => t.QuantidadeLote * p.Lote),
                IdentificadorVenda = PersistDataService.Instance.lstItensVenda
                                       .Where(t => t.IdProduto == p.IdProduto &&
                                                   PersistDataService.Instance.lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                                   v.DataVenda >= Filtros.Inicial &&
                                                                   v.DataVenda <= Filtros.Final &&
                                                                   Filtros.IdVendedores.Contains(v.IdVendedor) &&
                                                                   Filtros.IdClientes.Contains(v.IdCliente)))
                                       .Select(t => t.IdVenda)
            })
            .Where(p => p.IdentificadorVenda.Any())
            .OrderByDescending(p => p.TotalVendido);
        }
    }
}
