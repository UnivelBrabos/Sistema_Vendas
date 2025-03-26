using LiveCharts;
using LiveCharts.Wpf;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;

namespace Sistema_Vendas.Controller
{
    class GraficosController
    {
        private MainWindow _Main { get; set; }

        public GraficosController(MainWindow main)
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

                    lstFiltrada = FiltrarVendidosPorData(lstFiltrada, pFiltros.Inicial, pFiltros.Final);

                    #endregion :: Por Data ::
                }

                var lstMaisVendidos = lstFiltrada.OrderByDescending(p => p.TotalVendido)
                                      .Take(5)
                                      .ToList();


                for(int i = 0; i <  lstMaisVendidos.Count; i++) 
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

                if (pFiltrar)
                {
                    List<Vendedor> lstVendedoresfiltrada = _Main.lstVendedores.Where(p => pFiltros.IdVendedores.Contains(p.IdVendedor)).ToList();

                    for (int i = 0; i < lstVendedoresfiltrada.Count; i++)
                    {
                        PieSeries pieSeries = new()
                        {
                            Title = _Main.lstVendedores[i].Nome
                        };

                        pieSeries.Values = new ChartValues<double>
                        {
                            Convert.ToDouble(_Main.lstVendas.Where(p => p.IdVendedor == lstVendedoresfiltrada[i].IdVendedor && p.DataVenda >= pFiltros.Inicial && p.DataVenda <= pFiltros.Final)
                                                            .Sum(p => p.TotalVenda))
                        };

                        objGrafico.Series.Add(pieSeries);
                    }
                }
                else
                {
                    for (int i = 0; i < _Main.lstVendedores.Count; i++)
                    {
                        PieSeries pieSeries = new()
                        {
                            Title = _Main.lstVendedores[i].Nome
                        };

                        pieSeries.Values = new ChartValues<double>
                        {
                            Convert.ToDouble(_Main.lstVendas.Where(p => p.IdVendedor == _Main.lstVendedores[i].IdVendedor)
                                     .Sum(p => p.TotalVenda))
                        };

                        objGrafico.Series.Add(pieSeries);
                    }
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
        public IOrderedEnumerable<MaisVendidos> FiltrarVendidosPorData(IEnumerable<dynamic> pListaFiltrada, DateTime pInicial, DateTime pFinal)
        {
            return _Main.lstProdutos.Select(p => new MaisVendidos
            {
                Produto = p.Nome,
                TotalVendido = _Main.lstItensVenda
                                       .Where(t => t.IdProduto == p.IdProduto &&
                                              _Main.lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                                  v.DataVenda >= pInicial &&
                                                                  v.DataVenda <= pFinal))
                                       .Sum(t => t.QuantidadeLote * p.Lote),
                IdentificadorVenda = _Main.lstItensVenda
                                       .Where(t => t.IdProduto == p.IdProduto &&
                                                   _Main.lstVendas.Any(v => v.IdVenda == t.IdVenda &&
                                                                   v.DataVenda >= pInicial &&
                                                                   v.DataVenda <= pFinal))
                                       .Select(t => t.IdVenda)
            })
            .Where(p => p.IdentificadorVenda.Any())
            .OrderByDescending(p => p.TotalVendido);
        }

        #endregion :: Filtros por Data :;
    }
}
