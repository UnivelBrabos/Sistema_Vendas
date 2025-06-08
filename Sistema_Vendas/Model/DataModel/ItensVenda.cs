using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Data;
using System.Windows;
using Newtonsoft.Json;

namespace Sistema_Vendas.Model.DataModel
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

        public static Task<List<ItensVenda>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public static async Task<bool> UpdateModel(int Id)
        {
            throw new NotImplementedException();
        }
    }
}