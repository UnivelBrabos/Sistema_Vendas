using Sistema_Vendas.Model.DataModel;
using System.Data;
using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IAuditoria
    {
        event EventHandler CarregaIDs;
        event EventHandler CarregaVendedor;
        event EventHandler CarregaCliente;

        event EventHandler ItemSelecionado;

        Vendas Venda { get; set; }

        void CarregaTabelaAuxiliar(DataGrid dttVendas);
        void CarregaInformacoes(double pTotalVenda, DateTime DataVenda);
    }
}
