using Sistema_Vendas.Data;
using System.Windows;
using Sistema_Vendas.Interfaces;
using Newtonsoft.Json;

namespace Sistema_Vendas.Model
{
    public class Vendedor : IModel<Vendedor>
    {
        #region :: Atributos ::

        [JsonProperty("id_vendedor")] 
        public int IdVendedor {get; set;}

        [JsonProperty("nome")]
        public string Nome { get; set;}

        [JsonProperty("email")]
        public string Email { get; set;}

        [JsonProperty("telefone")]
        public string Telefone { get; set;}

        [JsonProperty("data_contratacao")]
        public string DataContratacao {  get; set;}

        #endregion :: Atributos ::

        #region :: Construtor ::
        
        public Vendedor() { }

        #endregion :: Construtor ::

        #region :: Métodos ::

        public static Task<List<Vendedor>> GetModel()
        {
            return App.dataController.GetListGeral<Vendedor>("sellers", "Vendedores");
        }

        public static Task<List<Vendedor>> PostModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Vendedor>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Vendedor>> UpdateModel()
        {
            throw new NotImplementedException();
        }

        #endregion :: Métodos ::
    }
}