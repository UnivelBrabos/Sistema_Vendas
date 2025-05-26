using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Interação lógica para AuditoriaView.xam
    /// </summary>
    public partial class AuditoriaView : UserControl, IAuditoria
    {
        public event EventHandler CarregaAuxiliar;

        public event EventHandler SetVenda;

        public AuditoriaView()
        {
            InitializeComponent();
        }

        private void txtVendedor_GotFocus(object sender, RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(sender, EventArgs.Empty);
        }

        private void txtCliente_GotFocus(object sender, RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(sender, EventArgs.Empty);
        }

        private void txtIdVenda_GotFocus(object sender, System.Windows.RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(sender, EventArgs.Empty);

            if(txtIdVenda.Text == "Id. Venda")
            {
                txtIdVenda.Text = "";
            }
        }

        private void btnBuscarItensVenda_Click(object sender, RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(sender, EventArgs.Empty);
        }

        private void LimparCampos()
        {
            TextBox[] lstText = { txtIdVenda, txtVendedor, txtCliente, txtDataVenda };

            for (int i = 0; i < lstText.Length; i++)
            {
                if (lstText[i].Text != "Id. Venda" && i == 0)
                {
                    continue;
                }

                lstText[i].Text = "";
                lstText[i].IsEnabled = true;
            }

            btnBuscarItensVenda.IsEnabled = true;
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

        private void txtIdVenda_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                if (!IdVendaValido(txtIdVenda.Text))
                {
                    MessageBox.Show("Venda inválida!");
                    return;
                }

                SetVenda?.Invoke(sender, EventArgs.Empty);
            }
        }

        private bool IdVendaValido(string pIdSelecionado)
        {
            foreach (Vendas item in dgvAuxiliar.Items)
            {
                if (pIdSelecionado == item.IdVenda.ToString())
                {
                    txtVendedor.Text = item.IdVendedor.ToString();
                    txtCliente.Text = item.IdCliente.ToString();
                    txtValorTotal.Text = item.TotalVenda.ToString();
                    txtDataVenda.Text = item.DataVenda.ToString("dd/MM/yyyy");

                    btnBuscarItensVenda.Tag = item.IdVenda.ToString();

                    return true;
                }
            }

            return false;
        }

        private void txtIdVenda_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (IsInitialized)
            {
                LimparCampos();
            }
        }

    }
}
