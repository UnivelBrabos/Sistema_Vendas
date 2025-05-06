using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.DataModel;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Automation;
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
        public event EventHandler eventLoaded;

        public FiltrarView()
        {
            InitializeComponent();

            grdFiltrar.Loaded += (s, e) => eventLoaded?.Invoke(this, EventArgs.Empty);
        }

        public void CarregaFiltros(List<Cliente> pClientes, List<Vendedor> pVendedores)
        {
            for(int i = 0; i < pClientes.Count; i++)
            {
                CheckBox chkClientes = new();

                chkClientes.Content = pClientes[i].Nome;
                chkClientes.Tag = pClientes[i].IdCliente;

                plnClientes.Children.Add(chkClientes);
            }

            for (int i = 0; i < pVendedores.Count; i++)
            {
                CheckBox chkVendedor = new();

                chkVendedor.Content = pVendedores[i].Nome;
                chkVendedor.Tag = pVendedores[i].IdVendedor;

                plnVendedores.Children.Add(chkVendedor);
            }
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
