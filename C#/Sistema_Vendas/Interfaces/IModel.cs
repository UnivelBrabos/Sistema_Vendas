using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Spark.Interfaces
{
    public interface IModel<T>
    {
        abstract static Task<List<T>> GetModel();
        abstract static Task<List<T>> PostModel();
        abstract Task<bool> DeleteModel();
        abstract Task<bool> UpdateModel();
    }
}
