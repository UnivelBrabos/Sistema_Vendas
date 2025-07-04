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
        public event EventHandler UpdateVendas;
        public event EventHandler DeleteVendas;

        public event EventHandler UpdateVenda;
        public event EventHandler DeleteVenda;

        public AuditoriaView()
        {
            InitializeComponent();
        }

        private void txtVendedor_GotFocus(object sender, RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(txtVendedor.Tag, EventArgs.Empty);
        }

        private void txtCliente_GotFocus(object sender, RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(txtCliente.Tag, EventArgs.Empty);
        }

        private void txtIdVenda_GotFocus(object sender, System.Windows.RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(txtIdVenda.Tag, EventArgs.Empty);

            if (txtIdVenda.Text == "Id. Venda")
            {
                txtIdVenda.Text = "";
            }
        }

        private void btnBuscarItensVenda_Click(object sender, RoutedEventArgs e)
        {
            CarregaAuxiliar?.Invoke(btnBuscarItensVenda.Tag, EventArgs.Empty);
        }

        private void btnSalvar_Click(object sender, RoutedEventArgs e)
        {
            if (ValidaCampos())
            {
                MessageBox.Show("Preencha todos os campos!");
                return;
            }

            UpdateVenda?.Invoke($"{txtIdVenda.Text};{txtCliente.Text};{txtVendedor.Text}", EventArgs.Empty);
        }

        private void btnExcluir_Click(object sender, RoutedEventArgs e)
        {
            if (ValidaCampos(true))
            {
                MessageBox.Show("Preencha o Id da venda!");
                return;
            }

            if (MessageBox.Show("Confirmar exclusão da venda?", "Confirmação", MessageBoxButton.YesNo) == MessageBoxResult.Yes)
            {
                UpdateVenda?.Invoke($"{txtIdVenda.Text}", EventArgs.Empty);
            }
        }

        private void txtIdVenda_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (IsInitialized)
            {
                LimparCampos();
            }
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

                SetVenda?.Invoke(txtIdVenda.Text, EventArgs.Empty);
            }
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

        public void MessageToUser(string Message)
        {
            MessageBox.Show(Message);
        }

        private bool ValidaCampos(bool SomenteId = false)
        {
            if (string.IsNullOrEmpty(txtIdVenda.Text))
            {
                return false;
            }

            if (!SomenteId)
            {
                if (string.IsNullOrEmpty(txtCliente.Text) || string.IsNullOrEmpty(txtVendedor.Text))
                {
                    return false;
                }
            }

            return true;
        }
    }
}
