using System.Windows;
using Spark.Model;
using Spark.Controller;
using Spark.Interfaces;

namespace Spark.View
{
    public partial class Login : Window, ILogin
    {
        public string Usuario { get; set; }
        public string Senha { get; set; }

        public event EventHandler eventValidaDados;

        public Login()
        {
            InitializeComponent();
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

        public void Logar()
        {
            Close();
        }

        private void btnLogar_Click(object sender, RoutedEventArgs e)
        {
            Usuario = txtUsuarioEmail.Text;
            Senha = txtSenha.Text;

            eventValidaDados?.Invoke(this, EventArgs.Empty);
        }
    }
}
