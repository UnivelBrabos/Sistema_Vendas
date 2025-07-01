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
            _Auditoria.UpdateVendas += UpdateVendas;
            _Auditoria.DeleteVendas += DeleteVendas; 
        }

        private void DeleteVendas(object sender, EventArgs e)
        {
            int IdVenda = Convert.ToInt32(sender.ToString());

            vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(IdVenda)).FirstOrDefault();

            if (!vendas.DeleteModel().Result)
            {
                _Auditoria.NotificarUsuario("Erro ao deletar Venda!");
            }
            else
            {
                _Auditoria.NotificarUsuario("Sucesso ao deletar Venda!");
            }
        }

        private void UpdateVendas(object sender, EventArgs e)
        {
            string[] Dados = sender.ToString().Split(';');

            vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(Dados[0])).FirstOrDefault();

            vendas.IdCliente = Convert.ToInt32(Dados[1]);
            vendas.IdVendedor = Convert.ToInt32(Dados[2]);

            if (!vendas.UpdateModel().Result)
            {
                _Auditoria.NotificarUsuario("Erro ao atualizar Venda!");
            }
            else
            {
                _Auditoria.NotificarUsuario("Sucesso ao Venda!");
            }
        }

        private void SetVenda(object sender, EventArgs e)
        {
            vendas = PersistDataService.Instance.lstVendas.Where(p => p.IdVenda == Convert.ToInt32(sender.ToString())).FirstOrDefault();
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
