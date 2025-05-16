using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Service;
using System.Data;
using System.Windows.Controls;

namespace Sistema_Vendas.Controller
{
    public class AuditoriaController
    {
        public IAuditoria _Auditoria {  get; set; }

        public AuditoriaController(IAuditoria Auditoria) 
        { 
            _Auditoria = Auditoria;
            _Auditoria.CarregaIDs += SetAuxiliar;
            _Auditoria.CarregaCliente += SetAuxiliar;
            _Auditoria.CarregaVendedor += SetAuxiliar;

        }

        private void SetAuxiliar(object Sender, EventArgs e)
        {
            TextBox? Campo = Sender as TextBox;

            DataGrid Dados = new();

            switch (Campo.Tag)
            {
                case "IdVenda":
                    Dados.ItemsSource = PersistDataService.Instance.lstVendas;
                    Dados.Tag = "Venda";
                    break;
                case "Vendedores:":
                    Dados.ItemsSource = PersistDataService.Instance.lstVendedores;
                    Dados.Tag = "Venda";
                    break;
                case "Clientes":
                    Dados.ItemsSource = PersistDataService.Instance.lstClientes;
                    Dados.Tag = "Venda";
                    break;
            }

            _Auditoria.CarregaTabelaAuxiliar(Dados);
        }
    }
}
