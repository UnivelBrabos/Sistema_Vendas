using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Service;
using System.Windows.Controls;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.DataModel;

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
            _Funcionario.ApagarFuncionario += 
        }

        private void CarregarFuncionarios(object sender, EventArgs e)
        {
            DataGrid Dados = new();
            Dados.ItemsSource = PersistDataService.Instance.lstVendedores;

            _Funcionario.CarregarTabelaAuxiliar(Dados);
        }

        private void AtualizarFuncionario(object sender, EventArgs e)
        {
            string[] Dados = sender.ToString().Split(';');

            Vendedor Vendedor = PersistDataService.Instance.lstVendedores.Where(p => p.IdVendedor.ToString() == Dados[0]).FirstOrDefault();

            Vendedor.Salario = Convert.ToDouble(Dados[1]);
            Vendedor.Salario = Convert.ToDouble(Dados[2]);

            Vendedor.UpdateModel();
        }

        private void DeletarFuncionario(object sender, EventArgs e)
        {
            string IdFuncionario = sender.ToString();


        }
    }
}
