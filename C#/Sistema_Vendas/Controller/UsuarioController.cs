using Spark.Interfaces;
using Spark.Model.DataModel;
using Spark.Service;

namespace Spark.Controller
{
    public class UsuarioController
    {
        private IUsuario _Usuario;

        public UsuarioController(IUsuario usuario) 
        {
            _Usuario = usuario;
            _Usuario.CarregarDados += CarregaDados;
        }

        private void CarregaDados(object sender, EventArgs e)
        {
            Usuarios usuario = App.Usuario;

            double salario = PersistDataService.Instance.lstVendedores.Where(p => p.IdVendedor == usuario.IdUsuario).FirstOrDefault().Salario;

            _Usuario.AtribuirDados($"{usuario.NomeUsuario};{usuario.Email};{salario};{usuario.CargoUsuario}");
        }
    }
}
