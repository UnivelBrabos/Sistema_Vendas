using Spark.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Spark.Controller
{
    public class SplashController
    {
        ISplash _Splash;

        public SplashController(ISplash Splash)
        {
            _Splash = Splash;
        }
    }
}
