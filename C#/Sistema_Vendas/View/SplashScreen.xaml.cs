using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace Spark.View
{
    /// <summary>
    /// Lógica interna para SplashScreen.xaml
    /// </summary>
    public partial class SplashScreen : Window
    {
        public SplashScreen()
        {
            InitializeComponent();

            string caminhoCompleto = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Midia", "SplashScreen.wmv");
            SplashScreenElement.Source = new Uri(caminhoCompleto, UriKind.Absolute);
            SplashScreenElement.Play();
        }


        private void meuVideo_MediaEnded(object sender, RoutedEventArgs e)
        {
            SplashScreenElement.Position = TimeSpan.Zero;
            SplashScreenElement.Play();
        }
    }
}
