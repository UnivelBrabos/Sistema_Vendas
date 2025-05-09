using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Model.FilteredModel;

namespace Sistema_Vendas.Interfaces
{
    public interface IFiltrar
    {
        event EventHandler eventLoaded;
        event EventHandler eventFiltrar;

        Filtros Filtros { get; set; }

        void CarregaFiltros(List<Cliente> pClientes, List<Vendedor> pVendedores);
    }
}
