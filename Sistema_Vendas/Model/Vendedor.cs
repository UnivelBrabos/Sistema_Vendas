using Supabase;
using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;
using Sistema_Vendas.Data;
using System.Windows;

namespace Sistema_Vendas.Model
{
    [Table("vendedores")]
    public class Vendedor : BaseModel
    {
        #region :: Atributos ::

        [PrimaryKey("id_vendedor")] 
        public int IdVendedor {get; set;}

        [Column("nome")]
        public string Nome { get; set;}

        [Column("email")]
        public string Email { get; set;}

        [Column("telefone")]
        public string Telefone { get; set;}

        [Column("data_contratacao")]
        public string DataContratacao {  get; set;}

        #endregion :: Atributos ::

        #region :: Construtor ::
        
        public Vendedor() { }

        #endregion :: Construtor ::

        #region :: Métodos ::

        public static async Task<List<Vendedor>> GetVendedores(ConnectionDB pConnect)
        {

            List<Vendedor> lstVendedores = new();

            try
            {
                Client client = await pConnect.GetClient();
                
                var ModelVendedores = await client.From<Vendedor>().Get();

                lstVendedores = ModelVendedores.Models;

                return lstVendedores;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar vendedores: {ex.Message}");
                return lstVendedores;
            }
        }

        #endregion :: Métodos ::
    }
}