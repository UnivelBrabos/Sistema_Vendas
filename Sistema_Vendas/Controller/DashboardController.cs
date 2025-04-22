using LiveCharts;
using LiveCharts.Wpf;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;
using Sistema_Vendas.View;
using System.Globalization;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    class DashboardController
    {
        private MainWindow _MainDefasada { get; set; }
        private MenuPrincipal _Main { get; set; }

        public DashboardController(MenuPrincipal main)
        {
            _Main = main;
        }

        public bool MaisVendidos(ref CartesianChart objGrafico, bool pFiltrar, Filtros pFiltros, out string pRetorno)
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

                if (pFiltrar)
                {
                    #region :: Por Data ::

                    lstFiltrada = FiltrarVendidosPorData(lstFiltrada, pFiltros);

                    #endregion :: Por Data ::
                }

                var lstMaisVendidos = lstFiltrada.OrderByDescending(p => p.TotalVendido)
                                      .Take(5)
                                      .ToList();


                for (int i = 0; i < lstMaisVendidos.Count; i++)
                {
                    rowSeries.Values.Add(Convert.ToDouble(lstMaisVendidos[i].TotalVendido));
                    labelsY[i] = lstMaisVendidos[i].Produto;
                }

                objGrafico.Series = new SeriesCollection
                {
                    rowSeries
                };

                objGrafico.AxisY[0].Labels = labelsY;
            }
            catch (Exception ex)
            {
                pRetorno = $"Erro ao criar gráfico de vendas: {ex.Message}";
                return false;
            }

            pRetorno = "Sucesso";
            return true;
        }

        public bool ParticipacaoLucros(ref PieChart objGrafico, bool pFiltrar, Filtros pFiltros, out string pRetorno)
        {
            try
            {
                objGrafico.Series = new SeriesCollection();

                List<Vendas> lstAuxiliar = new();
                List<Vendedor> lstVendedoresAuxiliar = new();

                if (pFiltrar)
                {
                    lstAuxiliar = _Main.lstVendas.Where(p => (p.DataVenda >= pFiltros.Inicial &&
                                                              p.DataVenda <= pFiltros.Final) &&
                                                              pFiltros.IdVendedores.Contains(p.IdVendedor) &&
                                                              pFiltros.IdClientes.Contains(p.IdCliente)).ToList();

                    lstVendedoresAuxiliar = _Main.lstVendedores.Where(p => pFiltros.IdVendedores.Contains(p.IdVendedor)).ToList();
                }
                else
                {
                    lstAuxiliar = _Main.lstVendas;
                    lstVendedoresAuxiliar = _Main.lstVendedores;
                }

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

                    objGrafico.Series.Add(pieSeries);
                }

            }
            catch (Exception ex)
            {
                pRetorno = $"Erro ao carregar gráfico de participação: {ex.Message}";
                return false;
            }

            pRetorno = "Sucesso";
            return true;
        }

        public bool VendasMensais(ref CartesianChart objGrafico, bool pFiltrar, Filtros pFiltros, out string pRetorno)
        {
            List<Vendas> lstAuxiliar = new();

            try
            {
                // Limpa os dados anteriores do gráfico
                objGrafico.Series.Clear();
                objGrafico.AxisX.Clear();
                objGrafico.AxisY.Clear();

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
                objGrafico.AxisY.Add(new Axis
                {
                    Title = "Vendas",
                    LabelFormatter = value => value.ToString("N")
                });


                if (pFiltrar)
                {
                    lstAuxiliar = _Main.lstVendas
                                        .Where(d => ((d.DataVenda >= Convert.ToDateTime(pFiltros.Inicial) &&
                                                    (d.DataVenda <= Convert.ToDateTime(pFiltros.Final)))) &&
                                                     pFiltros.IdVendedores.Contains(d.IdVendedor) &&
                                                     pFiltros.IdClientes.Contains(d.IdCliente)).ToList();
                }
                else
                {
                    lstAuxiliar = _Main.lstVendas;
                }

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

                // Adiciona os eixos e séries ao gráfico
                objGrafico.AxisX.Add(EixoX);
                objGrafico.Series.Add(columnSeries);
            }
            catch (Exception ex)
            {
                pRetorno = $"Erro durante cálculo das vendas por mês: {ex.Message}";

                return false;
            }

            pRetorno = "Sucesso";
            return true;
        }

        public bool MelhoresClientes(ref PieChart objGrafico, bool pFiltrar, Filtros pFiltros, out string pRetorno)
        {
            try
            {
                objGrafico.Series = new SeriesCollection();
                List<Vendas> lstAuxiliar = new();
                List<Cliente> lstClientesAuxiliar = new();

                if (pFiltrar)
                {
                    lstAuxiliar = _Main.lstVendas.Where(d => (d.DataVenda >= Convert.ToDateTime(pFiltros.Inicial) &&
                                                              d.DataVenda <= Convert.ToDateTime(pFiltros.Final)) &&
                                                              pFiltros.IdVendedores.Contains(d.IdVendedor) &&
                                                              pFiltros.IdClientes.Contains(d.IdCliente)).ToList();

                    lstClientesAuxiliar = _Main.lstClientes.Where(p => pFiltros.IdClientes.Contains(p.IdCliente)).ToList();
                }
                else
                {
                    lstAuxiliar = _Main.lstVendas;
                    lstClientesAuxiliar = _Main.lstClientes;
                }

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
                    objGrafico.Series.Add(new PieSeries
                    {
                        Title = item.Nome,
                        Values = new ChartValues<double> { Convert.ToDouble(item.Total) }
                    });
                }

                if (lstFiltrada.Count > 5)
                {
                    objGrafico.Series.Add(new PieSeries
                    {
                        Title = "Outros",
                        Values = new ChartValues<double> { Convert.ToDouble(outrosTotal) }
                    });
                }
            }
            catch (Exception ex)
            {
                pRetorno = $"Erro durante cálculo de participação de lucros: {ex.Message}";
                return false;
            }

            pRetorno = "Sucesso";
            return true;
        }

        #region :: Sem filtragem ::


        public IOrderedEnumerable<MaisVendidos> GraficoMainVendidos()
        {
            return _Main.lstProdutos.GroupJoin(
                                    _Main.lstItensVenda,
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

        #endregion :: Sem filtragem ::

        #region :: Filtros por Data ::
        public IOrderedEnumerable<MaisVendidos> FiltrarVendidosPorData(IEnumerable<dynamic> pListaFiltrada, Filtros pFiltros)
        {
            return _Main.lstProdutos.Select(p => new MaisVendidos
            {
                Produto = p.Nome,
                TotalVendido = _Main.lstItensVenda
                                       .Where(t => t.IdProduto == p.IdProduto &&
                                              _Main.lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                                  v.DataVenda >= pFiltros.Inicial &&
                                                                  v.DataVenda <= pFiltros.Final &&
                                                                  pFiltros.IdVendedores.Contains(v.IdVendedor) &&
                                                                  pFiltros.IdClientes.Contains(v.IdCliente)))
                                       .Sum(t => t.QuantidadeLote * p.Lote),
                IdentificadorVenda = _Main.lstItensVenda
                                       .Where(t => t.IdProduto == p.IdProduto &&
                                                   _Main.lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                                   v.DataVenda >= pFiltros.Inicial &&
                                                                   v.DataVenda <= pFiltros.Final &&
                                                                   pFiltros.IdVendedores.Contains(v.IdVendedor) &&
                                                                   pFiltros.IdClientes.Contains(v.IdCliente)))
                                       .Select(t => t.IdVenda)
            })
            .Where(p => p.IdentificadorVenda.Any())
            .OrderByDescending(p => p.TotalVendido);
        }

        #endregion :: Filtros por Data :;

        #region :: Cards ::

        public bool CarregaCards(bool pFiltrar, Filtros pFiltros, out string pRetorno)
        {
            try
            {
                _Main.lblTotalVendas.Content = _Main.lstVendas.Count.ToString();
                _Main.lblTotalRecebido.Content = _Main.lstVendas.Sum(p => p.TotalVenda).ToString();
            }
            catch(Exception ex)
            {
                pRetorno = $"Falha ao carregar cards: {ex.Message}";
                return false;
            }

            pRetorno = "Sucesso";
            return true;
        }

        #endregion :: Cards :: 
    }
}
