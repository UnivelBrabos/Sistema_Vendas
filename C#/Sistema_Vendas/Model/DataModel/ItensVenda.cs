using Spark.Interfaces;
using System.Windows;
using Newtonsoft.Json;

namespace Spark.Model.DataModel
{
    public class ItensVenda : IModel<ItensVenda>
    {
        #region :: Atributos ::
        [JsonProperty("id_itens")]
        public int IdItens { get; set; }

        [JsonProperty("id_venda")]
        public int IdVenda { get; set; }

        [JsonProperty("id_produto")]
        public int IdProduto { get; set; }

        [JsonProperty("quantidade_lote")]
        public int QuantidadeLote { get; set; }

        [JsonProperty("sub_total")]
        public double SubTotal { get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public ItensVenda() { }

        #endregion :: Construtor ::

        public static Task<List<ItensVenda>> GetModel()
        {
            return App.Controller.Data.GetListGeral<ItensVenda>("sales_items", "Vendas de itens");
        }

        public static Task<List<ItensVenda>> PostModel()
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
    }
}