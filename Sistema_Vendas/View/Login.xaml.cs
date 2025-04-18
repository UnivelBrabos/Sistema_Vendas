using System.Data.Common;
using System.Windows;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;

namespace Sistema_Vendas.View
{
    public partial class Login : Window
    {
        ConnectionDB objConnection;

        private List<Usuarios> lstUsuarios;

        public Login()
        {
            InitializeComponent();

            // Banco de dados
            DataContext = this;
            objConnection = new ConnectionDB();

            CarregaUsuarios();
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

        private async void CarregaUsuarios()
        {
            lstUsuarios = await Usuarios.GetUsuarios(objConnection);
        }

        private void btnLogar_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Usuarios objUsuario = lstUsuarios.Where(p => (p.NomeUsuario == txtUsuarioEmail.Text || p.Email == txtUsuarioEmail.Text) && p.SenhaUsuario == txtSenha.Text).First();

                if (objUsuario != null)
                {
                    MenuPrincipal objMenuPrincipal = new(objUsuario);

                    objMenuPrincipal.Show();

                    Close();
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Usuario/Email ou senha incorretos!");
            }
        }
    }
}
