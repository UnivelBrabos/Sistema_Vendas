using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IMainView
    {
        event EventHandler eventDashboard;
        event EventHandler eventAuditoria;
        event EventHandler eventFuncionarios;
        event EventHandler eventEstoque;

        void ShowContent(UserControl userControl, int pIndex);

        void DestacarBotao(int pIndex);
    }
}
