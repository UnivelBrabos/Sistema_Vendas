using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Sistema_Vendas.View.UserController
{
    /// <summary>
    /// Interação lógica para FiltrarView.xam
    /// </summary>
    public partial class FiltrarView : UserControl, IFiltrar
    {
        public ObservableCollection<CheckBoxOptions> _itemscVendedoresCheckBox { get; set; }
        public ObservableCollection<CheckBoxOptions> _itemsClientesCheckBox { get; set; }

        public event EventHandler eventLoaded;

        public FiltrarView()
        {
            grdFiltrar.Loaded += (s, e) => eventLoaded?.Invoke(this, EventArgs.Empty);
        }


        public void CarregaFiltros()
        {
            
        }

        private void dtpInicial_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            dtpFinal.DisplayDateStart = Convert.ToDateTime(dtpInicial.Text);

            if (Convert.ToDateTime(dtpInicial.Text) > Convert.ToDateTime(dtpFinal.Text))
            {
                dtpFinal.Text = dtpInicial.Text;
            }
        }
    }
}
