using Sistema_Vendas.Service;
using System.Windows;
using Sistema_Vendas.View;
using Sistema_Vendas.Controller;
using Sistema_Vendas.Model;

namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static Usuarios? Usuario {  get; set; }

        public static MenuPrincipal? menuPrincipal { get; set; }
        public static ContentController? contentController { get; set; }

        public static DataController? dataController { get; set; }

        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            ConnectionService _ = ConnectionService.Instance;

            menuPrincipal = new();
            contentController = new(menuPrincipal);

            dataController = new();

            // Manter por último
            await PersistDataService.Instance.InitAsync();
        }

        public void SetUsuario(Usuarios pUsuarioLogado)
        {
            Usuario = pUsuarioLogado;
        }
    }

}
