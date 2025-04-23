using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
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

        public bool LogarUsuario(List<Usuarios> pUsuarios, string pUserName, string pSenha)
        {
            try
            {
                Usuarios objUsuario = pUsuarios.Where(p => (p.NomeUsuario == pUserName || p.Email == pUserName) && p.SenhaUsuario == pSenha).First();

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

        #region << Retorna a lista de objetos >>

        public Task<List<Cliente>> GetClientes => Cliente.GetClientes(objConnection); 
        public Task<List<ItensVenda>> GetItensVenda => ItensVenda.GetItensVenda(objConnection);
        public Task<List<Produto>> GetProdutos => Produto.GetProdutos(objConnection);
        public Task<List<Usuarios>> GetUsuarios => Usuarios.GetUsuarios(objConnection);
        public Task<List<Vendas>> GetVendas => Vendas.GetVendas(objConnection);
        public Task<List<Vendedor>> GetVendedores => Vendedor.GetVendedores(objConnection);

        #endregion << Retorna a lista de objetos >>
    }
}
