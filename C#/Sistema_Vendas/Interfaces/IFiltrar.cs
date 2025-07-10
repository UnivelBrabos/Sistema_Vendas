using Spark.Model.DataModel;
using Spark.Model.FilteredModel;

namespace Spark.Interfaces
{
    public interface IFiltrar
    {
        event EventHandler eventLoaded;
        event EventHandler eventFiltrar;

        Filtros Filtros { get; set; }

        void CarregaFiltros(List<Cliente> pClientes, List<Vendedor> pVendedores);
    }
}
