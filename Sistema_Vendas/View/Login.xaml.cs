using System.Windows;
using Sistema_Vendas.Model;
using Sistema_Vendas.Controller;

namespace Sistema_Vendas.View
{
    public partial class Login : Window
    {
        private DataController dataController;

        public Login()
        {
            InitializeComponent();
            dataController = new();
        }

        private void txtUsuarioEmail_GotFocus(object sender, RoutedEventArgs e)
        {
            if(txtUsuarioEmail.Text == "Usuario/Email")
            {
                txtUsuarioEmail.Text = "";
            }
        }

        private void txtSenha_GotFocus(object sender, RoutedEventArgs e)
        {
            if(txtSenha.Text == "Senha")
            {
                txtSenha.Text = "";
            }
        }

        private void btnLogar_Click(object sender, RoutedEventArgs e)
        {
            if(dataController.LogarUsuario(txtUsuarioEmail.Text, txtSenha.Text))
            {
                Close();
            }
        }

        private void grdPrincipal_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == System.Windows.Input.Key.Enter)
            {
                if(dataController.LogarUsuario(txtUsuarioEmail.Text, txtSenha.Text))
                {
                    Close();
                }
            }
        }
    }
}
