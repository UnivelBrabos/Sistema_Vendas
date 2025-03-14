using Supabase;
using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;
using Sistema_Vendas.Data;
using System.Windows;

namespace Sistema_Vendas.Model
{
    [Table("produtos")]
    public class Produto : BaseModel
    {
        #region :: Atributos ::
        [PrimaryKey("id_produto")]
        public int IdProduto { get; set; }

        [Column("nome")]
        public string Nome { get; set; }

        [Column("descricao")]
        public string Descricao { get; set; }

        [Column("preco")]
        public double Preco { get; set; }

        [Column("estoque")]
        public int Estoque { get; set; }

        [Column("lote")]
        public int Lote { get; set; }
        #endregion :: Atributos ::

        #region :: Construtor ::

        public Produto() { }

        #endregion :: Construtor ::

        #region :: Métodos ::

        public static async Task<List<Produto>> GetProdutos(ConnectionDB pConnection)
        {
            List<Produto> lstProduto = new();

            try
            {
                Client client = await pConnection.GetClient();

                var ModelProdutos = await client.From<Produto>().Get();

                lstProduto = ModelProdutos.Models;

                return lstProduto;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar produtos: {ex.Message}");
                return lstProduto;
            }
        }

        #endregion :: Métodos ::
    }
}