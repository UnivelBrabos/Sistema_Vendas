using Sistema_Vendas.Controller;
using Sistema_Vendas.Data;
using Sistema_Vendas.Model;
using Sistema_Vendas.Model.DataModel;
using Sistema_Vendas.Model.FilteredModel;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;


namespace Sistema_Vendas
{
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        private ObservableCollection<CheckBoxOptions> _itemscCheckBox;
        private ObservableCollection<CheckBoxOptions> _itemsClientesCheckBox;

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        private readonly ConnectionDB objConnect;

        private DashboardController GraficosController;

        public ObservableCollection<CheckBoxOptions> ItemscCheckBox
        {
            get { return _itemscCheckBox; }
            set
            {
                _itemscCheckBox = value;
                OnPropertyChanged(nameof(ItemscCheckBox));
            }
        }

        public ObservableCollection<CheckBoxOptions> ItemsClientesCheckBox
        {
            get { return _itemsClientesCheckBox; }
            set
            {
                _itemsClientesCheckBox = value;
                OnPropertyChanged(nameof(ItemsClientesCheckBox));
            }
        }

        public List<ItensVenda> lstItensVenda;
        public List<Vendedor> lstVendedores;
        public List<Produto> lstProdutos;
        public List<Cliente> lstClientes;
        public List<Vendas> lstVendas;

        public MainWindow(Usuarios pUsuarioLogado)
        {
            InitializeComponent();
            DataContext = this;
            objConnect = new ConnectionDB(); // Inicializa a conexão junto ao sistema

            //CarregaDados();

            dtpFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            dtpInicial.Text = "01/01/2025";

            //GraficosController = new(MenuPrincipal);

        }

        #region :: BI ::
        public void CarregaCheckBox()
        {
            if (lstVendedores == null || lstVendedores.Count == 0 || lstClientes == null || lstClientes.Count == 0)
            {
                MessageBox.Show("Nenhum vendedor encontrado.");
                return;
            }

            if (ItemscCheckBox == null) // Inicializa apenas se for nula
                ItemscCheckBox = new ObservableCollection<CheckBoxOptions>();

            if (ItemsClientesCheckBox == null)
                ItemsClientesCheckBox = new ObservableCollection<CheckBoxOptions>();

            ItemscCheckBox.Clear();
            ItemsClientesCheckBox.Clear();

            foreach (var vendedor in lstVendedores)
            {
                ItemscCheckBox.Add(new CheckBoxOptions { Name = vendedor.Nome, Id = vendedor.IdVendedor, IsSelected = true });
            }

            foreach (var cliente in lstClientes)
            {
                ItemsClientesCheckBox.Add(new CheckBoxOptions { Name = cliente.Nome, Id = cliente.IdCliente, IsSelected = true });
            }

            OnPropertyChanged(nameof(ItemscCheckBox));
            OnPropertyChanged(nameof(ItemsClientesCheckBox));

        }

        /*public async void CarregaDados()
        {
            lstVendedores = await Vendedor.GetVendedores(objConnect);

            lstVendas = await Vendas.GetVendas(objConnect);

            lstProdutos = await Produto.GetProdutos(objConnect);

            lstClientes = await Cliente.GetClientes(objConnect);

            lstItensVenda = await ItensVenda.GetItensVenda(objConnect);

            CarregaGrafico();

            CarregaCheckBox();
        }*/

        #region :: Carregamento dos gráficos ::
        public void CarregaGrafico(bool filtrar = false)
        {
            List<int> lstVendedoresId = new();
            List<int> lstClientesId = new();
            
            if(ItemscCheckBox != null)
            {
                lstVendedoresId = ItemscCheckBox
                    .Where(v => v.IsSelected)
                    .Select(v => v.Id)
                    .ToList();
            }

            if (ItemsClientesCheckBox != null)
            {
                lstClientesId = ItemsClientesCheckBox
                    .Where(v => v.IsSelected)
                    .Select(v => v.Id)
                    .ToList();
            }

            Filtros objFiltros = new(Convert.ToDateTime(dtpInicial.Text), Convert.ToDateTime(dtpFinal.Text), lstVendedoresId, lstClientesId);

            Graficos(filtrar, objFiltros);
        }

        public void Graficos(bool pFiltrar, Filtros pFiltros)
        {
        }

        #endregion :: Carregamento dos gráficos ::

        #endregion :: BI ::

        #region :: Auditoria ::

        public void CarregaTabela()
        {
            dtgVendas.ItemsSource = lstVendas
                                    .GroupJoin(lstVendedores,
                                    v => v.IdVendedor,
                                    s => s.IdVendedor,
                                    (v, s) => new
                                    {
                                        IdVenda = v.IdVenda,
                                        Vendedor = s.Select(x => x.Nome).FirstOrDefault(),
                                        DataDaVenda = v.DataVenda,
                                        Desconto = v.Desconto,
                                        Total = v.TotalVenda
                                    }).OrderBy(c => c.DataDaVenda)
                                    .ToList();
        }

        #endregion :: Auditoria ::

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
            CarregaCheckBox();
        }

        private void dtpInicial_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            dtpFinal.DisplayDateStart = Convert.ToDateTime(dtpInicial.Text);

            if (Convert.ToDateTime(dtpInicial.Text) > Convert.ToDateTime(dtpFinal.Text))
            {
                dtpFinal.Text = dtpInicial.Text;
            }
        }

        private void btnGraficos_Click(object sender, RoutedEventArgs e)
        {
            CarregaGrafico();

            grdAuditoria.Visibility = Visibility.Hidden;
            grdGraficos.Visibility = Visibility.Visible;
        }

        private void btnAuditoria_Click(object sender, RoutedEventArgs e)
        {
            CarregaTabela();

            grdAuditoria.Visibility = Visibility.Visible;
            grdGraficos.Visibility = Visibility.Hidden;
        }

        #endregion :: Eventos ::
    }
}