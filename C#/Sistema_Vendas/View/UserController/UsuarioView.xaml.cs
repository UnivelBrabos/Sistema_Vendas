using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using Spark.Interfaces;

namespace Spark.View.UserController
{
    /// <summary>
    /// Interação lógica para UsuarioView.xam
    /// </summary>
    public partial class UsuarioView : UserControl, IUsuario
    {
        public event EventHandler CarregarDados;

        public UsuarioView()
        {
            InitializeComponent();
        }

        public void AtribuirDados(string pDados)
        {
            string[] Dados = pDados.Split(';');

            txtNome.Text = Dados[0];
            txtEmail.Text = Dados[1];
            txtSalario.Text = Dados[2];
            txtCargo.Text = Dados[3];
        }

        private void UserControl_Initialized(object sender, EventArgs e)
        {
            CarregarDados?.Invoke(null, EventArgs.Empty);
        }
    }
}
