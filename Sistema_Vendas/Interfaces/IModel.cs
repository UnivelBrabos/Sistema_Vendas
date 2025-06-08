using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sistema_Vendas.Interfaces
{
    public interface IModel<T>
    {
        abstract static Task<List<T>> GetModel();
        abstract static Task<List<T>> PostModel();
        abstract static Task<List<T>> DeleteModel();
        abstract static Task<bool> UpdateModel(int Id);
    }
}
