using Supabase;

namespace Sistema_Vendas.Data
{
    public class ConnectionDB
    {
        private Supabase.Client _client;

        string supabaseUrl = "https://zwxauvbgkpnaaqjjvmqm.supabase.co";
        string supabaseKey = " eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3eGF1dmJna3BuYWFxamp2bXFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEzMDUyNjgsImV4cCI6MjA1Njg4MTI2OH0.oI2jW3NWcjBHzmrFoMWCm1LU5RVKyQ0D-3dEbzihPLA";

        public ConnectionDB()
        {
            _client = new Supabase.Client(supabaseUrl, supabaseKey);
        }

        public async Task<Client> GetClient()
        {
            if (_client == null)
            {
                _client = new Client(supabaseUrl, supabaseKey);
                await _client.InitializeAsync();
            }
            return _client;
        }

        public async Task ConnectAsync()
        {
            await _client.InitializeAsync();
        }
    }
}
