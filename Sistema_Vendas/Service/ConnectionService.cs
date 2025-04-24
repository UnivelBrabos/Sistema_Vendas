using Sistema_Vendas.Data;

namespace Sistema_Vendas.Service
{
    public class ConnectionService
    {
        private static ConnectionService _instance;
        private static readonly object _lock = new();

        public ConnectionDB ConnectionDB { get; private set; }

        public static ConnectionService Instance
        {
            get
            {
                if (_instance == null)
                {
                    lock (_lock)
                    {
                        if (_instance == null)
                        {
                            _instance = new ConnectionService();
                        }
                    }
                }

                return _instance;
            }
        }

        private ConnectionService()
        {
            ConnectionDB = new ConnectionDB();
        }
    }
}
