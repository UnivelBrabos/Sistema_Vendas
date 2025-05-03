using Sistema_Vendas.Service;
using System.Windows;
using Sistema_Vendas.View;
using Sistema_Vendas.Controller;
using Sistema_Vendas.Model.DataModel;

namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static Usuarios? Usuario {  get; set; }

        public static ConnectionService Connection {  get; set; }
        public static ContentService Content { get; set; }
        public static ViewService View {  get; set; }
        public static ControllerService Controller { get; set; }

        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            InitServices();

            // Manter por último
            await PersistDataService.Instance.InitAsync();
        }

        private void InitServices()
        {
            Connection = ConnectionService.Instance;
            Content = ContentService.Instance;
            View = ViewService.Instance;
            Controller = ControllerService.Instance;
        }

        public static void SetUsuario(Usuarios pUsuarioLogado)
        {
            Usuario = pUsuarioLogado;
        }
    }

}
