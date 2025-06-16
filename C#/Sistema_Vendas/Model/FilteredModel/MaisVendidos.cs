using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sistema_Vendas.Model.FilteredModel
{
    public class MaisVendidos
    {
        public string Produto { get; set; }

        public int TotalVendido { get; set; }

        public IEnumerable<int> IdentificadorVenda { get; set; }

    }
}
