using Sistema_Vendas.Interfaces;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Interação lógica para FuncionarioView.xam
    /// </summary>
    public partial class FuncionarioView : UserControl, IFuncionario
    {
        public event EventHandler CarregarFuncionario;
        public event EventHandler AtualizarFuncionario;
        public event EventHandler ApagarFuncionario;

        public FuncionarioView()
        {
            InitializeComponent();
        }

        private void btnAtualizarEstoque_Click(object sender, RoutedEventArgs e)
        {

        }

        public void CarregarTabelaAuxiliar(DataGrid dttVendas)
        {
            dgvAuxiliar.Columns.Clear();
            dgvAuxiliar.ItemsSource = null;
            dgvAuxiliar.ItemsSource = dttVendas.ItemsSource;
        }

        private void txtIdFuncionario_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }

        private void txtIdFuncionario_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {

                if (!ValidarIdFuncionario())
                {
                    MessageBox.Show("Id inexistente!");
                    return;
                }

                txtSalario.IsEnabled = true;
                txtEmail.IsEnabled = true;
            }
        }

        private bool ValidarIdFuncionario()
        {
            for (int i = 0; i < dgvAuxiliar.Items.Count; i++)
            {
                var item = dgvAuxiliar.Items[i];
                var valor = item.GetType().GetProperty("IdVendedor").GetValue(item);

                if (valor.ToString() == txtIdFuncionario.Text)
                {
                    txtEmail.Text = item.GetType().GetProperty("Email").GetValue(item).ToString();
                    txtSalario.Text = item.GetType().GetProperty("Salario").GetValue(item).ToString();

                    return true;
                }
            }

            return false;
        }

        private void txtIdFuncionario_GotFocus(object sender, RoutedEventArgs e)
        {
            if (txtIdFuncionario.Text == "Id. Funcionário")
            {
                txtIdFuncionario.Text = "";
                CarregarFuncionario?.Invoke(null, EventArgs.Empty);
            }
        }

        private void btnAtualizarFuncionario_Click(object sender, RoutedEventArgs e)
        {
            if (!ValidarCampos())
            {
                MessageBox.Show("Todos os campos devem ser preenchidos!");
                return;
            }

            if (!ValidarIdFuncionario())
            {
                MessageBox.Show("Id inexistente!");
                return;
            }

            AtualizarFuncionario?.Invoke($"{txtIdFuncionario.Text};{txtEmail.Text};{txtSalario.Text}", EventArgs.Empty);
        }

        private bool ValidarCampos()
        {
            if (string.IsNullOrEmpty(txtIdFuncionario.Text))
            {
                return false;
            }

            if (string.IsNullOrEmpty(txtEmail.Text))
            {
                return false;
            }

            if (string.IsNullOrEmpty(txtSalario.Text))
            {
                return false;
            }

            return true;
        }

        public void VendedorAtualizado(bool Atualizado, string Processo)
        {
            if (Atualizado)
            {
                MessageBox.Show($"Vendedor {Processo} com sucesso!", "Sucesso");
                return;
            }

            MessageBox.Show($"Um erro ocorreu durante processo!", "Erro", MessageBoxButton.OK, MessageBoxImage.Error);
        }

        private void btnAtualizarFuncionario_Copiar_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrEmpty(txtIdFuncionario.Text))
            {
                MessageBox.Show("O campo Id. Funcionário deve estar preenchido!");
                return;
            }

            if (!ValidarIdFuncionario())
            {
                MessageBox.Show("Id inexistente!");
                return;
            }

            if (MessageBox.Show($"Tem certeza que deseja deletar o funcionário {txtIdFuncionario.Text}", "Certeza?",
                                MessageBoxButton.YesNoCancel,
                                MessageBoxImage.Question) == MessageBoxResult.No)
            {
                return;
            }

            ApagarFuncionario?.Invoke($"{txtIdFuncionario.Text}", EventArgs.Empty);
        }
    }
}
