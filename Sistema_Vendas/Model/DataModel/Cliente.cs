using Sistema_Vendas.Data;
using System.Windows;
using Sistema_Vendas.Interfaces;
using Newtonsoft.Json;

namespace Sistema_Vendas.Model.DataModel
{
    public class Cliente : IModel<Cliente>
    {
        #region :: Atributos ::

        [JsonProperty("id_cliente")]
        public int IdCliente { get; set; }

        [JsonProperty("nome")]
        public string Nome { get; set; }

        [JsonProperty("cnpj")]
        public string CNPJ { get; set; }

        [JsonProperty("telefone")]
        public string Telefone { get; set; }

        [JsonProperty("endereco")]
        public string Endereco { get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public Cliente() { }

        #endregion :: Construtor ::

        #region :: Metodos ::

        public static async Task<List<Cliente>> GetModel()
        {
            return await App.Controller.Data.GetListGeral<Cliente>("client", "Clientes");
        }

        public static async Task<List<Cliente>> PostModel()
        {
            throw new NotImplementedException();
        }

        public static async Task<List<Cliente>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public static async Task<List<Cliente>> UpdateModel()
        {
            throw new NotImplementedException();
        }

        #endregion :: Metodos ::
    }
}