using LiveCharts;
using LiveCharts.Wpf;
using Sistema_Vendas.Controller;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.FilteredModel;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;


namespace Sistema_Vendas
{
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        private ObservableCollection<CheckBoxOptions> _itemscCheckBox;

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private readonly ConnectionDB objConnect;

        private GraficosController GraficosController;

        public ObservableCollection<CheckBoxOptions> ItemscCheckBox
        {
            get { return _itemscCheckBox; }
            set
            {
                _itemscCheckBox = value;
                OnPropertyChanged(nameof(ItemscCheckBox));
            }
        }

        public List<ItensVenda> lstItensVenda;
        public List<Vendedor> lstVendedores;
        public List<Produto> lstProdutos;
        public List<Cliente> lstClientes;
        public List<Vendas> lstVendas;

        public MainWindow()
        {
            InitializeComponent();
            DataContext = this;
            objConnect = new ConnectionDB(); // Inicializa a conexão junto ao sistema

            CarregaDados();

            dtpFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            dtpInicial.Text = "01/01/2025";

            GraficosController = new(this);

        }

        public void CarregaCheckBox()
        {
            if (lstVendedores == null || lstVendedores.Count == 0)
            {
                MessageBox.Show("Nenhum vendedor encontrado.");
                return;
            }

            if (ItemscCheckBox == null) // Inicializa apenas se for nula
                ItemscCheckBox = new ObservableCollection<CheckBoxOptions>();

            ItemscCheckBox.Clear(); // Limpa os itens antes de adicionar novos

            foreach (var vendedor in lstVendedores)
            {
                ItemscCheckBox.Add(new CheckBoxOptions { Name = vendedor.Nome, Id = vendedor.IdVendedor, IsSelected = true });
            }

            OnPropertyChanged(nameof(ItemscCheckBox));
        }

        public async void CarregaDados()
        {
            lstVendedores = await Vendedor.GetVendedores(objConnect);

            lstVendas = await Vendas.GetVendas(objConnect);

            lstProdutos = await Produto.GetProdutos(objConnect);

            lstClientes = await Cliente.GetClientes(objConnect);

            lstItensVenda = await ItensVenda.GetItensVenda(objConnect);

            CarregaGrafico();

            CarregaCheckBox();
        }

        #region :: Carregamento dos gráficos ::
        public void CarregaGrafico(bool filtrar = false)
        {
            List<int> lstVendedoresId = new();
            
            if(ItemscCheckBox != null)
            {
                lstVendedoresId = ItemscCheckBox
                    .Where(v => v.IsSelected)
                    .Select(v => v.Id)
                    .ToList();
            }

            List<int> lstClientesId = lstClientes.Select(p => p.IdCliente).ToList();

            Filtros objFiltros = new(Convert.ToDateTime(dtpInicial.Text), Convert.ToDateTime(dtpFinal.Text), lstVendedoresId, lstClientesId);

            Graficos(filtrar, objFiltros);
        }

        public void Graficos(bool pFiltrar, Filtros pFiltros)
        {
            string strMensagem;

            if(!GraficosController.MaisVendidos(ref ProdutosCharControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.ParticipacaoLucros(ref VendedoresChartControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.VendasMensais(ref VendasCharControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }

            if (!GraficosController.MelhoresClientes(ref ClientesChartControl, pFiltrar, pFiltros, out strMensagem))
            {
                MessageBox.Show(strMensagem);
            }
        }

        #endregion :: Carregamento dos gráficos ::

        #region :: Eventos ::

        private void btnFiltrar_Click(object sender, RoutedEventArgs e)
        {
            CarregaGrafico(true);
        }

        private void btnLimpar_Click(object sender, RoutedEventArgs e)
        {
            CarregaGrafico();
            dtpInicial.Text = "01/01/2025";
            dtpFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        }

        private void dtpInicial_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            dtpFinal.DisplayDateStart = Convert.ToDateTime(dtpInicial.Text);

            if (Convert.ToDateTime(dtpInicial.Text) > Convert.ToDateTime(dtpFinal.Text))
            {
                dtpFinal.Text = dtpInicial.Text;
            }
        }

        #endregion :: Eventos ::

        #region :: Métodos ::
        private void CarregaVendedoresComboBox()
        {
            for(int i = 0; i < lstVendedores.Count; i++)
            {
                cmbVendedores.Items.Add(lstVendedores[i].Nome);
            }
        }

        #endregion :: Métodos ::

    }
}