using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IEstoque
    {
        event EventHandler SetProdutos;
        event EventHandler UpdateProduto;
        event EventHandler LoadGrid;

        void CarregaTabela(DataGrid dttVendas);

        void EstoqueAtualizado(bool Atualizado);
    }
}
