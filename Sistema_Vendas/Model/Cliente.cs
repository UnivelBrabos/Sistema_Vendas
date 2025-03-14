using Supabase;
using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;
using Sistema_Vendas.Data;
using System.Windows;

namespace Sistema_Vendas.Model
{
    [Table("clientes")]
    public class Cliente : BaseModel
    {
        #region :: Atributos ::

        [PrimaryKey("id_cliente")]
        public int IdCliente { get; set; }

        [Column("nome")]
        public string Nome { get; set; }

        [Column("CNPJ")]
        public string CNPJ {  get; set; }

        [Column("telefone")]
        public string Telefone { get; set; }

        [Column("endereco")]
        public string Endereco { get; set; }

        #endregion :: Atributos ::

        #region :: Construtor ::

        public Cliente() { }

        #endregion :: Construtor ::

        #region :: Metodos ::

        public static async Task<List<Cliente>> GetClientes(ConnectionDB pConnection)
        {
            List<Cliente> lstClientes = new();

            try
            {
                Client client = await pConnection.GetClient();

                var ModelCliente = await client.From<Cliente>().Get();

                lstClientes = ModelCliente.Models;

                return lstClientes;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Erro ao buscar clientes : {ex.Message}");
                return lstClientes;
            }
        }

        #endregion :: Metodos ::
    }
}

/*
 create table public.clientes (
  id serial not null,
  nome character varying(100) not null,
  "CNPJ" character varying(100) null,
  telefone character varying(15) null,
  endereco text null,
  constraint clientes_pkey primary key (id),
  constraint clientes_email_key unique ("CNPJ")
) TABLESPACE pg_default;
 
 */