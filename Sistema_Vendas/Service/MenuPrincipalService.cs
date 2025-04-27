using System.Windows.Controls;
using Sistema_Vendas.View;

namespace Sistema_Vendas.Service
{
    public class MenuPrincipalService
    {


        public UserControl MostrarTela(string pUserControl)
        {
            switch (pUserControl)
            {
                case "Dashboard":
                    return new DashBoardView();
                case "Auditoria":
                    return new AuditoriaView();
                default:
                    return null;
            };
        }
    }
}
