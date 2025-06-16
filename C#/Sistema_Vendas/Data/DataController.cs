using Newtonsoft.Json;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Service;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Windows;

namespace Sistema_Vendas.Controller
{
    public class DataController
    {
        private static string localHost = "http://localhost:8000";

        public DataController()
        {
        }

        public async Task<List<T>> GetListGeral<T>(string pEndPoint, string pSubElemento)
        {
            try
            {
                string strJson = await SendGetRequest($"{pEndPoint}");

                if (strJson.StartsWith("Retorno"))
                {
                    throw new Exception(strJson);
                }

                List<T> lstModel = JsonConvert.DeserializeObject<List<T>>(strJson);

                return lstModel;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar {pEndPoint}: {ex.Message}");
                return new List<T>();
            }
        }

        private static async Task<string> SendGetRequest(string pEndPoint)
        {
            string strUrl = $"{localHost}/{pEndPoint}/get_all";

            using (HttpClient client = new HttpClient())
            {
                HttpResponseMessage objResponse = await client.GetAsync(strUrl);

                if (objResponse.IsSuccessStatusCode)
                {
                    return await objResponse.Content.ReadAsStringAsync();
                }

                return $"Retorno {objResponse.StatusCode}";
            }
        }

        public async Task<bool> UpdateItem(string pItemClass, string pId, string pJson)
        {
            string strUrl = $"{localHost}/{pItemClass}/put/{pId}";

            using (HttpClient client = new HttpClient())
            {
                var content = new StringContent(pJson, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await client.PutAsync(strUrl, content);

                return response.IsSuccessStatusCode;
            }
        }

        public async Task<bool> DeleteItem(string pItemClass, string pId)
        {
            string strUrl = $"{localHost}/{pItemClass}/delete/{pId}";

            using (HttpClient client = new HttpClient())
            {
                HttpResponseMessage objResponse = await client.DeleteAsync(strUrl);

                return objResponse.IsSuccessStatusCode;
            }
        }
    }
}
