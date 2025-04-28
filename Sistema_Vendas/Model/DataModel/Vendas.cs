using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Data;
using Newtonsoft.Json;
using System.Windows;

namespace Sistema_Vendas.Model.DataModel
{
    public class Vendas : IModel<Vendas>
    {
        #region :: Atributos ::

        [JsonProperty("id_venda")]
        public int IdVenda { get; set; }

        [JsonProperty("id_Vendedor")]
        public int IdVendedor { get; set; }

        [JsonProperty("id_cliente")]
        public int IdCliente { get; set; }

        [JsonProperty("data_venda")]
        public DateTime DataVenda { get; set; }

        [JsonProperty("total")]
        public decimal TotalVenda { get; set; }

        [JsonProperty("desconto")]
        public int Desconto { get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public Vendas() { }

        #endregion << Construtor >>

        public static Task<List<Vendas>> GetModel()
        {
            return App.dataController.GetListGeral<Vendas>("sales", "Vendas");
        }

        public static Task<List<Vendas>> PostModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Vendas>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Vendas>> UpdateModel()
        {
            throw new NotImplementedException();
        }
    }
}