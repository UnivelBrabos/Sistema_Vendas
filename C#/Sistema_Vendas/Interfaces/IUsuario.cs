using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Spark.Interfaces
{
    public interface IUsuario
    {
        event EventHandler CarregarDados;

        void AtribuirDados(string pDados);
    }
}
