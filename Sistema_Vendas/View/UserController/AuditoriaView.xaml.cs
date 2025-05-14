using Sistema_Vendas.Interfaces;
using Sistema_Vendas.Model.DataModel;
using System;
using System.Collections.Generic;
using System.Data;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Sistema_Vendas.View
{
    /// <summary>
    /// Interação lógica para AuditoriaView.xam
    /// </summary>
    public partial class AuditoriaView : UserControl, IAuditoria
    {
        public Vendas Venda { get; set; }

        public AuditoriaView()
        {
            InitializeComponent();

            LoadEvents();
        }


        public event EventHandler CarregaIDs;

        public void CarregaTabelaAuxiliar(DataTable dttVendas)
        {
            
        }

        private void LoadEvents()
        {
            txtIdVenda.GotFocus += (s, e) => CarregaIDs?.Invoke(this, EventArgs.Empty);
        }

        private void txtIdVenda_PreviewTextInput(object sender, System.Windows.Input.TextCompositionEventArgs e)
        {
            e.Handled = !int.TryParse(e.Text, out _);
        }
    }
}
