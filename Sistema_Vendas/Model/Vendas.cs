using Supabase;
using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;
using Sistema_Vendas.Data;
using System.Windows;

namespace Sistema_Vendas.Model
{
    [Table("vendas")]
    public class Vendas : BaseModel
    {
        #region :: Atributos ::
        [PrimaryKey("id_venda")]
        public int IdVenda {  get; set; }

        [Column("id_Vendedor")]
        public int IdVendedor { get; set; }

        [Column("id_cliente")]
        public int IdCliente { get; set; }

        [Column("data_venda")]
        public DateTime DataVenda {  get; set; }

        [Column("total")]
        public decimal TotalVenda { get; set; }

        [Column("desconto")]
        public int Desconto {  get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public Vendas() { }

        #endregion :: Construtor ::

        #region :: Métodos ::

        public static async Task<List<Vendas>> GetVendas(ConnectionDB pConnect)
        {
            List<Vendas> lstVendas = new();

            try
            {
                Client client = await pConnect.GetClient();

                var ModelVendas = await client.From<Vendas>().Get();

                lstVendas = ModelVendas.Models;

                return lstVendas;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar vendas: {ex.Message}");
                return lstVendas;
            }
        }

        #endregion :: Métodos ::
    }
}