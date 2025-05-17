using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using System.Windows.Controls;
using System.Windows.Input;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Interação lógica para AuditoriaView.xam
    /// </summary>
    public partial class AuditoriaView : UserControl, IAuditoria
    {
        public event EventHandler CarregaIDs;
        public event EventHandler CarregaVendedor;
        public event EventHandler CarregaCliente;

        public event EventHandler ItemSelecionado;

        public Vendas Venda { get; set; }

        public AuditoriaView()
        {
            InitializeComponent();

            LoadEvents();
        }

        private void LoadEvents()
        {
            txtCliente.GotFocus += (s, e) => CarregaCliente?.Invoke(this, EventArgs.Empty);
            txtVendedor.GotFocus += (s, e) => CarregaVendedor?.Invoke(this, EventArgs.Empty);
        }

        public void CarregaTabelaAuxiliar(DataGrid dttVendas)
        {
            dgvAuxiliar.Columns.Clear();
            dgvAuxiliar.ItemsSource = null;
            dgvAuxiliar.ItemsSource = dttVendas.ItemsSource;
        }

        private void txtIdVenda_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }

        public void CarregaInformacoes(double pTotalVenda, DateTime DataVenda)
        {
            throw new NotImplementedException();
        }

        private void txtIdVenda_KeyDown(object sender, KeyEventArgs e)
        {
            if(e.Key == Key.Enter && string.IsNullOrEmpty(txtIdVenda.Text))
            {
                ItemSelecionado?.Invoke(sender, EventArgs.Empty);
            }
        }

        private void txtIdVenda_GotFocus(object sender, System.Windows.RoutedEventArgs e)
        {
            CarregaIDs?.Invoke(sender, EventArgs.Empty);
        }
    }
}
