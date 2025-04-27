using Sistema_Vendas.Controller;
using Sistema_Vendas.Data;
using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;
using System.Data.Common;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Shapes;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Lógica interna para MenuPrincipal.xaml
    /// </summary>
    public partial class MenuPrincipal : Window, IMainView
    {
        public event EventHandler eventDashboard;
        public event EventHandler eventAuditoria;
        public event EventHandler eventFuncionarios;
        public event EventHandler eventEstoque;

        public MenuPrincipal()
        {
            InitializeComponent();
            EventSet();
        }

        private void EventSet()
        {
            btnDashboard.Click += (s, e) => eventDashboard?.Invoke(this, EventArgs.Empty);
            btnAuditoria.Click += (s, e) => eventAuditoria?.Invoke(this, EventArgs.Empty);
            btnFuncionarios.Click += (s, e) => eventFuncionarios?.Invoke(this, EventArgs.Empty);
            btnEstoque.Click += (s, e) => eventEstoque?.Invoke(this, EventArgs.Empty);
        }

        public void DestacarBotao(Button botaoSelecionado, Rectangle retanguloSelecionado)
        {
            Button[] botoes = { btnDashboard, btnAuditoria, btnFuncionarios, btnEstoque, btnConfiguracoes, btnUsuario, btnFiltrar };
            Rectangle[] retangulos = { retDashboard, retAuditoria, retFuncionarios, retEstoque };


            foreach (Button btn in botoes)
            {
                btn.Opacity = 0;
            }

            foreach (Rectangle ret in retangulos)
            {
                ret.Visibility = Visibility.Hidden;
            }

            if (retanguloSelecionado != null)
            {
                retanguloSelecionado.Visibility = Visibility.Visible;
            }

            botaoSelecionado.Opacity = 0.1;
        }

        public void ShowContent(UserControl userControl)
        {
            grdConteudo.Children.Clear();
            grdConteudo.Children.Add(userControl);
        }

        private void grdPrincipal_Loaded(object sender, RoutedEventArgs e)
        {
            lblNomeUsuario.Content = App.Usuario.NomeUsuario;
        }
    }
}
