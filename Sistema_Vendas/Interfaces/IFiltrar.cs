using Sistema_Vendas.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sistema_Vendas.Interfaces
{
    public interface IFiltrar
    {
        event EventHandler eventLoaded;

        ObservableCollection<CheckBoxOptions> _itemscVendedoresCheckBox { get; set; }
        ObservableCollection<CheckBoxOptions> _itemsClientesCheckBox { get; set; }

        void CarregaFiltros();
    }
}
