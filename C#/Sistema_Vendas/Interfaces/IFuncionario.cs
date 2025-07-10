using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace Spark.Interfaces
{
    public interface IFuncionario
    {
        event EventHandler CarregarFuncionario;
        event EventHandler AtualizarFuncionario;
        event EventHandler ApagarFuncionario;

        void CarregarTabelaAuxiliar(DataGrid dttVendas);
        void VendedorAtualizado(bool Atualizado, string Processo);
    }
}
