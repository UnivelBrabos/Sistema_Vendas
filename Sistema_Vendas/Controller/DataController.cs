using Sistema_Vendas.Model;
using Sistema_Vendas.Service;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    public class DataController
    {
        public DataController()
        {
        }

        public bool LogarUsuario(string pUserName, string pSenha)
        {
            try
            {
                Usuarios objUsuario = PersistDataService.Instance.lstUsuarios.Where(p => (p.NomeUsuario == pUserName || p.Email == pUserName) && p.SenhaUsuario == pSenha).First();

                if (objUsuario != null)
                {
                    App.menuPrincipal.Show();
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
