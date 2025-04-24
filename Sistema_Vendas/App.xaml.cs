using Sistema_Vendas.Service;
using System.Windows;
using Sistema_Vendas.View;

namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            ConnectionService _ = ConnectionService.Instance;
            await PersistDataService.Instance.InitAsync();

            var janelaPrincipal = new Login();
            janelaPrincipal.Show();
        }
    }

}
