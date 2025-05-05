using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Service;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    public class LoginController
    {
        private ILogin _Login;

        public LoginController(ILogin Login)
        {
            _Login = Login;
            _Login.eventValidaDados += ValidaUsuario; 
        }

        private void ValidaUsuario(object sender, EventArgs e)
        {
            LogarUsuario(_Login.Usuario, _Login.Senha);
        }

        public bool LogarUsuario(string pUserName, string pSenha)
        {
            try
            {
                Usuarios objUsuario = PersistDataService.Instance.lstUsuarios.Where(p => (p.NomeUsuario == pUserName || p.Email == pUserName) && p.SenhaUsuario == pSenha).First();

                if (objUsuario != null)
                {
                    App.SetUsuario(objUsuario);
                    App.View.Principal.Show();
                    return true;
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Usuario/Email ou senha incorretos!");
            }

            return false;
        }
    }
}
