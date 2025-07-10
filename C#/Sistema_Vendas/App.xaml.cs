using Spark.Service;
using System.Windows;
using Spark.Model.DataModel;
using Spark.Model.FilteredModel;

namespace Spark
{
    /// <summary>
    /// Interaction logic for App.xaml.
    /// </summary>
    public partial class App : Application
    {
        public static Usuarios? Usuario {  get; set; }
        public static Filtros? Filtro { get; set; }
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

            await PersistDataService.Instance.InitAsync(false);

            Filtro = new();
        }

        private void InitServices()
        {
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
