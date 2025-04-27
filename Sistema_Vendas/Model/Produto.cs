using Newtonsoft.Json;
using Sistema_Vendas.Data;
using Sistema_Vendas.Interfaces;
using System.Windows;

namespace Sistema_Vendas.Model
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
            return App.dataController.GetListGeral<Produto>("product", "produtos");
        }

        public static Task<List<Produto>> PostModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Produto>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Produto>> UpdateModel()
        {
            throw new NotImplementedException();
        }



    }
}