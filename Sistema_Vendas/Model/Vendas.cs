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
        public string DataVenda {  get; set; }

        [Column("total")]
        public decimal TotalVenda { get; set; }

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

/*
 create table public.vendas (
  id serial not null,
  id_vendedor integer not null,
  id_cliente integer not null,
  data_venda timestamp without time zone null default CURRENT_TIMESTAMP,
  total numeric(10, 2) not null,
  constraint vendas_pkey primary key (id),
  constraint vendas_id_cliente_fkey foreign KEY (id_cliente) references clientes (id) on delete CASCADE,
  constraint vendas_id_vendedor_fkey foreign KEY (id_vendedor) references vendedores (id_vendedor) on delete CASCADE,
  constraint vendas_total_check check ((total >= (0)::numeric))
) TABLESPACE pg_default;
 */