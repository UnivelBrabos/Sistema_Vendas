using Sistema_Vendas.Controller;

namespace Sistema_Vendas.Service
{
    public class ControllerService
    {
        #region :: Controllers ::
        public AuditoriaController Auditoria {  get; set; }
        public DashboardController Dashboard { get; set; }
        public PrincipalController Principal { get; set; }
        public DataController Data { get; set; }
        public LoginController Login { get; set; }

        #endregion :: Controllers ::    

        private static ControllerService _instance;
        private static readonly object _lock = new();

        public static ControllerService Instance
        {
            get
            {
                lock (_lock)
                {
                    return _instance ??= new();
                }
            }
        }

        public ControllerService()
        {
            Auditoria = new();
            Dashboard = new(App.View.Dashboard);
            Principal = new(App.View.Principal);
            Login = new(App.View.Login);
            Data = new();
        }
    }
}
