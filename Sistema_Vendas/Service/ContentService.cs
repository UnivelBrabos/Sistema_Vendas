using System.Windows.Controls;
using Sistema_Vendas.View;

namespace Sistema_Vendas.Service
{
    public class ContentService
    {
        public UserControl Dashboard { get; set; }
        public UserControl Auditoria { get; set; }
        public UserControl Estoque { get; set; }
        public UserControl Funcionario { get; set; }

        private static ContentService _instance;
        private static readonly object _lock = new();

        public static ContentService Instance
        {
            get
            {
                lock (_lock)
                {
                    return _instance ??= new ContentService();
                }
            }
        }

        public ContentService()
        {
            Dashboard = new DashBoardView();
            Auditoria = new AuditoriaView();
            Estoque = new EstoqueView();
            Funcionario = new FuncionarioView();
        }
    }
}
