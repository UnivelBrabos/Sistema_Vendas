using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Service;
using System.Windows.Controls;
namespace Sistema_Vendas.Controller
{
    public class EstoqueController
    {
        private IEstoque _Estoque { get; set; }

        public EstoqueController(IEstoque IEstoque)
        {
            _Estoque = IEstoque;
            _Estoque.SetProdutos += CarregaTabela;
            _Estoque.UpdateProduto += AtualizarEstoque;
        }

        private void CarregaTabela(object Sender, EventArgs e)
        {
            DataGrid Dados = new();
            Dados.ItemsSource = PersistDataService.Instance.lstProdutos;

            _Estoque.CarregaTabela(Dados);
        }

        private async void AtualizarEstoque(object Sender, EventArgs e)
        {
            string[] Valores = Sender.ToString().Split(';');

            int IdProduto = Convert.ToInt32(Valores[0]);
            int NovoEstoque = Convert.ToInt32(Valores[1]);

            Produto Produto = PersistDataService.Instance.lstProdutos.Where(p => p.IdProduto == IdProduto).FirstOrDefault();
            Produto.Estoque = NovoEstoque;

            _Estoque.EstoqueAtualizado(await Produto.UpdateModel());
        }
    }
}
