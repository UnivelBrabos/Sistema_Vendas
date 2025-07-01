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

        void CarregaTabelaAuxiliar(DataGrid dttVendas);
        void NotificarUsuario(string pMensagem);
    }
}
