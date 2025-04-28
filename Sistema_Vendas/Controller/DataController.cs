using Newtonsoft.Json;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Service;
using System.Net.Http;
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

        public bool LogarUsuario(string pUserName, string pSenha)
        {
            try
            {
                Usuarios objUsuario = PersistDataService.Instance.lstUsuarios.Where(p => (p.NomeUsuario == pUserName || p.Email == pUserName) && p.SenhaUsuario == pSenha).First();

                if (objUsuario != null)
                {
                    App.SetUsuario(objUsuario);
                    App.menuPrincipal.Show();
                    return true;
                }
            }
            catch (Exception)
            {
                MessageBox.Show("Usuario/Email ou senha incorretos!");
            }

            return false;
        }

        public async Task<List<T>> GetListGeral<T>(string pEndPoint, string pSubElemento)
        {
            try
            {
                string strJson = await SendGetRequest(pEndPoint);

                if (strJson.StartsWith("Retorno"))
                {
                    throw new Exception(strJson);
                }

                if (!TrataJson(ref strJson, pSubElemento))
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
            string strUrl = $"{localHost}/{pEndPoint}/get";

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

        private static bool TrataJson(ref string pJson, string pPropriedade)
        {
            try
            {
                using (JsonDocument doc = JsonDocument.Parse(pJson))
                {
                    JsonElement root = doc.RootElement;

                    if (root.TryGetProperty(pPropriedade, out JsonElement clientesElement) &&
                        clientesElement.TryGetProperty("data", out JsonElement dataElement))
                    {
                        pJson = dataElement.GetRawText();
                        return true;
                    }

                    throw new Exception("SubElemento não encontrado");
                }
            }
            catch (Exception ex)
            {
                pJson = ex.Message;
                return false;
            }
        }
    }
}
