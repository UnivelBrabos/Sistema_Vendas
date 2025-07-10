using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Spark.Interfaces
{
    public interface ILogin
    {
        event EventHandler eventValidaDados;

        string Usuario { get; set; }
        string Senha { get; set; }

        void Logar();
    }
}
