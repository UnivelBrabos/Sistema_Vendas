using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sistema_Vendas.Controller
{
    public class FiltrarController
    {
        private IFiltrar _Filtrar;

        public FiltrarController(IFiltrar Filtrar)
        {
            _Filtrar = Filtrar;

            _Filtrar.eventLoaded += TrataDados;
        }

        private void TrataDados(object sender, EventArgs e)
        {
            _Filtrar.CarregaFiltros(PersistDataService.Instance.lstClientes, PersistDataService.Instance.lstVendedores);
        }
    }
}
