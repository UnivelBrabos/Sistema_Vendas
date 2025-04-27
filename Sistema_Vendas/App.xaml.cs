using Sistema_Vendas.Service;
using System.Windows;
using Sistema_Vendas.View;
using Sistema_Vendas.Controller;

namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static MenuPrincipal? menuPrincipal { get; set; }
        public static ContentController? contentController { get; set; }

        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            ConnectionService _ = ConnectionService.Instance;
            await PersistDataService.Instance.InitAsync();

            menuPrincipal = new();
            contentController = new(menuPrincipal);
        }
    }

}
