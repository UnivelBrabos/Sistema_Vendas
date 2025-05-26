using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Service;
using System.Windows.Controls;
using Sistema_Vendas.Model.DataModel;

namespace Sistema_Vendas.Controller
{
    public class AuditoriaController
    {
        private Vendas vendas { get; set; }

        public IAuditoria _Auditoria {  get; set; }

        public AuditoriaController(IAuditoria Auditoria)
        {
            _Auditoria = Auditoria;
            _Auditoria.CarregaAuxiliar += SetAuxiliar;
            _Auditoria.SetVenda += SetVenda;
        }

        private void SetVenda(object sender, EventArgs e)
        {
            TextBox? Campo = sender as TextBox;

            vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(Campo.Text)).FirstOrDefault();
        }

        private void SetAuxiliar(object Sender, EventArgs e)
        {
            DataGrid Dados = new();

            try
            {
                TextBox? Campo = Sender as TextBox;

                switch (Campo.Tag)
                {
                    case "IdVenda":
                        Dados.ItemsSource = PersistDataService.Instance.lstVendas;
                        break;
                    case "Vendedor":
                        Dados.ItemsSource = PersistDataService.Instance.lstVendedores;
                        break;
                    case "Cliente":
                        Dados.ItemsSource = PersistDataService.Instance.lstClientes;
                        break;
                }
            }
            catch
            {
                Button Campo = Sender as Button;

                List<Produto> lstProduto = new List<Produto>();

                lstProduto = PersistDataService.Instance.lstProdutos;

                Dados.ItemsSource = PersistDataService.Instance.lstItensVenda.Where(f => f.IdVenda.ToString() == Campo.Tag).GroupJoin(lstProduto,
                                                                                        c => c.IdProduto,
                                                                                        d => d.IdProduto,
                                                                                        (c, d) => new
                                                                                        {
                                                                                            Produto = d.FirstOrDefault()?.Descricao,
                                                                                            QuantidadeLote = c.QuantidadeLote,
                                                                                            QuantidadeTotal = c.QuantidadeLote * d.FirstOrDefault()?.Lote,
                                                                                            Valor = d.FirstOrDefault()?.Preco,
                                                                                            ValorTotal = d.FirstOrDefault()?.Preco * (c.QuantidadeLote * d.FirstOrDefault()?.Lote)
                                                                                        });
            }
            
            _Auditoria.CarregaTabelaAuxiliar(Dados);
        }

        
    }
}
