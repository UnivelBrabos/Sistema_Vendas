using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Model.FilteredModel;
using System.Windows;
using System.Windows.Controls;

namespace Sistema_Vendas.View.UserController
{
    /// <summary>
    /// Interação lógica para FiltrarView.xam
    /// </summary>
    public partial class FiltrarView : UserControl, IFiltrar
    {
        public event EventHandler eventLoaded;
        public event EventHandler eventFiltrar;

        public Filtros Filtros {  get; set; }

        public FiltrarView()
        {
            InitializeComponent();

            grdFiltrar.Loaded += (s, e) => eventLoaded?.Invoke(this, EventArgs.Empty);

            dtpFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            dtpInicial.Text = "01/01/2025";
        }

        public void CarregaFiltros(List<Cliente> pClientes, List<Vendedor> pVendedores)
        {
            plnClientes.Children.Clear();
            plnVendedores.Children.Clear();

            for (int i = 0; i < pClientes.Count; i++)
            {
                CheckBox chkClientes = new();

                chkClientes.Content = pClientes[i].Nome;
                chkClientes.Tag = pClientes[i].IdCliente;
                chkClientes.IsChecked = true;

                plnClientes.Children.Add(chkClientes);
            }

            for (int i = 0; i < pVendedores.Count; i++)
            {
                CheckBox chkVendedor = new();

                chkVendedor.Content = pVendedores[i].Nome;
                chkVendedor.Tag = pVendedores[i].IdVendedor;
                chkVendedor.IsChecked = true;

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

        private void PreencherFiltros(ref List<int> IdClientes, ref List<int> idVendedores)
        {


            foreach (var child in plnClientes.Children)
            {
                if (child is CheckBox cb && cb.IsChecked == true)
                {
                    IdClientes.Add((int)cb.Tag);
                }
            }

            foreach (var child in plnVendedores.Children)
            {
                if (child is CheckBox cb && cb.IsChecked == true)
                {
                    idVendedores.Add((int)cb.Tag);
                }
            }
        }

        private void btnFiltrar_Click(object sender, RoutedEventArgs e)
        {
            List<int> idClientes = new();
            List<int> idVendedores = new();
            DateTime dttInicial = new(DateTime.Now.Year, 1, 1);
            DateTime dttFinal = DateTime.Now;

            PreencherFiltros(ref idClientes, ref idVendedores);

            DateTime.TryParse(dtpInicial.Text, out dttInicial);
            DateTime.TryParse((dtpFinal.Text), out dttFinal);

            Filtros = new(dttInicial, dttFinal, idVendedores, idClientes);

            eventFiltrar.Invoke(this, EventArgs.Empty);
        }

        private void btnLimpar_Click(object sender, RoutedEventArgs e)
        {
            Filtros = new();
            eventFiltrar.Invoke(this, EventArgs.Empty);
        }
    }
}
