using System.Windows.Shapes;
using System.Windows.Controls;

namespace Sistema_Vendas.Interfaces
{
    public interface IMainView
    {
        event EventHandler eventDashboard;
        event EventHandler eventAuditoria;
        event EventHandler eventFuncionarios;
        event EventHandler eventEstoque;

        void ShowContent(UserControl userControl);

        void DestacarBotao(Button botaoSelecionado, Rectangle retanguloSelecionado );
    }
}
