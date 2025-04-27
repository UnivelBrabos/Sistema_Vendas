using Sistema_Vendas.Interfaces;
using Sistema_Vendas.View;
using System.Windows.Controls;


namespace Sistema_Vendas.Controller
{
    public class ContentController
    {
        private IMainView _View;

        public ContentController(IMainView view)
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
        }

        private void SetContentEstoque(object? sender, EventArgs e)
        {
           EstoqueView Estoque = new();
            _View.ShowContent(Estoque);
        }

        private void SetContentFuncionarios(object? sender, EventArgs e)
        {
            FuncionarioView Funcionario = new();
            _View.ShowContent(Funcionario);
        }

        private void SetContentAuditoria(object? sender, EventArgs e)
        {
            AuditoriaView Auditoria = new();
            _View.ShowContent(Auditoria);
        }

        public void SetContentDashboard(object sender, EventArgs e)
        {
            DashBoardView Dashboard = new();
            _View.ShowContent(Dashboard);
        }
    }
}
