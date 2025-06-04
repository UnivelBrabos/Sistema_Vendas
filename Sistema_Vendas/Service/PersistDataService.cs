using Sistema_Vendas.Model.DataModel;
namespace Sistema_Vendas.Service
{
    public class PersistDataService
    {
        #region :: Dados :: 
        public List<ItensVenda> lstItensVenda { get; private set; }
        public List<Vendedor> lstVendedores { get; private set; }
        public List<Produto> lstProdutos { get; private set; }
        public List<Cliente> lstClientes { get; private set; }
        public List<Vendas> lstVendas { get; private set; }
        public List<Usuarios> lstUsuarios { get; private set; }
        #endregion :: Dados :: 

        private static PersistDataService _instance;
        private static readonly object _lock = new();

        public static PersistDataService Instance
        {
            get
            {
                lock (_lock)
                {
                    return _instance ??= new PersistDataService();
                }
            }
        }

        private PersistDataService() { }

        public async Task InitAsync(bool Startup = true)
        {
            if (Startup)
            {
                lstUsuarios = await Usuarios.GetModel();
            }
            else
            {
                lstVendas = await Vendas.GetModel();
                lstProdutos = await Produto.GetModel();
                lstClientes = await Cliente.GetModel();
                lstVendedores = await Vendedor.GetModel();
                lstItensVenda = await ItensVenda.GetModel();
            }
        }
    }

}
