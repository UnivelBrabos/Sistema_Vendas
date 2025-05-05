using Sistema_Vendas.Interfaces;
using Sistema_Vendas.View;
using System.Windows.Controls;
using Sistema_Vendas.View.UserController;


namespace Sistema_Vendas.Controller
{
    public class PrincipalController
    {
        private IMainView _View;

        public PrincipalController(IMainView view)
        {
            _View = view;
            SetEventControl();
        }

        private void SetEventControl()
        {
            _View.eventDashboard += SetContentDashboard;
            _View.eventAuditoria += SetContentAuditoria;
            _View.eventFuncionarios += SetContentFuncionarios;
            _View.eventEstoque += SetContentEstoque;
            _View.eventFiltrar += SetContentFiltrar;
        }

        private void SetContentFiltrar(object? sender, EventArgs e)
        {
            FiltrarView Filtrar = App.View.Filtrar;
            _View.ShowContent(Filtrar, 6);
        }

        private void SetContentEstoque(object? sender, EventArgs e)
        {
           EstoqueView Estoque = App.View.Estoque;
            _View.ShowContent(Estoque, 3);
        }

        private void SetContentFuncionarios(object? sender, EventArgs e)
        {
            FuncionarioView Funcionario = App.View.Funcionario;
            _View.ShowContent(Funcionario, 2);
        }

        private void SetContentAuditoria(object? sender, EventArgs e)
        {
            AuditoriaView Auditoria = App.View.Auditoria;
            _View.ShowContent(Auditoria, 1);
        }

        public void SetContentDashboard(object sender, EventArgs e)
        {
            DashBoardView Dashboard = App.View.Dashboard;
            _View.ShowContent(Dashboard, 0);
        }
    }
}
