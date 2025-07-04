using Sistema_Vendas.Interfaces;
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
            return App.Controller.Data.GetListGeral<Vendas>("sales", "Vendas");
        }

        public static Task<List<Vendas>> PostModel()
        {
            throw new NotImplementedException();
        }

        public async Task<bool> DeleteModel()
        {
            return await App.Controller.Data.DeleteItem("sales", IdVendedor.ToString());
        }

        public async Task<bool> UpdateModel()
        {
            return await App.Controller.Data.UpdateItem("sales", IdVendedor.ToString(), JsonConvert.SerializeObject(this));
        }
    }
}