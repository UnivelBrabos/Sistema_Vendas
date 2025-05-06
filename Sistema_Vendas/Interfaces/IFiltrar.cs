using Sistema_Vendas.Model.DataModel;

namespace Sistema_Vendas.Interfaces
{
    public interface IFiltrar
    {
        event EventHandler eventLoaded;

        void CarregaFiltros(List<Cliente> pClientes, List<Vendedor> pVendedores);
    }
}
