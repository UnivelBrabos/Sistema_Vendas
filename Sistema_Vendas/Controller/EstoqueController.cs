using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Service;
using System.Windows.Controls;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.DataModel;

namespace Sistema_Vendas.Controller
{
    public class EstoqueController
    {
        private IEstoque _Estoque { get; set; }

        public EstoqueController(IEstoque IEstoque)
        {
            _Estoque = IEstoque;
            _Estoque.SetProdutos += CarregaTabela;
        }

        private void CarregaTabela(object Sender, EventArgs e)
        {
            DataGrid Dados = new();
            Dados.ItemsSource = PersistDataService.Instance.lstProdutos;

            _Estoque.CarregaTabela(Dados);
        }

        private void AtualizarEstoque(object Sender, EventArgs e)
        {
            int[] Valores = Convert.ToInt32(Sender.ToString().Split(';'));

            PersistDataService.Instance.lstProdutos.Where(p => p.IdProduto == Valores[0]).FirstOrDefault().Estoque = Valores[1];


        }
    }
}
