using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Data;
using Newtonsoft.Json;
using System.Windows;

namespace Sistema_Vendas.Model.DataModel
{
    public class Usuarios : IModel<Usuarios>
    {
        #region << Atributos >>

        [JsonProperty("id_usuario")]
        public int IdUsuario { get; set; }

        [JsonProperty("nome")]
        public string? NomeUsuario { get; set; }

        [JsonProperty("email")]
        public string? Email { get; set; }

        [JsonProperty("senha_hash")]
        public string? SenhaUsuario { get; set; }

        [JsonProperty("cargo")]
        public string? CargoUsuario { get; set; }

        [JsonProperty("criado_em")]
        public DateTime CriadoEm { get; set; }

        #endregion << Atributos >>

        #region << Construtor >>

        public Usuarios() { }

        #endregion << Construtor >>

        public static Task<List<Usuarios>> GetModel()
        {
            return App.Controller.Data.GetListGeral<Usuarios>("users", "Usuários");
        }

        public static Task<List<Usuarios>> PostModel()
        {
            throw new NotImplementedException();
        }

        public static Task<List<Usuarios>> DeleteModel()
        {
            throw new NotImplementedException();
        }

        public static async Task<bool> UpdateModel(int Id)
        {
            throw new NotImplementedException();
        }
    }
}