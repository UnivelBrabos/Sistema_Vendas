using Newtonsoft.Json;
using Sistema_Vendas.Interfaces;

namespace Sistema_Vendas.Model.DataModel
{
    public class Produto : IModel<Produto>
    {
        #region :: Atributos ::
        [JsonProperty("id_produto")]
        public int IdProduto { get; set; }

        [JsonProperty("nome")]
        public string Nome { get; set; }

        [JsonProperty("descricao")]
        public string Descricao { get; set; }

        [JsonProperty("preco")]
        public double Preco { get; set; }

        [JsonProperty("estoque")]
        public int Estoque { get; set; }

        [JsonProperty("lote")]
        public int Lote { get; set; }
        #endregion :: Atributos ::

        #region :: Construtor ::

        public Produto() { }

        #endregion :: Construtor ::

        public static Task<List<Produto>> GetModel()
        {
            return App.Controller.Data.GetListGeral<Produto>("products", "produtos");
        }

        public static Task<List<Produto>> PostModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Produto>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public async Task<bool> UpdateModel()
        {
            return await App.Controller.Data.UpdateItem("products", this.IdProduto.ToString(), JsonConvert.SerializeObject(this));
        }
    }
}