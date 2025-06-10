using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace Sistema_Vendas.View
{
    public partial class EstoqueView : UserControl, IEstoque
    {
        public event EventHandler SetProdutos;
        public event EventHandler UpdateProduto;
        public event EventHandler LoadGrid;

        public EstoqueView()
        {
            InitializeComponent();
        }

        private void txtIdProduto_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }

        private void txtIdProduto_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                if (!IdProdutoValido(txtIdProduto.Text))
                {
                    MessageBox.Show("Venda inválida!");
                    return;
                }
            }
        }

        public void CarregaTabela(DataGrid dttVendas)
        {
            dgvAuxiliar.Columns.Clear();
            dgvAuxiliar.ItemsSource = null;
            dgvAuxiliar.ItemsSource = dttVendas.ItemsSource;
        }

        private void txtValorEstoque_GotFocus(object sender, RoutedEventArgs e)
        {
            if(txtValorEstoque.Text == "Estoque")
            {
                txtValorEstoque.Text = "";
            }
        }

        private void txtValorEstoque_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }

        private bool IdProdutoValido(string pIdSelecionado)
        {
            for (int i = 0; i < dgvAuxiliar.Items.Count; i++)
            {
                var item = dgvAuxiliar.Items[i];
                var valor = item.GetType().GetProperty("IdProduto").GetValue(item);

                if (valor.ToString() == pIdSelecionado)
                {
                    return true;
                }
            }

            return false;
        }

        private bool ValoresValidos()
        {
            if (string.IsNullOrEmpty(txtIdProduto.Text))
            {
                return false;
            }

            if (string.IsNullOrEmpty(txtValorEstoque.Text))
            {
                return false;
            }

            return true;
        }

        private void btnAtualizarEstoque_Click(object sender, RoutedEventArgs e)
        {
            if (!ValoresValidos())
            {
                MessageBox.Show("Todos os campos devem estar preenchidos!", "", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            UpdateProduto?.Invoke($"{txtIdProduto.Text};{txtValorEstoque.Text}", EventArgs.Empty);
            SetProdutos?.Invoke(null, EventArgs.Empty);
        }

        private void txtIdProduto_GotFocus(object sender, RoutedEventArgs e)
        {
            if (txtIdProduto.Text == "Id. Produto")
            {
                txtIdProduto.Text = "";
                SetProdutos?.Invoke(null, EventArgs.Empty);
            }
        }

        public void EstoqueAtualizado(bool Atualizado)
        {
            if (Atualizado)
            {
                MessageBox.Show("Estoque atualizado com sucesso", "", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            MessageBox.Show("Erro ao atualizar estoque!", "", MessageBoxButton.OK, MessageBoxImage.Error);
        }
    }
}
