using Supabase;
using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;
using Sistema_Vendas.Data;
using System.Windows;

namespace Sistema_Vendas.Model
{
    [Table("itens_venda")]
    public class ItensVenda : BaseModel
    {
        #region :: Atributos ::
        [PrimaryKey("id_itens")]
        public int IdItens { get; set; }

        [Column("id_venda")]
        public int IdVenda { get; set; }

        [Column("id_produto")]
        public int IdProduto { get; set; }

        [Column("quantidade_lote")]
        public int QuantidadeLote { get; set; }

        [Column("sub_total")]
        public double SubTotal {  get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public ItensVenda() { }

        #endregion :: Construtor ::

        #region :: Métodos ::

        public static async Task<List<ItensVenda>> GetItensVenda(ConnectionDB pConnect)
        {
            List<ItensVenda> lstItensVenda = new();

            try
            {
                Client client = await pConnect.GetClient();
                var ModelItensVenda = await client.From<ItensVenda>().Get();

                lstItensVenda = ModelItensVenda.Models;

                return lstItensVenda;

            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar Itens venda: {ex.Message}");
                return lstItensVenda;
            }
        }

        #endregion :: Métodos ::
    }
}