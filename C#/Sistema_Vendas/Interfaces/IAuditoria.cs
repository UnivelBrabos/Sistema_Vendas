using Sistema_Vendas.Model.DataModel;
using System.Data;
using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IAuditoria
    {
        event EventHandler CarregaAuxiliar;
        event EventHandler SetVenda;
        event EventHandler UpdateVendas;
        event EventHandler DeleteVendas;

        event EventHandler UpdateVenda;
        event EventHandler DeleteVenda;

        void CarregaTabelaAuxiliar(DataGrid dttVendas);
        void MessageToUser(string Message);
    }
}
