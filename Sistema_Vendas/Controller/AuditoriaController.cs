using Sistema_Vendas.Interfaces;
using System.Data;

namespace Sistema_Vendas.Controller
{
    public class AuditoriaController
    {
        public IAuditoria _Auditoria {  get; set; }

        public AuditoriaController(IAuditoria Auditoria) 
        { 
            _Auditoria = Auditoria;
            _Auditoria.CarregaIDs += SetVendas;
        }

        private void SetVendas(object Sender, EventArgs e)
        {
            DataTable Dados = new();
        }
    }
}
