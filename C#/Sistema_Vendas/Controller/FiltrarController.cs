using Spark.Interfaces;
using Spark.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Spark.Controller
{
    public class FiltrarController
    {
        private IFiltrar _Filtrar;

        public FiltrarController(IFiltrar Filtrar)
        {
            _Filtrar = Filtrar;

            _Filtrar.eventLoaded += TrataDados;
            _Filtrar.eventFiltrar += SetFiltros;
        }

        private void TrataDados(object sender, EventArgs e)
        {
            _Filtrar.CarregaFiltros(PersistDataService.Instance.lstClientes, PersistDataService.Instance.lstVendedores);
        }

        private void SetFiltros(object sender, EventArgs e)
        {
            App.SetFiltros(_Filtrar.Filtros);
            MessageBox.Show("Filtro Aplicado com sucesso!");
        }
    }
}
