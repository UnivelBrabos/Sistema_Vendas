using Sistema_Vendas.Model.DataModel;
using System.Data;

namespace Sistema_Vendas.Interfaces
{
    public interface IAuditoria
    {
        event EventHandler CarregaIDs;

        Vendas Venda { get; set; }

        void CarregaTabelaAuxiliar(DataTable dttVendas);
    }
}
