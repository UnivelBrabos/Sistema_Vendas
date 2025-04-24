using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using Sistema_Vendas.Service;
using Sistema_Vendas.View;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    public class DataController
    {
        ConnectionDB? objConnection;

        public DataController()
        {
            // Banco de dados
            //DataContext = this;
            objConnection = new ConnectionDB();
        }

        public bool LogarUsuario(string pUserName, string pSenha)
        {
            try
            {
                Usuarios objUsuario = PersistDataService.Instance.lstUsuarios.Where(p => (p.NomeUsuario == pUserName || p.Email == pUserName) && p.SenhaUsuario == pSenha).First();

                if (objUsuario != null)
                {
                    MenuPrincipal objMenuPrincipal = new(objUsuario);

                    objMenuPrincipal.Show();
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
