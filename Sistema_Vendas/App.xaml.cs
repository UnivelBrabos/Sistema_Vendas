using Sistema_Vendas.Service;
using System.Windows;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Model.FilteredModel;

namespace Sistema_Vendas
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static Usuarios? Usuario {  get; set; }
        public static Filtros? Filtro { get; set; }
        public static ConnectionService Connection {  get; set; }
        public static ViewService View {  get; set; }
        public static ControllerService Controller { get; set; }

        protected override async void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            InitServices();

            ViewService.Instance.Splash.Show();

            await PersistDataService.Instance.InitAsync();

            ViewService.Instance.Splash.Close();

            View.Login.Show();
            Filtro = new();
        }

        private void InitServices()
        {
            Connection = ConnectionService.Instance;
            View = ViewService.Instance;
            Controller = ControllerService.Instance;
        }

        public static void SetUsuario(Usuarios pUsuarioLogado)
        {
            Usuario = pUsuarioLogado;
        }

        public static void SetFiltros(Filtros pFiltros)
        {
            Filtro = pFiltros;
        }
    }

}
