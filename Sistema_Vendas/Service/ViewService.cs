using Sistema_Vendas.View;

namespace Sistema_Vendas.Service
{
    public class ViewService
    {
        #region :: Views ::
        public AuditoriaView Auditoria { get; set; }
        public DashBoardView Dashboard { get; set; }
        public EstoqueView Estoque { get; set; }
        public FuncionarioView Funcionario { get; set; }
        public MenuPrincipal Principal { get; set; }
        #endregion :: Views ::

        private static ViewService _instance;
        private static readonly object _lock = new();

        public static ViewService Instance
        {
            get
            {
                lock (_lock)
                {
                    return _instance ??= new ViewService();
                }
            }
        }

        public ViewService()
        {
            Dashboard = new();
            Auditoria = new();
            Estoque = new();
            Funcionario = new();
            Principal = new();
        }

    }
}
