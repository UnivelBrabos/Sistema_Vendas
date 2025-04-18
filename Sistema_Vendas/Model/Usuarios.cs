using Sistema_Vendas.Data;
using Supabase;
using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;
using System.Windows;

namespace Sistema_Vendas.Model
{
    [Table("usuarios")]
    public class Usuarios : BaseModel
    {
        #region << Atributos >>

        [PrimaryKey("id_usuario")]
        public int IdUsuario { get; set; }

        [Column("nome")]
        public string? NomeUsuario { get; set; }

        [Column("email")]
        public string? Email { get; set; }

        [Column("senha_hash")]
        public string? SenhaUsuario { get; set; }

        [Column("cargo")]
        public string? CargoUsuario { get; set; }

        [Column("criado_em")]
        public DateTime CriadoEm { get; set; }

        #endregion << Atributos >>

        #region << Construtor >>

        public Usuarios() { }

        #endregion << Construtor >>

        #region << Métodos >>

        public static async Task<List<Usuarios>> GetUsuarios(ConnectionDB pConnection)
        {
            List<Usuarios> lstUsuarios = new();

            try
            {
                Client client = await pConnection.GetClient();

                var ModelUsuarios = await client.From<Usuarios>().Get();

                lstUsuarios = ModelUsuarios.Models;

                return lstUsuarios;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar clientes : {ex.Message}");
                return lstUsuarios;
            }
        }

        #endregion :: Metodos ::
    }
}