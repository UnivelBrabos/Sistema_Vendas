using System.Windows;
using Spark.Interfaces;
using Newtonsoft.Json;

namespace Spark.Model.DataModel
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
            return await App.Controller.Data.GetListGeral<Cliente>("clients", "Clientes");
        }

        public static async Task<List<Cliente>> PostModel()
        {
            throw new NotImplementedException();
        }

        public async Task<bool> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public async Task<bool> UpdateModel()
        {
            throw new NotImplementedException();
        }

        #endregion :: Metodos ::
    }
}