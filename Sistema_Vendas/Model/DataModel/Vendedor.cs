using Sistema_Vendas.Interfaces;
using Newtonsoft.Json;

namespace Sistema_Vendas.Model.DataModel
{
    public class Vendedor : IModel<Vendedor>
    {
        #region :: Atributos ::

        [JsonProperty("id_vendedor")]
        public int IdVendedor { get; set; }

        [JsonProperty("nome")]
        public string Nome { get; set; }

        [JsonProperty("email")]
        public string Email { get; set; }

        [JsonProperty("telefone")]
        public string Telefone { get; set; }

        [JsonProperty("data_contratacao")]
        public string DataContratacao { get; set; }

        [JsonProperty("salario")]
        public double Salario { get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public Vendedor() { }

        #endregion :: Construtor ::

        #region :: Métodos ::

        public static Task<List<Vendedor>> GetModel()
        {
            return App.Controller.Data.GetListGeral<Vendedor>("sellers", "Vendedores");
        }

        public static Task<List<Vendedor>> PostModel()
        {
            throw new NotImplementedException();
        }

        public async Task<bool> DeleteModel()
        {
            return await App.Controller.Data.DeleteItem("sellers", this.IdVendedor.ToString());
        }

        public async Task<bool> UpdateModel()
        {
            return await App.Controller.Data.UpdateItem("sellers", this.IdVendedor.ToString(), JsonConvert.SerializeObject(this));
        }

        #endregion :: Métodos ::
    }
}