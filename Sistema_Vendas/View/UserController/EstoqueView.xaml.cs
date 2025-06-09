using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using System;
using System.Collections.Generic;
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
            SetProdutos?.Invoke(null, EventArgs.Empty);
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
            foreach (Produto item in dgvAuxiliar.Items)
            {
                if (pIdSelecionado == item.IdProduto.ToString())
                {
                    txtIdProduto.Text = item.Estoque.ToString();

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

        private bool ItemAtualizado()
        {
            foreach (Produto item in dgvAuxiliar.Items)
            {
                if (txtIdProduto.Text == item.IdProduto.ToString())
                {
                    return txtValorEstoque.Text == item.Estoque.ToString();
                }
            }

            return false;
        }

        private void btnAtualizarEstoque_Click(object sender, RoutedEventArgs e)
        {
            if (!ValoresValidos())
            {
                MessageBox.Show("Todos os campos devem estar preenchidos!", "", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (!ItemAtualizado())
            {
                MessageBox.Show("Item não sofreu alteração!", "", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            UpdateProduto?.Invoke($"{txtIdProduto.Text};{txtValorEstoque.Text}", EventArgs.Empty);
        }

        private void txtIdProduto_GotFocus(object sender, RoutedEventArgs e)
        {

        }
    }
}
