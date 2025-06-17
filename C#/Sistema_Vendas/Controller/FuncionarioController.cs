using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Service;
using System.Windows.Controls;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.DataModel;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    public class FuncionarioController
    {
        IFuncionario _Funcionario;

        public FuncionarioController(IFuncionario Funcionario) 
        {
            _Funcionario = Funcionario;

            _Funcionario.CarregarFuncionario += CarregarFuncionarios;
            _Funcionario.AtualizarFuncionario += AtualizarFuncionario;
            _Funcionario.ApagarFuncionario += DeletarFuncionario;
        }

        private void CarregarFuncionarios(object sender, EventArgs e)
        {
            DataGrid Dados = new();
            Dados.ItemsSource = PersistDataService.Instance.lstVendedores;

            _Funcionario.CarregarTabelaAuxiliar(Dados);
        }

        private async void AtualizarFuncionario(object sender, EventArgs e)
        {
            string[] Dados = sender.ToString().Split(';');

            Vendedor Vendedor = PersistDataService.Instance.lstVendedores.Where(p => p.IdVendedor.ToString() == Dados[0]).FirstOrDefault();

            Vendedor.Email = Dados[1];
            Vendedor.Salario = Convert.ToDouble(Dados[2]);

            _Funcionario.VendedorAtualizado(await Vendedor.UpdateModel(), "atualizado");
            PersistDataService.Instance.UpdateFuncionario();
            CarregarFuncionarios(null, EventArgs.Empty);
        }

        private async void DeletarFuncionario(object sender, EventArgs e)
        {
            string IdFuncionario = sender.ToString();

            Vendedor Vendedor = PersistDataService.Instance.lstVendedores.Where(p => p.IdVendedor.ToString() == IdFuncionario).FirstOrDefault();
            _Funcionario.VendedorAtualizado(await Vendedor.DeleteModel(), "deletado");
        }
    }
}
