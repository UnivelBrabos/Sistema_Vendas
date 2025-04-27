using Sistema_Vendas.Model;
using System.Net.Http;
using System.Security.Policy;
using System.Text;

namespace Sistema_Vendas.Data
{
    public class ApiConnect
    {
        List<Cliente> lstClientes;

        public ApiConnect()
        {
        }

        public async Task<List<Cliente>> GetClientes()
        {
            using (HttpClient client = new HttpClient())
            {
                string strUrl = "http://localhost:8000/sales/post";

                string json = "{\"id_vendedor\": 7,\"id_cliente\": 7,\"total\": 2524.5,\"data_venda\": \"2025-04-26T00:28:49.406780\",\"desconto\": 0}";

                HttpContent content = new StringContent(json, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await client.PostAsync(strUrl, content);

                string teste = await response.Content.ReadAsStringAsync();
            }

            return null;
        }
    }
}
