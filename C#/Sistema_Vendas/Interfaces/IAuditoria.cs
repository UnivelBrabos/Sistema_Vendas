using Sistema_Vendas.Model.DataModel;
using System.Data;
using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IAuditoria
    {
        event EventHandler CarregaAuxiliar;
        event EventHandler SetVenda;

        void CarregaTabelaAuxiliar(DataGrid dttVendas);
    }
}
