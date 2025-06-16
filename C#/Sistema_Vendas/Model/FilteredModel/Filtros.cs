using Sistema_Vendas.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sistema_Vendas.Model.FilteredModel
{
    public class Filtros
    {
        public DateTime Inicial { get; set; }
        public DateTime Final { get; set; }

        public List<int> IdVendedores { get; set; }
        public List<int> IdClientes { get; set; }

        public Filtros(DateTime Inicial, DateTime Final, List<int> IdVendedores, List<int> IdClientes)
        {
            this.Inicial = Inicial;
            this.Final = Final;
            this.IdVendedores = IdVendedores;
            this.IdClientes = IdClientes;
        }

        public Filtros()
        {
            Inicial = new DateTime(DateTime.Now.Year, 1, 1);
            Final = DateTime.Now;

            IdVendedores = PersistDataService.Instance.lstVendas.Select(p => p.IdVendedor).ToList();
            IdClientes = PersistDataService.Instance.lstClientes.Select(p => p.IdCliente).ToList(); 
        }
    }
}
