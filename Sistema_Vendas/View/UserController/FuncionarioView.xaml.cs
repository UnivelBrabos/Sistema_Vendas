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
    /// <summary>
    /// Interação lógica para FuncionarioView.xam
    /// </summary>
    public partial class FuncionarioView : UserControl
    {
        public FuncionarioView()
        {
            InitializeComponent();
        }

        private void btnAtualizarEstoque_Click(object sender, RoutedEventArgs e)
        {

        }

        private void txtIdFuncionario_TextChanged(object sender, TextChangedEventArgs e)
        {
            if(txtIdFuncionario.Text == "Id. Funcionário")
            {
                txtIdFuncionario.Text = "";
            }
        }

        private void txtIdProduto_PreviewTextInput(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }
    }
}
