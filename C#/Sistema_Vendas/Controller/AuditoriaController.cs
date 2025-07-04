using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Service;
using System.Windows.Controls;

namespace Sistema_Vendas.Controller
{
    public class AuditoriaController
    {
        private Vendas vendas { get; set; }

        public IAuditoria _Auditoria { get; set; }

        public AuditoriaController(IAuditoria Auditoria)
        {
            _Auditoria = Auditoria;
            _Auditoria.CarregaAuxiliar += SetAuxiliar;
            _Auditoria.SetVenda += SetVenda;

            _Auditoria.UpdateVenda += UpdateVenda;
            _Auditoria.DeleteVenda += DeleteVenda;
        }

        private void SetVenda(object sender, EventArgs e)
        {
            vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(sender.ToString())).FirstOrDefault();
        }

        private void DeleteVenda(object sender, EventArgs e)
        {
            try
            {
                vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(sender.ToString())).FirstOrDefault();

                vendas.DeleteModel();
            }
            catch (Exception ex)
            {
                _Auditoria.MessageToUser($"Erro ao deletar a venda:{ex.Message}");
            }
        }

        private void UpdateVenda(object sender, EventArgs e)
        {
            try
            {
                string[] strDados = sender.ToString().Split(';');

                vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(strDados[0])).FirstOrDefault();

                vendas.IdVendedor = Convert.ToInt32(strDados[1]);
                vendas.IdCliente = Convert.ToInt32(strDados[2]);

                vendas.UpdateModel();
            }
            catch (Exception ex)
            {
                _Auditoria.MessageToUser($"Erro ao atualizar venda: {ex.Message}");
            }
        }

        private void SetAuxiliar(object Sender, EventArgs e)
        {
            DataGrid Dados = new();

            switch (Sender.ToString())
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
                default:
                    List<Produto> lstProduto = new List<Produto>();
                    lstProduto = PersistDataService.Instance.lstProdutos;

                    Dados.ItemsSource = PersistDataService.Instance.lstItensVenda.Where(f => f.IdVenda.ToString() == Sender.ToString()).GroupJoin(lstProduto,
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
                    break;
            }

            _Auditoria.CarregaTabelaAuxiliar(Dados);
        }


    }
}
