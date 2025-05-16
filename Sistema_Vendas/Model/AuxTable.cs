using Sistema_Vendas.Model.DataModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace Sistema_Vendas.Model
{
    public class AuxTable
    {
        public DataGrid Tabela {  get; set; }

        public AuxTable() { }

        public AuxTable(List<Vendas> pVendas)
        {
            Tabela = new();


        }

        private void NovaColuna(string pNome, ref DataGrid pTabela)
        {
            pTabela.Columns.Add(new DataGridTextColumn{
                Header = pNome
            });
        }
    }
}
