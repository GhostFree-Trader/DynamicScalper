//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#define VERSION "4.0"// Mudar aqui as Versões

//3.0 Modificações Nova Barra

#property copyright "UltimateBot"
#property link      "https://ultimatebot.com.br"
#property version   VERSION
#property description   ""

#resource "\\Indicators\\afast_media_dx.ex5"
#resource "\\Indicators\\Dx.ex5"

enum ModoDx
  {
   DxSimple = 0, //Simples
   DxExp = 1, //Exponencial
   DxSmooth = 2, //Smoothed MA
   DxLinear = 3 //Linear Weighted MA

  };


enum Objects
  {
   BuyButton,//BuyButton
   BuyText,//BuyText
   SellButton,//SellButton
   SellText,//SellText
   CloseButton,//CloseButton
   CloseText //CloseText
  };

enum ENUM_BOOLEANO
  {
   BOOL_NO,//Não
   BOOL_YES//Sim
  };

enum ULTIMO_SINAL
  {
   SINAL_BUY,//BUY
   SINAL_SELL,//SELL
   SINAL_NEUTRO //NEUTRO
  };


enum ModoEntrada
  {
   EntrTick,//Cada Tick
   EntrBarra//1 Vez por Barra
  };


enum OpcaoGap
  {
   Nao_Operar,//Não Operar
   Operar_Apos_Toque_Media,//Operar Após Toque na Média
   Operacoes_Normais //Operar Normalmente
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum Operacao
  {
   Contra,//Contra-Tendência
   Favor //Favor da Tendência
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum Sentido
  {
   Compra,//Operar Comprado
   Venda,//Operar Vendido
   Compra_e_Venda //Operar Comprado e Vendido
  };


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


#include <Controls\Defines.mqh>
#undef CONTROLS_DIALOG_COLOR_BG
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG
#undef CONTROLS_DIALOG_COLOR_CAPTION_TEXT
//#undef CONTROLS_LABEL_COLOR

color borda_bg = clrNONE; //Cor Borda
color painel_bg = clrNONE; //Cor Painel
color cor_txt_borda_bg = clrYellowGreen; //Cor Texto Borda
//color cor_txt_pn_bg=clrBlueViolet;//Cor Texto Painel

#define CONTROLS_DIALOG_COLOR_BG          borda_bg
#define CONTROLS_DIALOG_COLOR_CLIENT_BG   painel_bg
#define  CONTROLS_DIALOG_COLOR_CAPTION_TEXT cor_txt_borda_bg
//#define CONTROLS_LABEL_COLOR                cor_txt_pn_bg

#include <Expert_Class_New.mqh>
#include <Arrays\ArrayObj.mqh>


CLabel            m_label[50];
CPanel painel_head,painel_middle,painel_foot;
CEdit edit_painel;

#define LARGURA_PAINEL 280 // Largura Painel
#define ALTURA_PAINEL 220 // Altura Painel

#define LARG_BUTONS 60 // Largura Botões
#define ALT_BUTONS 22 // ALTURA Botões


bool DescriptionModeFull = true;
sinput string nome_setup = "Nome Do Setup"; //Nome Do Setup
input ENUM_TIMEFRAMES periodoRobo = PERIOD_CURRENT;//TIMEFRAME ROBO
input string simbolo = "";//Símbolo Ordens (vazio = atual)
input int MAGIC_NUMBER = 20082018; //Número Mágico
input int MAGIC_NUMBER_R2 = 100; //Número Mágico R2
input double Ajuste = 30;
ulong deviation_points = 50; //Deviation em Pontos(Padrao)
input group "Comum"
input double Lot = 1; //Lote Entrada
input double _Stop = 20.0; //Stop Loss Máximo em Pontos
input double _TakeProfit = 2.0; //Take Profit em Pontos

input group "Grid"
input bool UsarGrid = false; //Usar Grid?
input double lote_grid = 1; //Lotes Cada Nível
input ushort nordens_grid = 10; //N. Ordens Grid
input double dist_grid = 2; //Distância Entre as Ordens
input double TP_Grid = 2; //Take Profit em Pontos Grid
input double SL_Grid = 5; //SL em Pontos ùltima ordem Grid

input group "Estratégia"
input bool EntrarMedia = false; //Entrada pela Média?
input int   period_media = 7; //Periodo da Media
input ENUM_MA_METHOD modo_media = MODE_EMA; //Modo da Média
input ENUM_APPLIED_PRICE app_media = PRICE_CLOSE; //Aplicar a
input double dist_media = 5.0; //Distância da Média em Pontos
input Operacao operacao = Contra; //Operar a Favor ou Contra a Tendência
input Sentido operar = Compra_e_Venda; // Operar Comprado, Vendido
input bool fechar_media = false; //Fechar na Média Principal?
input bool cada_tick = true; //Operar a cada tick
input ushort seconds_int = 5; //Segundos Interv. Se Cada Tick
input bool AgStopBanda = false; //Após SL Entrar Outra Banda

input group "Indicador Dx"
//InpPeriodoMedia1=14
//InpMAModo1=0
//InpPreco1=1
input int InpPeriodoMediaDx = 14; //Período Média Dx
input ModoDx modo_Dx = 0; //Modo da Média
input bool UsarDx = false; //Usar Dx?
input double pts_dx = 0; //Pontos Somar Dx

input group "Pontos Aumento de Posição"
input double pt_aum1 = 2.0; //Pontos Aumento de Posição 1 (0 Não usar)
input double pt_aum2 = 4.0; //Pontos Aumento de Posição 2 (0 Não usar)
input double pt_aum3 = 6.0; //Pontos Aumento de Posição 3 (0 Não usar)
input double pt_aum4 = 8.0; //Pontos Aumento de Posição 4 (0 Não usar)
input double pt_aum5 = 10.0; //Pontos Aumento de Posição 5 (0 Não usar)
input double pt_aum6 = 12.0; //Pontos Aumento de Posição 6 (0 Não usar)

input group "Lotes Aumento de Posição"
input double lote_aum1 = 1.0; //Lotes Aumento de Posição 1 (0 Não usar)
input double lote_aum2 = 1.0; //Lotes Aumento de Posição 2 (0 Não usar)
input double lote_aum3 = 2.0; //Lotes Aumento de Posição 3 (0 Não usar)
input double lote_aum4 = 2.0; //Lotes Aumento de Posição 4 (0 Não usar)
input double lote_aum5 = 4.0; //Lotes Aumento de Posição 5 (0 Não usar)
input double lote_aum6 = 4.0; //Lotes Aumento de Posição 6 (0 Não usar)

input group "Saída Média Secundária"
input int period_med_sec = 5; //Período Média Secundária
input ENUM_MA_METHOD mode_sec = MODE_EMA; //Modo Média Secundária
input ENUM_APPLIED_PRICE app_sec = PRICE_CLOSE; //Aplicar a
input bool SairMedSec = false; //Fechar Na Secundária?
input ulong saida_sec = 4; //Aum de Pos p acionar Fech Média Sec/ 0 Não Sair na Secundária

input group "Filtro de Gap"
input OpcaoGap UsarGap = Operar_Apos_Toque_Media; //Opção de Gap
input double pts_gap = 10; //Gap em Pontos para Filtrar Entradas

input group "Break Even"
input    bool              UseBreakEven = false;                        //Usar BreakEven
input    double               BreakEvenPoint1 = 1.5;                          //Pontos para BreakEven 1
input    double               ProfitPoint1 = 0.5;                           //Pontos de Lucro da Posicao 1
input    double               BreakEvenPoint2 = 2.5;                          //Pontos para BreakEven 2
input    double               ProfitPoint2 = 1.0;                          //Pontos de Lucro da Posicao 2
input    double               BreakEvenPoint3 = 4.0;                          //Pontos para BreakEven 3
input    double               ProfitPoint3 = 2.0;                          //Pontos de Lucro da Posicao 3

input group"Trailing Stop"
input bool   Use_TraillingStop = false; //Usar Trailing
input double TraillingStart = 0; //Lucro Minimo Iniciar trailing stop
input double TraillingDistance = 3.0; // Distanccia em Pontos do Stop Loss
input double TraillingStep = 1.0; // Passo para atualizar Stop Loss



input group "Lucro"
input bool UsarLucro = false; //Usar Lucro para Fechamento Diário True/False
input double lucro = 1000.0; //Lucro em Moeda para Fechar Posicoes no Dia
input double prejuizo = 500.0; //Prejuizo em Moeda para Fechar Posicoes no Dia
input group "Horário"
input bool UseTimer = true; //Usar Filtro de Horário: True/False
input string start_hour = "9:04"; //Horario Inicial
input string end_hour_entr = "17:00"; //Horario Final Entradas
input string end_hour = "17:20"; //Horario Final
input bool daytrade = true; //Fechar Posicao Fim do Horario
sinput string sdias = "FILTRO DOS DIAS DA SEMANA"; //Dias da Semana
input bool trade0 = true; // Operar Domingo
input bool trade1 = true; // Operar Segunda
input bool trade2 = true; // Operar Terça
input bool trade3 = true; // Operar Quarta
input bool trade4 = true; // Operar Quinta
input bool trade5 = true; // Operar Sexta
input bool trade6 = true; // Operar Sábado



//Fim Parametros

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <ChartObjects\ChartObjectsLines.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrdensMedio : public CObject
  {
public:
   double            lote;
   double            distancia;


   // Class constructor
   void              OrdensMedio(double _lote,double _distancia) {lote = _lote; distancia = _distancia;};

  };



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrdensGrid : public CObject
  {
public:
   double            preco;
   ulong             tick;
   ulong             tick_tp;


   // Class constructor
   void              OrdensGrid(double _preco,ulong _tick,ulong _tick_tp) {preco = _preco; tick = _tick; tick_tp = _tick_tp;};
   void              Modify(double _preco,ulong _tick,ulong _tick_tp) {preco = _preco; tick = _tick; tick_tp = _tick_tp;};

  };



template<typename T>
class objvector : public CArrayObj
  {
public:
   T  *              operator[](const int index) const { return (T*)At(index);}
  };




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MyRobot : public MyExpert
  {
private:
   objvector<OrdensMedio> array_OrdensAumento;
   objvector<OrdensGrid> array_OrdensGrid;
   CChartObjectVLine VLine[];
   CChartObjectHLine HLine_Price,HLine_SL,HLine_TP,HL_DxLow,HL_DxHigh;
   ulong             ticket_pos,ticket_tp;
   int               positions_total;
   string            informacoes;
   double            sl_position,tp_position;
   double            vol_pos,vol_stp;
   double            preco_stp;
   double            preco_medio;
   bool              opt_tester;
   CNewBar           Bar_NovoDia;
   CNewBar           Bar_NovaBarra;
   bool              buysignal,sellsignal;
   double            Buyprice,Sellprice;
   bool              tradebarra;
   CiMA              *media;
   CiMA              *media_sec;
   int               media_handle;
   int               dx_handle;
   double            Med_Buf[],Med_Sup[],Med_Inf[],Dx_Buf[];
   datetime          hora_final_ent;
   bool              timerEnt,gapOn;
   double            price_open;
   bool              pos_open;
   ulong             time_conex; // Tempo em Milissegundos para testar conexão
   double            PointBreakEven[3],PointProfit[3];
   double            close_buy_sec,close_sell_sec,last_stop;
   bool              isHedge;
   bool              isBuyOpen,isSellOpen;
   double            pos_stop;
   string            last_msg;
   bool              first_tick;
   ULTIMO_SINAL      ultimo_sinal;
   bool              isGrid;
   bool              click_button_buy,click_button_sell,click_button_close;
   double            preco_first;
   datetime          time_int_ent,timecurrent;
   double            valor_dx;

public:
                     MyRobot();
                    ~MyRobot();
   int               OnInit();
   void              OnDeinit(const int reason);
   void              OnTick();
   void              OnTimer();
   string            GetCurrency() {return SymbolInfoString(original_symbol,SYMBOL_CURRENCY_BASE);}
   bool              TimeDayFilter();
   virtual bool      GetIndValue();
   virtual bool      BuySignal();
   virtual bool      SellSignal();
   void              OnTradeTransaction(const MqlTradeTransaction &trans,
                                        const MqlTradeRequest &request,
                                        const MqlTradeResult &result);
   void              Painel(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   bool              Gap();
   double            Pts_Gap();
   int               PriceCrossDown();
   int               PriceCrossUp();
   bool              CrossUpToday();
   bool              CrossDownToday();
   bool              CrossToday();
   bool              CheckBuyClose();
   bool              CheckSellClose();
   bool              TradeStop();
   void              Aumento_Posicao(ENUM_POSITION_TYPE pos_type);
   void              Aumento_Grid(ENUM_POSITION_TYPE pos_type);
   void              Atual_vol_Stop_Take();
   virtual void      BreakEven(string pSymbol,bool usarbreak,double &pBreakEven[],double &pLockProfit[]);
   void              ZeroStop();
   void              CreateButtons();
   void              PainelOntick();
   void              OnChartEvent(const int id,// event ID
                                  const long & lparam,  // event parameter of the long type
                                  const double & dparam, // event parameter of the double type
                                  const string & sparam); // event parameter of the string type

   bool              IsFillingTypeAllowed(int fill_type);
   int               GridIndexPosition(ulong o_ticket);
   int               GridIndexPositionTP(ulong o_ticket);
   void              CloseTPByPosition();
   virtual void              setExpName() {exp_name = "_" + IntegerToString(Magic_Number);}
   void              BotaoBackTest(Objects botao);

   void              PainelKey(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   void              PainelKeyOntick();
   double checkOrdens(ulong my_magic);

  };

MyRobot MyEA;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyRobot::MyRobot()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MyRobot::~MyRobot()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::OnTimer()
  {
   if(!MQLInfoInteger(MQL_OPTIMIZATION))
     {
      PainelOntick();
     }

  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int MyRobot::OnInit()
  {
   valor_dx = 0.0;
   time_int_ent = TimeCurrent();

   if(cada_tick)
      if(seconds_int < 5)
        {
         string erro = "O número de segundos entre cada entrada deve ser pelo menos 5 segundos";
         MessageBox(erro);
         Print(erro);
         return(INIT_PARAMETERS_INCORRECT);
        }

   if(UsarGrid)
      isGrid = true;
   else
      isGrid = false;
   array_OrdensAumento.Clear();
   if(pt_aum1 > 0)
      array_OrdensAumento.Add(new OrdensMedio(lote_aum1,pt_aum1));
   if(pt_aum2 > 0)
      array_OrdensAumento.Add(new OrdensMedio(lote_aum2,pt_aum2));
   if(pt_aum3 > 0)
      array_OrdensAumento.Add(new OrdensMedio(lote_aum3,pt_aum3));
   if(pt_aum4 > 0)
      array_OrdensAumento.Add(new OrdensMedio(lote_aum4,pt_aum4));
   if(pt_aum5 > 0)
      array_OrdensAumento.Add(new OrdensMedio(lote_aum5,pt_aum5));
   if(pt_aum6 > 0)
      array_OrdensAumento.Add(new OrdensMedio(lote_aum6,pt_aum6));






   EventSetTimer(1);
   isHedge = AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;
   tradeOn = true;
   setSymbol(Symbol());
   if(simbolo == "")
      setOriginalSymbol(_Symbol);
   else
      setOriginalSymbol(simbolo);

//setOriginalSymbol(_Symbol);

   setMagic(MAGIC_NUMBER);
   setExpName();

   Print("exp name " + exp_name);

   if(SymbolInfoInteger(original_symbol,SYMBOL_EXPIRATION_MODE) == 2)
      order_time_type = 1;
   else
      order_time_type = 0;
   mysymbol.Name(original_symbol);
   mytrade.SetExpertMagicNumber(MAGIC_NUMBER);
   mytrade.SetDeviationInPoints(50);
   opt_tester = (MQLInfoInteger(MQL_OPTIMIZATION) || MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_PROFILER)) && !MQLInfoInteger(MQL_VISUAL_MODE);
   if(opt_tester)
      mytrade.LogLevel(LOG_LEVEL_NO);
   else
      mytrade.LogLevel(LOG_LEVEL_ERRORS);

//   mytrade.SetTypeFillingBySymbol(original_symbol);
   mytrade.SetTypeFilling(ORDER_FILLING_RETURN);


   ponto = SymbolInfoDouble(original_symbol,SYMBOL_POINT);
   ticksize = SymbolInfoDouble(original_symbol,SYMBOL_TRADE_TICK_SIZE);
   digits = (int)SymbolInfoInteger(original_symbol,SYMBOL_DIGITS);

   int find_wdo = StringFind(original_symbol,"WDO");
   int find_dol = StringFind(original_symbol,"DOL");
   if(find_dol >= 0 || find_wdo >= 0)
      ponto = 1.0;
   gv.Init(symbol,Magic_Number);
   TimeToStruct(TimeCurrent(),TimeNow);
   gv.Set("gv_today_prev",(double)TimeNow.day_of_year);
   setNameGvOrder();

   hora_inicial = StringToTime(TimeToString(TimeCurrent(),TIME_DATE) + " " + start_hour);
   hora_final = StringToTime(TimeToString(TimeCurrent(),TIME_DATE) + " " + end_hour);
   hora_final_ent = StringToTime(TimeToString(TimeCurrent(),TIME_DATE) + " " + end_hour_entr);

   if(!PosicaoAberta())
     {
      close_buy_sec = 0.0;
      close_sell_sec = 0.0;
     }

   ulong curChartID = ChartID();

   ResetLastError();
   media_sec = new CiMA;
   if(! media_sec.Create(_Symbol,periodoRobo,period_med_sec,0,mode_sec,app_sec))
     {
      Print("Erro Criar Indicador Média Secundária");
      return INIT_FAILED;
     }
   if(!media_sec.AddToChart(curChartID,0))
     {
      string erro = "Erro Anexar o Indicador no Gráfico: " + IntegerToString(GetLastError()) ;
      MessageBox(erro);
      Print(erro);
      return(INIT_FAILED);
     }

   media = new CiMA;
   if(!media.Create(_Symbol,periodoRobo,period_media,0,modo_media,app_media))
     {
      PrintFormat("Erro Criar Indicador Média: %d",GetLastError());
      return(INIT_FAILED);
     }


   media_handle = iCustom(_Symbol,periodoRobo,"::Indicators\\afast_media_dx.ex5",period_media,modo_media,app_media,dist_media);
   if(media_handle == INVALID_HANDLE)
     {
      PrintFormat("Erro Criar Indicador Afastamento da Média: %d", GetLastError());
      return(INIT_FAILED);
     }
   /*  if(MQLInfoInteger(MQL_VISUAL_MODE))
        Sleep(5000);
    */
   int cont_ind = 0;
   bool anexou = false;
   while(!anexou && cont_ind < 10)
     {
      Sleep(1000);
      anexou = ChartIndicatorAdd(curChartID,0,media_handle);
      cont_ind ++;
      PrintFormat("Anexou Indicador %s? %s, Contagem: %d","afastamento média",(string)anexou,cont_ind);
     }


   if(!anexou)
     {
      string erro = "Erro Anexar o Indicador Afastamento de Média no Gráfico: " + IntegerToString(GetLastError()) ;
      MessageBox(erro);
      Print(erro);
      PrintFormat("Handle: %d ",media_handle);
      return(INIT_FAILED);
     }

   PrintFormat("tentativas %d",cont_ind);


   dx_handle = iCustom(_Symbol,periodoRobo,"::Indicators\\Dx.ex5",";",period_media,modo_media,app_media,";",InpPeriodoMediaDx,modo_Dx);

   if(dx_handle == INVALID_HANDLE)
     {
      PrintFormat("Erro Criar Indicador Dx: %d", GetLastError());
      return(INIT_FAILED);
     }
   /*  if(MQLInfoInteger(MQL_VISUAL_MODE))
        Sleep(5000);
    */
   cont_ind = 0;
   anexou = false;
   while(!anexou && cont_ind < 10)
     {
      Sleep(1000);
      anexou = ChartIndicatorAdd(curChartID,(int)ChartGetInteger(curChartID,CHART_WINDOWS_TOTAL),dx_handle);
      cont_ind ++;
      PrintFormat("Anexou Indicador %s? %s, Contagem: %d","dx",(string)anexou,cont_ind);
     }


   if(!anexou)
     {
      string erro = "Erro Anexar o Indicador Dx no Gráfico: " + IntegerToString(GetLastError()) ;
      MessageBox(erro);
      Print(erro);
      PrintFormat("Handle: %d ",dx_handle);
      return(INIT_FAILED);
     }


   PrintFormat("tentativas %d",cont_ind);





   ArraySetAsSeries(Med_Buf,true);
   ArraySetAsSeries(Med_Sup,true);
   ArraySetAsSeries(Med_Inf,true);

   ArraySetAsSeries(Dx_Buf,true);


   ArraySetAsSeries(close,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(open,true);

   ChartSetInteger(ChartID(),CHART_SHOW_TRADE_LEVELS,true);
   ChartSetInteger(ChartID(),CHART_DRAG_TRADE_LEVELS,true);
   ChartSetInteger(ChartID(),CHART_COLOR_STOP_LEVEL,clrRed);

   if(hora_inicial >= hora_final)
     {
      string erro = "Hora Inicial deve ser Menor que Hora Final";
      MessageBox(erro);
      Print(erro);
      return(INIT_PARAMETERS_INCORRECT);
     }

   if(hora_final_ent <= hora_inicial || hora_final_ent >= hora_final)
     {
      string erro = "Hora Final das Entradas deve estar entre  Horário Inicial e Final";
      MessageBox(erro);
      Print(erro);
      return(INIT_PARAMETERS_INCORRECT);
     }

   if(Lot < mysymbol.LotsMin())
     {
      string erro = "Lote deve ser maior ou igual a " + DoubleToString(mysymbol.LotsMin(),2);
      MessageBox(erro);
      Print(erro);
      return(INIT_PARAMETERS_INCORRECT);
     }

   if(_Stop <= pt_aum1 || _Stop <= pt_aum2 || _Stop <= pt_aum3 || _Stop <= pt_aum4 || _Stop <= pt_aum5 || _Stop <= pt_aum6)

     {
      string erro = "O Stop Máximo deve ser maior que todos pontos de aumento entrada ";
      MessageBox(erro);
      Print(erro);
      return(INIT_PARAMETERS_INCORRECT);

     }

   PointBreakEven[0] = BreakEvenPoint1;
   PointBreakEven[1] = BreakEvenPoint2;
   PointBreakEven[2] = BreakEvenPoint3;
   PointProfit[0] = ProfitPoint1;
   PointProfit[1] = ProfitPoint2;
   PointProfit[2] = ProfitPoint3;

   if(UseBreakEven)
     {


      for(int i = 0; i < 3; i++)
        {
         if(PointBreakEven[i] < PointProfit[i])
           {
            string erro = "Profit do Break Even deve ser menor que o Ponto de Break Even";
            MessageBox(erro);
            Print(erro);
            return(INIT_PARAMETERS_INCORRECT);

           }

        }

      for(int i = 0; i < 2; i++)
        {
         if(PointBreakEven[i + 1] <= PointBreakEven[i])
           {
            string erro = "Pontos de Break Even devem estar em ordem crescente";
            MessageBox(erro);
            Print(erro);
            return(INIT_PARAMETERS_INCORRECT);

           }

        }
      for(int i = 0; i < 2; i++)
        {
         if(PointProfit[i + 1] <= PointProfit[i])
           {
            string erro = "Pontos de Profit do Break Even devem estar em ordem crescente";
            MessageBox(erro);
            Print(erro);
            return(INIT_PARAMETERS_INCORRECT);

           }

        }

     } //Fim Usar BreakEven


   if(!MQLInfoInteger(MQL_OPTIMIZATION))
     {
      Painel(0,MQL5InfoString(MQL5_PROGRAM_NAME),0,INDENT_LEFT,INDENT_TOP,LARGURA_PAINEL,ALTURA_PAINEL);
      CreateButtons();

     }

   last_msg = "Robô Iniciado";

   return (INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void MyRobot::OnDeinit(const int reason)
  {
   gv.Deinit();
   delete(media);
   delete(media_sec);
   IndicatorRelease(media_handle);
   DeletaIndicadores();
   ObjectsDeleteAll(0);
   EventKillTimer();
//---
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+-------------ROTINAS----------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::OnTick()
  {

   timecurrent = TimeCurrent();
   TimeToStruct(timecurrent,TimeNow);
   gv.Set("gv_today",(double)TimeNow.day_of_year);

   bool novodia;
   novodia = Bar_NovoDia.CheckNewBar(original_symbol,PERIOD_D1);

   if(novodia || gv.Get("gv_today") != gv.Get("gv_today_prev"))
     {
      gv.Set("glob_entr_tot",0.0);
      gv.Set("deals_total_prev",0.0);
      last_stop = 0.0;
      tradeOn = true;
      hora_inicial = StringToTime(TimeToString(timecurrent,TIME_DATE) + " " + start_hour);
      hora_final = StringToTime(TimeToString(timecurrent,TIME_DATE) + " " + end_hour);
      hora_final_ent = StringToTime(TimeToString(timecurrent,TIME_DATE) + " " + end_hour_entr);

      last_msg = "Novo Dia";
      lucro_orders = LucroOrdens();
      if(!opt_tester)
        {
         lucro_orders_mes = LucroOrdensMes();
         lucro_orders_sem = LucroOrdensSemana();
        }
      first_tick = true;
      time_int_ent = timecurrent;

     }

   mysymbol.Refresh();
   mysymbol.RefreshRates();
   media.Refresh();
   media_sec.Refresh();

   if(Gap())
     {
      gapOn = false;
      if(UsarGap == Operacoes_Normais)
         gapOn = true;
      if(UsarGap == Operar_Apos_Toque_Media && CrossToday())
         gapOn = true;
     }
   else
      gapOn = true;



   timerOn = true;
   timerEnt = true;

   if(UseTimer == true)
     {
      timerOn = timecurrent >= hora_inicial && timecurrent <= hora_final && TimeDayFilter();
      timerEnt = timecurrent >= hora_inicial && timecurrent <= hora_final_ent && TimeDayFilter();

     }


   if(!timerOn)
     {
      if(daytrade)
        {
         if(OrdersTotal() > 0)
            DeleteALL();
         if(PositionsTotal() > 0)
            CloseALL();
        }
      return;
     }

   if(!tradeOn)
      return;


   gv.Set("gv_today_prev",gv.Get("gv_today"));


   MqlTick last_tick;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(SymbolInfoTick(Symbol(),last_tick))
     {
      bid = last_tick.bid;
      ask = last_tick.ask;
     }
   else
     {
      Print("Falhou obter o tick");
      return;
     }
   if(bid == 0 || ask == 0)
     {
      Print("BID ou ASK=0 : ",bid," ",ask);
      return;
     }

   if(bid >= ask)
      return ; //Leilão

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(GetIndValue())
     {
      Print("Error in obtain indicators buffers or price rates");
      return;
     }
   valor_dx = Dx_Buf[1];
   pos_open = PosicaoAberta();

   if(pos_open)
     {
      lucro_positions = LucroPositions();

     }
   else
     {
      lucro_positions = 0.0;
     }

   lucro_total = lucro_orders + lucro_positions;
   if(!opt_tester)
     {
      lucro_total_semana = lucro_orders_sem + lucro_positions;
      lucro_total_mes = lucro_orders_mes + lucro_positions;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(UsarLucro && (lucro_total >= lucro || lucro_total <= -prejuizo))
     {
      if(OrdersTotal() > 0)
         DeleteALL();
      CloseALL();
      tradeOn = false;
      informacoes = "EA encerrado lucro ou prejuizo";
     }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   isBuyOpen = Buy_opened();
   isSellOpen = Sell_opened();

   if(isHedge && isBuyOpen && isSellOpen)
     {
      if(!isGrid)
        {
         DeleteALL();
         CloseByPosition();
        }
      else
        {
         CloseTPByPosition();
         ticket_pos = (ulong)gv.Get("vd_tick");
         ticket_tp = (ulong)gv.Get("tp_cp_tick");

         if(myposition.SelectByTicket(ticket_tp))
            if(myposition.SelectByTicket(ticket_pos))
               mytrade.PositionCloseBy(ticket_pos,ticket_tp);

         ticket_pos = (ulong)gv.Get("cp_tick");
         ticket_tp = (ulong)gv.Get("tp_vd_tick");

         if(myposition.SelectByTicket(ticket_tp))
            if(myposition.SelectByTicket(ticket_pos))
               mytrade.PositionCloseBy(ticket_pos,ticket_tp);



        }


     }
   if(!pos_open && OrdersTotal() > 0)
      DeleteALL();
   if(!pos_open)
     {
      close_buy_sec = 0.0;
      close_sell_sec = 0.0;
     }

   if(tradeOn && timerOn)

     {
      // inicio Trade On

      if(first_tick)
        {
         first_tick = false;
         if(Gap())
            last_msg = "Gap no Dia";
        }

      if(pos_open)
        {
         if(Use_TraillingStop)
            TrailingStop(TraillingDistance,TraillingStart,TraillingStep);
         if(UseBreakEven)
            BreakEven(original_symbol,UseBreakEven,PointBreakEven,PointProfit);
        }



      if(!isGrid)
        {
         Atual_vol_Stop_Take();
        }

      if(isHedge && isBuyOpen && isSellOpen)
         CloseByPosition();

     // ZeroStop();


      if(operacao == Contra)
        {
         if(CheckBuyClose() && isBuyOpen)
           {
            DeleteALL();
            ClosePosType(POSITION_TYPE_BUY);
           }
         if(CheckSellClose() && isSellOpen)
           {
            DeleteALL();
            ClosePosType(POSITION_TYPE_SELL);
           }
        }

      if(timerEnt && gapOn)
        {
         // inicio Trade On
         bool novabarra = Bar_NovaBarra.CheckNewBar(Symbol(),periodoRobo);
         if(novabarra)
           {
            tradebarra = true;

           } //Fim Nova Barra

         if((bool)MQLInfoInteger(MQL_VISUAL_MODE))
           {
            BotaoBackTest(BuyButton);
            BotaoBackTest(SellButton);
            BotaoBackTest(CloseButton);
           }


         buysignal = false;
         sellsignal = false;
         if(!pos_open)
           {
            if(!isBuyOpen)
               buysignal = BuySignal();
            if(!isSellOpen)
               sellsignal = SellSignal();
           }

         if(buysignal)
            if(AgStopBanda)
               buysignal = TradeStop();

         if(sellsignal)
            if(AgStopBanda)
               sellsignal = TradeStop();

         if(operar == Venda)
            buysignal = false;

         if(operar == Compra)
            sellsignal = false;

         if(cada_tick)
           {
            if(buysignal)
               buysignal = timecurrent >= time_int_ent + seconds_int;
            if(sellsignal)
               sellsignal = timecurrent >= time_int_ent + seconds_int;
           }

         else
           {
            if(buysignal)
               buysignal = novabarra;
            if(sellsignal)
               sellsignal = novabarra;
           }

         if(buysignal)
           {
            if(UsarGrid)
               isGrid = true;
            else
               isGrid = false;

            last_msg = "Sinal Compra";
            tradebarra = false;
            time_int_ent = timecurrent;
            DeleteALL();
            if(isSellOpen)
               ClosePosType(POSITION_TYPE_SELL);
            sl_position = 0;
            tp_position = 0;
            if(!isGrid)
              {
               if(_Stop > 0)
                  sl_position =  NormalizaPreco(bid - _Stop * ponto);
              }
            else
              {
               sl_position = NormalizaPreco(bid - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);
              }

            if(_TakeProfit > 0)
               tp_position = NormalizaPreco(ask + _TakeProfit * ponto);

            if(mytrade.PositionOpen(original_symbol,ORDER_TYPE_BUY,Lot,0,sl_position,tp_position,"BUY" + exp_name))
               //   if(mytrade.Buy(Lot,original_symbol,0,sl_position,tp_position,"BUY" + exp_name))
              {
               ticket_pos = mytrade.ResultOrder();
               gv.Set("cp_tick",(double)ticket_pos);
               ultimo_sinal = SINAL_BUY;
              }
            else
               Print("Erro enviar ordem ",GetLastError());
           }

         if(sellsignal)
           {
            if(UsarGrid)
               isGrid = true;
            else
               isGrid = false;

            last_msg = "Sinal Venda";
            tradebarra = false;
            time_int_ent = timecurrent;
            DeleteALL();
            if(isBuyOpen)
               ClosePosType(POSITION_TYPE_BUY);
            sl_position = 0;
            tp_position = 0;
            if(!isGrid)
              {
               if(_Stop > 0)
                  sl_position =  NormalizaPreco(ask + _Stop * ponto);
              }

            else
              {
               sl_position = NormalizaPreco(ask + (double)(nordens_grid * dist_grid * ponto) + SL_Grid * ponto);
              }


            if(_TakeProfit > 0)
               tp_position = NormalizaPreco(bid - _TakeProfit * ponto);
            if(mytrade.PositionOpen(original_symbol,ORDER_TYPE_SELL,Lot,0,sl_position,tp_position,"SELL" + exp_name))
               //            if(mytrade.Sell(Lot,original_symbol,0,sl_position,tp_position,"SELL" + exp_name))
              {
               ticket_pos = mytrade.ResultOrder();
               gv.Set("vd_tick",(double)ticket_pos);
               ultimo_sinal = SINAL_SELL;
              }
            else
               Print("Erro enviar ordem ",GetLastError());

           }

        }//End Time Ent



     } //End Trade On

  } //End OnTick
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::BuySignal()
  {
   bool signal = false;
   if(!EntrarMedia)
      return false;
   if(operacao == Favor)
     {
      if(!UsarDx)
         signal = bid - media.Main(0) >= dist_media * ponto;
      else
         signal = bid - media.Main(0) >= Dx_Buf[1] + pts_dx * ponto;

     }
   else
     {
      if(!UsarDx)
         signal = media.Main(0) - ask >= dist_media * ponto;
      else
         signal = media.Main(0) - ask >= Dx_Buf[1] + pts_dx * ponto;

     }
 if(MAGIC_NUMBER_R2 > 0 )
     {
         double preco_entrada = checkOrdens( MAGIC_NUMBER_R2  );
   
         signal = false;
         if(  preco_entrada > 0 )
           {
            double price_sinal = preco_entrada - Ajuste;
            
            signal = ask >  price_sinal - 10 && ask <  price_sinal + 5  ; 
           }  
     
    }
  
  if(signal ) PrintFormat(">>>>>>>>>>  FAZER COMPRA ask %0.2f, MAGIC_NUMBER %i ",ask, MAGIC_NUMBER);
  
   return signal;
  }
  
  double MyRobot:: checkOrdens(ulong my_magic)
  
  {
  
  double preco_entrada = 0;
  
//--- obtain the total number of positions
   int positions=PositionsTotal();
//--- scan the list of orders
   for(int i=0;i<positions;i++)
     {
      ResetLastError();
      //--- copy into the cache, the position by its number in the list
      string symbol=PositionGetSymbol(i); //  obtain the name of the symbol by which the position was opened
      if(symbol!="") // the position was copied into the cache, work with it
        {
         long pos_id            =PositionGetInteger(POSITION_IDENTIFIER);
         double price           =PositionGetDouble(POSITION_PRICE_OPEN);
         ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         long pos_magic         =PositionGetInteger(POSITION_MAGIC);
         string comment         =PositionGetString(POSITION_COMMENT);
         if(pos_magic==my_magic)
           {
            //PrintFormat("Position #%d by %s: POSITION_MAGIC=%d, price=%G, type=%s, commentary=%s",
                     //pos_id,symbol,pos_magic,price,EnumToString(type),comment);
                     
             preco_entrada = price;
           }
         
        }
      else           // call to PositionGetSymbol() was unsuccessful
        {
         PrintFormat("Error when receiving into the cache the position with index %d."+
                     " Error code: %d", i, GetLastError());
        }
     }
     
     return preco_entrada;
  }
//+------------------------------------------------------------------+
//| Sell conditions                                                  |
//+------------------------------------------------------------------+
bool MyRobot::SellSignal()
  {
   bool signal = false;
   if(!EntrarMedia)
      return false;
   if(operacao == Favor)
     {
      if(!UsarDx)
         signal = media.Main(0) - ask >= dist_media * ponto;
      else
         signal = media.Main(0) - ask >= Dx_Buf[1] + pts_dx * ponto;
     }
   else
     {
      if(!UsarDx)
         signal = bid - media.Main(0) >= dist_media * ponto;
      else
         signal = bid - media.Main(0) >= Dx_Buf[1] + pts_dx * ponto;
     }

   return signal;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::TradeStop()
  {
   if(last_stop == 1.0)
     {
      if(pos_stop * (close[0] - media.Main(0)) <= 0)
        {
         last_stop = 0.0;
         return true;
        }
      else
         return false;
     }
   else
      return true;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::Aumento_Posicao(ENUM_POSITION_TYPE pos_type)
  {
   string s_tick = "";
   ENUM_ORDER_TYPE ord_type = NULL;
   if(pos_type == POSITION_TYPE_BUY)
     {
      s_tick = "cp_tick";
      ord_type = ORDER_TYPE_BUY_LIMIT;
     }

   else
      if(pos_type == POSITION_TYPE_SELL)
        {
         s_tick = "vd_tick";
         ord_type = ORDER_TYPE_SELL_LIMIT;
        }
      else
         return;

   if(!myposition.SelectByTicket((ulong)gv.Get(s_tick)))
     {
      Print("Posição Não Encontrada. Não enviaremos aumento de Posição");
      return;
     }
   double preco_entr = NormalizaPreco(myposition.PriceOpen());
   double preco_stop = myposition.StopLoss();
   double preco_take = myposition.TakeProfit();
   double limit_price;
   double lote;
   string cmt;


   for(int i = 0; i < array_OrdensAumento.Total(); i++)
     {
      if(ord_type == ORDER_TYPE_BUY_LIMIT)
        {
         limit_price = NormalizaPreco(preco_entr - array_OrdensAumento[i].distancia * ponto);
         cmt = "BUY_" + IntegerToString(i + 1) + exp_name;

        }
      else
        {
         limit_price = NormalizaPreco(preco_entr + array_OrdensAumento[i].distancia * ponto);
         cmt = "SELL_" + IntegerToString(i + 1) + exp_name;
        }
      lote = array_OrdensAumento[i].lote;
      ResetLastError();
      if(!mytrade.OrderOpen(original_symbol,ord_type,lote,0.0,limit_price,preco_stop,0,order_time_type,0,cmt))
         Print("Erro Enviar Ordem de Aumento: ",(string)GetLastError());
     }



  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::Aumento_Grid(ENUM_POSITION_TYPE pos_type)
  {
   string s_tick = "";
   ENUM_ORDER_TYPE ord_type = NULL;
   if(pos_type == POSITION_TYPE_BUY)
     {
      s_tick = "cp_tick";
      ord_type = ORDER_TYPE_BUY_LIMIT;
     }

   else
      if(pos_type == POSITION_TYPE_SELL)
        {
         s_tick = "vd_tick";
         ord_type = ORDER_TYPE_SELL_LIMIT;
        }
      else
         return;

   if(!myposition.SelectByTicket((ulong)gv.Get(s_tick)))
     {
      Print("Posição Não Encontrada. Não enviaremos GRID");
      return;
     }
   double preco_entr = NormalizaPreco(myposition.PriceOpen());
   double preco_take = myposition.TakeProfit();
   double limit_price;
   string cmt;

   double preco_stop = myposition.StopLoss();



   for(int i = 0; i < (int)nordens_grid; i++)
     {
      if(ord_type == ORDER_TYPE_BUY_LIMIT)
        {
         limit_price = NormalizaPreco(preco_entr - (double)((i + 1) * dist_grid) * ponto);

        }
      else
        {
         limit_price = NormalizaPreco(preco_entr + (double)((i + 1) * dist_grid) * ponto);
        }

      if(i == 0)
        {
         cmt = "FIRST_" + exp_name;
         preco_first = limit_price;
        }
      else
         cmt = "GRID_" + exp_name;

      ResetLastError();
      if(!mytrade.OrderOpen(original_symbol,ord_type,lote_grid,limit_price,limit_price,preco_stop,0,order_time_type,0,cmt))
         Print("Erro Enviar Ordem de Grid: ",(string)GetLastError());





     }//Fim for




  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::CheckSellClose()
  {
   bool dist = fechar_media ? ask <= media.Main(0) : false;
   bool sec = false;
   if(SairMedSec)
     {
      if(close_sell_sec == 1.0 && saida_sec > 0)
         sec = ask <= media_sec.Main(0);
     }
   return (dist || sec);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::CheckBuyClose()
  {
   bool dist = fechar_media ? bid >= media.Main(0) : false;

   bool sec = false;
   if(SairMedSec)
     {
      if(close_buy_sec == 1.0 && saida_sec > 0)
         sec = bid >= media_sec.Main(0);
     }
   return (dist || sec);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::Gap()
  {
   return MathAbs(iClose(original_symbol,PERIOD_D1,1) - iOpen(original_symbol,PERIOD_D1,0)) >= pts_gap * ponto;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MyRobot::Pts_Gap()
  {
   return MathAbs(iClose(Symbol(),PERIOD_D1,1) - iOpen(Symbol(),PERIOD_D1,0));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MyRobot::PriceCrossDown()
  {
   bool signal;
   int i;
   signal = false;
   i = 0;
   while(!signal && !IsStopped())
     {
      signal = iClose(Symbol(),periodoRobo,i + 1) > media.Main(i + 1) && iClose(Symbol(),periodoRobo,i) < media.Main(i);
      i = i + 1;
     }
   return i - 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MyRobot::PriceCrossUp()
  {
   bool signal;
   int i;
   signal = false;
   i = 0;
   while(!signal && !IsStopped())
     {
      signal = iClose(Symbol(),periodoRobo,i + 1) < media.Main(i + 1) && iClose(Symbol(),periodoRobo,i) > media.Main(i);
      i = i + 1;
     }
   return i - 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::CrossUpToday()
  {
   int lastcross = PriceCrossUp() + 1;
   datetime timecross = iTime(Symbol(),periodoRobo,lastcross);
   MqlDateTime TimeCross;
   TimeToStruct(timecross,TimeCross);
   TimeToStruct(TimeCurrent(),TimeNow);
   if(TimeCross.day == TimeNow.day)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
bool MyRobot::CrossDownToday()
  {
   int lastcross = PriceCrossDown() + 1;
   datetime timecross = iTime(Symbol(),periodoRobo,lastcross);
   MqlDateTime TimeCross;
   TimeToStruct(timecross,TimeCross);
   TimeToStruct(TimeCurrent(),TimeNow);
   if(TimeCross.day == TimeNow.day)
      return true;
   return false;
  }
//+------------------------------------------------------------------+
bool MyRobot::CrossToday()
  {
   return CrossDownToday() || CrossUpToday();
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Getting the current values of indicators                         |
//+------------------------------------------------------------------+
bool MyRobot::GetIndValue()
  {
   bool b_get;
   b_get = CopyBuffer(dx_handle,2,0,5,Dx_Buf) <= 0 ||
           CopyBuffer(media_handle,0,0,5,Med_Buf) <= 0 ||
           CopyBuffer(media_handle,1,0,5,Med_Sup) <= 0 ||
           CopyBuffer(media_handle,2,0,5,Med_Inf) <= 0 ||
           CopyHigh(Symbol(),PERIOD_CURRENT,0,5,high) <= 0 ||
           CopyOpen(Symbol(),PERIOD_CURRENT,0, 5, open) <= 0 ||
           CopyLow(Symbol(), PERIOD_CURRENT, 0, 5, low) <= 0 ||
           CopyClose(Symbol(),PERIOD_CURRENT,0,5,close) <= 0;
   return (b_get);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool MyRobot::IsFillingTypeAllowed(int fill_type)
  {
//--- Obtain the value of the property that describes allowed filling modes
   int filling = mysymbol.TradeFillFlags();
//--- Return true, if mode fill_type is allowed
   return((filling & fill_type) == fill_type);
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::OnTradeTransaction(const MqlTradeTransaction & trans,
                                 const MqlTradeRequest & request,
                                 const MqlTradeResult & result)
  {

   if(trans.symbol != original_symbol)
      return;
   int TENTATIVAS = 10;

//--- get transaction type as enumeration value
   ENUM_TRADE_TRANSACTION_TYPE type = trans.type;
//--- if transaction is result of addition of the transaction in history

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

   if(type == TRADE_TRANSACTION_REQUEST)
     {
      //--- display transaction name
      Print(EnumToString(type));
      //--- then display the string description of the handled request
      Print("------------RequestDescription\r\n",
            RequestDescription(request,DescriptionModeFull));
      //--- and show description of the request result
      Print("------------ ResultDescription\r\n",
            TradeResultDescription(result,DescriptionModeFull));
     }
   /*else // display full description of the transaction for transactions of another type
     {
      Print("------------ TransactionDescription\r\n",
            TransactionDescription(trans,DescriptionModeFull));
     }*/


   if(type == TRADE_TRANSACTION_HISTORY_UPDATE)
     {
     }

   if(type == TRADE_TRANSACTION_DEAL_ADD)
     {
      long deal_ticket = 0;
      long deal_order = 0;
      long deal_time = 0;
      long deal_time_msc = 0;
      ENUM_DEAL_TYPE deal_type = -1;
      long deal_entry = -1;
      ulong deal_magic = 0;
      ENUM_DEAL_REASON deal_reason = -1;
      long deal_position_id = 0;
      double deal_volume = 0.0;
      double deal_price = 0.0;
      double deal_commission = 0.0;
      double deal_swap = 0.0;
      double deal_profit = 0.0;
      string deal_symbol = "";
      string deal_comment = "";
      string deal_external_id = "";
      if(HistoryDealSelect(trans.deal))
        {
         deal_ticket = HistoryDealGetInteger(trans.deal,DEAL_TICKET);
         deal_order = HistoryDealGetInteger(trans.deal,DEAL_ORDER);
         deal_time = HistoryDealGetInteger(trans.deal,DEAL_TIME);
         deal_time_msc = HistoryDealGetInteger(trans.deal,DEAL_TIME_MSC);
         deal_type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(trans.deal,DEAL_TYPE);
         deal_entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
         deal_magic = HistoryDealGetInteger(trans.deal, DEAL_MAGIC);
         deal_reason = (ENUM_DEAL_REASON)HistoryDealGetInteger(trans.deal,DEAL_REASON);
         deal_position_id = HistoryDealGetInteger(trans.deal,DEAL_POSITION_ID);

         deal_volume = HistoryDealGetDouble(trans.deal,DEAL_VOLUME);
         deal_price = HistoryDealGetDouble(trans.deal,DEAL_PRICE);
         deal_commission = HistoryDealGetDouble(trans.deal,DEAL_COMMISSION);
         deal_swap = HistoryDealGetDouble(trans.deal,DEAL_SWAP);
         deal_profit = HistoryDealGetDouble(trans.deal,DEAL_PROFIT);

         deal_symbol = HistoryDealGetString(trans.deal,DEAL_SYMBOL);
         deal_comment = HistoryDealGetString(trans.deal,DEAL_COMMENT);
         deal_external_id = HistoryDealGetString(trans.deal,DEAL_EXTERNAL_ID);

         if(deal_symbol != original_symbol)
            return;
         if(deal_magic == Magic_Number)
           {
            gv.Set("last_deal_time",(double)deal_time);

            if((deal_type == DEAL_TYPE_BUY || deal_type == DEAL_TYPE_SELL) && (deal_entry == DEAL_ENTRY_OUT || deal_entry == DEAL_ENTRY_OUT_BY))
              {
               if(deal_profit < 0)
                 {
                  //   Print("Saída por STOP LOSS");
                  if(deal_reason == DEAL_REASON_SL)
                    {
                     if(AgStopBanda)
                       {
                        Print("Saída por STOP LOSS. Aguardar Toque na Média");
                        last_msg = "SL - Aguarde Ret. Média";
                        last_stop = 1.0;
                        pos_stop = deal_price - media.Main(0);
                       }
                    }

                 }

               if(deal_profit > 0)
                 {
                  Print("Saída no GAIN");
                  last_msg = "Gain";
                 }
              }

            lucro_orders = LucroOrdens();
            lucro_orders_mes = LucroOrdensMes();
            lucro_orders_sem = LucroOrdensSemana();

           } //Fim deal magic
        }
      else
         return;
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(type == TRADE_TRANSACTION_HISTORY_ADD)
     {
      ulong o_ticket = trans.order;
      myhistory.Ticket(o_ticket);
      HistoryOrderSelect(o_ticket);
      long pos_id = HistoryOrderGetInteger(o_ticket,ORDER_POSITION_ID);
      long order_magic = HistoryOrderGetInteger(o_ticket,ORDER_MAGIC);
      string order_comment = HistoryOrderGetString(o_ticket,ORDER_COMMENT);
      double order_lot = HistoryOrderGetDouble(o_ticket,ORDER_VOLUME_INITIAL);
      ENUM_ORDER_TYPE order_type = (ENUM_ORDER_TYPE)HistoryOrderGetInteger(o_ticket,ORDER_TYPE);
      double order_price = HistoryOrderGetDouble(o_ticket,ORDER_PRICE_OPEN);

      if(order_magic != (long)Magic_Number)
         return;
      if(trans.order_state == ORDER_STATE_FILLED)
        {


         if(StringFind(order_comment,"BUY" + exp_name) > -1 || StringFind(order_comment,"SELL" + exp_name) > -1)
           {
            gv.Set("glob_entr_tot",gv.Get("glob_entr_tot") + 1);
           }



         if(StringFind(order_comment,"BUY" + exp_name) > -1)
           {
            myposition.SelectByTicket(o_ticket);
            int cont = 0;
            Buyprice = 0;
            while(Buyprice == 0 && cont < TENTATIVAS)
              {
               Buyprice = NormalizaPreco(myposition.PriceOpen());
               cont += 1;
              }
            if(Buyprice == 0)
               Buyprice = mysymbol.Ask();


            if(StringFind(order_comment,"Bot" + "BUY" + exp_name) > -1)
               sl_position = NormalizaPreco(Buyprice - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);
            else
              {
               if(!isGrid)
                  sl_position = NormalizaPreco(Buyprice - _Stop * ponto);
               else
                  sl_position = NormalizaPreco(Buyprice - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);
              }

            tp_position = NormalizaPreco(Buyprice + _TakeProfit * ponto);
            if(mytrade.SellLimit(Lot,tp_position,original_symbol,0,0,order_time_type,0,"TAKE PROFIT"))
              {
               gv.Set("tp_vd_tick",(double)mytrade.ResultOrder());
               if(!mytrade.PositionModify(o_ticket,sl_position,0))
                 {
                  Print("Erro Modificar Posição: ",GetLastError());
                  DeleteALL();
                  CloseALL();
                 }
              }
            else
               Print("Erro enviar ordem: ",GetLastError());


            if(StringFind(order_comment,"Bot" + "BUY" + exp_name) > -1)
               Aumento_Grid(POSITION_TYPE_BUY);
            else
              {
               if(!UsarGrid)
                  Aumento_Posicao(POSITION_TYPE_BUY);
               else
                  Aumento_Grid(POSITION_TYPE_BUY);
              }
           }//Order Buy
         //--------------------------------------------------

         if(StringFind(order_comment,"SELL" + exp_name) > -1)
           {
            myposition.SelectByTicket(o_ticket);
            Sellprice = myposition.PriceOpen();
            int cont = 0;
            Sellprice = 0;
            while(Sellprice == 0 && cont < TENTATIVAS)
              {
               Sellprice = NormalizaPreco(myposition.PriceOpen());
               cont += 1;
              }
            if(Sellprice == 0)
               Sellprice = mysymbol.Bid();

            if(StringFind(order_comment,"Bot" + "SELL" + exp_name) > -1)
               sl_position = NormalizaPreco(Sellprice + (double)(nordens_grid * dist_grid * ponto) + SL_Grid * ponto);
            else
              {
               if(!isGrid)
                  sl_position = NormalizaPreco(Sellprice + _Stop * ponto);
               else
                  sl_position = NormalizaPreco(Sellprice + (double)(nordens_grid * dist_grid * ponto) + SL_Grid * ponto);
              }

            tp_position = NormalizaPreco(Sellprice - _TakeProfit * ponto);
            if(mytrade.BuyLimit(Lot,tp_position,original_symbol,0,0,order_time_type,0,"TAKE PROFIT"))
              {
               gv.Set("tp_cp_tick",(double)mytrade.ResultOrder());
               if(!mytrade.PositionModify(o_ticket,sl_position,0))
                 {
                  Print("Erro Modificar Posição: ",GetLastError());
                  DeleteALL();
                  CloseALL();
                 }
              }
            else
               Print("Erro enviar ordem: ",GetLastError());


            if(StringFind(order_comment,"Bot" + "SELL" + exp_name) > -1)
               Aumento_Grid(POSITION_TYPE_SELL);
            else
              {
               if(!UsarGrid)
                  Aumento_Posicao(POSITION_TYPE_SELL);
               else
                  Aumento_Grid(POSITION_TYPE_SELL);
              }

           }//Order Sell


         if(saida_sec > 0)
           {
            if(order_comment == "BUY_" + IntegerToString(saida_sec) + exp_name)
              {
               Print("Ativado Saída pela Média Secundária");
               close_buy_sec = 1.0;
              }
            if(order_comment == "SELL_" + IntegerToString(saida_sec) + exp_name)
              {
               Print("Ativado Saída pela Média Secundária");
               last_msg = "Ativar Méd. Sec.";
               close_sell_sec = 1.0;
              }
           }


         if(StringFind(order_comment,"FIRST_") > -1)
           {
            if(order_type == ORDER_TYPE_BUY_LIMIT)
              {
               //double limit_price = NormalizaPreco(PrecoMedio(POSITION_TYPE_BUY) + TP_Grid * ponto);
               double limit_price = NormalizaPreco(order_price + TP_Grid * ponto);

               string cmt = "TP_FIRST" + IntegerToString(o_ticket);
               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_SELL_LIMIT,lote_grid,0.0,limit_price,0,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem TP GRID: ",(string)GetLastError());

              }

            if(order_type == ORDER_TYPE_SELL_LIMIT)
              {


               //double limit_price = NormalizaPreco(PrecoMedio(POSITION_TYPE_SELL) - TP_Grid * ponto);
               double limit_price = NormalizaPreco(order_price - TP_Grid * ponto);

               string cmt = "TP_FIRST" + IntegerToString(o_ticket);
               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_BUY_LIMIT,lote_grid,0.0,limit_price,0,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem TP GRID: ",(string)GetLastError());

              }



           }// Fim Ordem First Grid

         if(StringFind(order_comment,"GRID_") > -1)
           {
            if(order_type == ORDER_TYPE_BUY_LIMIT)
              {
               double limit_price = NormalizaPreco(order_price + TP_Grid * ponto);
               string cmt = "TP_GRID" + IntegerToString(o_ticket);
               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_SELL_LIMIT,lote_grid,0.0,limit_price,0,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem TP GRID: ",(string)GetLastError());

              }

            if(order_type == ORDER_TYPE_SELL_LIMIT)
              {


               double limit_price = NormalizaPreco(order_price - TP_Grid * ponto);
               string cmt = "TP_GRID" + IntegerToString(o_ticket);
               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_BUY_LIMIT,lote_grid,0.0,limit_price,0,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem TP GRID: ",(string)GetLastError());

              }



           }// Fim Ordem Grid




         if(StringFind(order_comment,"TP_FIRST") > -1)
           {

            if(order_type == ORDER_TYPE_BUY_LIMIT)
              {

               string   cmt = "FIRST_" + exp_name;
               myposition.SelectByTicket((ulong)gv.Get("vd_tick"));
               sl_position = myposition.StopLoss();
               // preco_medio =preco_first;
               //double limit_price = NormalizaPreco(preco_medio + TP_Grid * ponto);
               double limit_price = preco_first;

               // sl_position = NormalizaPreco(bid - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);

               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_SELL_LIMIT,lote_grid,0.0,limit_price,sl_position,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem GRID: ",(string)GetLastError());

              }

            if(order_type == ORDER_TYPE_SELL_LIMIT)
              {


               string   cmt = "FIRST_" + exp_name;

               myposition.SelectByTicket((ulong)gv.Get("cp_tick"));
               sl_position = myposition.StopLoss();
               //   preco_medio = preco_first;
               // double limit_price = NormalizaPreco(preco_medio - TP_Grid * ponto);
               double limit_price = preco_first;

               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_BUY_LIMIT,lote_grid,0.0,limit_price,sl_position,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem GRID: ",(string)GetLastError());

              }

           }//Fim Ordem TP FIRST Grid



         if(StringFind(order_comment,"TP_GRID") > -1)
           {

            if(order_type == ORDER_TYPE_BUY_LIMIT)
              {

               double limit_price = NormalizaPreco(order_price + TP_Grid * ponto);
               string   cmt = "GRID_" + exp_name;
               myposition.SelectByTicket((ulong)gv.Get("vd_tick"));
               sl_position = myposition.StopLoss();
               // sl_position = NormalizaPreco(bid - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);

               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_SELL_LIMIT,lote_grid,0.0,limit_price,sl_position,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem GRID: ",(string)GetLastError());

              }

            if(order_type == ORDER_TYPE_SELL_LIMIT)
              {

               double limit_price = NormalizaPreco(order_price - TP_Grid * ponto);

               string   cmt = "GRID_" + exp_name;

               myposition.SelectByTicket((ulong)gv.Get("cp_tick"));
               sl_position = myposition.StopLoss();

               ResetLastError();
               if(!mytrade.OrderOpen(original_symbol,ORDER_TYPE_BUY_LIMIT,lote_grid,0.0,limit_price,sl_position,0,order_time_type,0,cmt))
                  Print("Erro Enviar Ordem GRID: ",(string)GetLastError());

              }

           }//Fim Ordem TP Grid



        }// Fim Order Filled
     }//Fim History ADD


   if(trans.type == TRADE_TRANSACTION_ORDER_UPDATE)
     {

      switch(trans.order_type)
        {
         case ORDER_TYPE_BUY:
         case ORDER_TYPE_SELL:
            switch(trans.order_state)
              {
               case ORDER_STATE_PLACED:
                  Print("Ordem com ticket ",trans.order," colocada com sucesso.");
                  break;
               case ORDER_STATE_CANCELED:
                  Print("Ordem com ticket ",trans.order," cancelada.");
                  break;
               case ORDER_STATE_STARTED:
                  Print("Ordem com ticket ",trans.order," iniciada.");
                  break;
               case ORDER_STATE_FILLED:
                  Print("Ordem com ticket ",trans.order," preenchida integralmente.");
                  break;
               case ORDER_STATE_PARTIAL:
                  Print("Ordem com ticket ",trans.order," preenchida parcialmente.");
                  break;
               case ORDER_STATE_EXPIRED:
                  Print("Ordem com ticket ",trans.order," expirou.");
                  break;
               case ORDER_STATE_REJECTED:
                  Print("Ordem com ticket ",trans.order," foi rejeitada.");
                  break;
              }
            break;
        }
     }//Fim TRADE_TRANSACTION_ORDER_UPDATE

   else
      if(trans.type == TRADE_TRANSACTION_REQUEST)
        {

         // Foi enviada uma nova ordem para o servidor
         if(request.magic != Magic_Number)
           {
            // A ordem nao foi deste EA, desconsidera a mesma
            //Print("Ordem recebida de um EA diferente, com Magic: ", request.magic);
            return;
           }

         if(request.action == TRADE_ACTION_DEAL)
           {
            if((result.retcode == TRADE_RETCODE_DONE) || (result.retcode == TRADE_RETCODE_PLACED))
              {
               Print("Ordem de ",(request.type == ORDER_TYPE_BUY ? "compra" : "venda")," executada com sucesso.");
              }
            else
              {
               Print("Erro enviando ordem de ",(request.type == ORDER_TYPE_BUY ? "compra" : "venda"),": ",result.retcode);
              }
           }

        }//Fim TRADE_TRANSACTION_REQUEST



  }// Fim OnTradeTransaction



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MyRobot::GridIndexPosition(ulong o_ticket)
  {
   int idx_pos = -1;
   for(int i = 0; i < (int)nordens_grid; i++)
     {
      if(array_OrdensGrid[i].tick == o_ticket)
         idx_pos = i;
      break;
     }
   return idx_pos;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MyRobot::GridIndexPositionTP(ulong o_ticket)
  {
   int idx_pos = -1;
   for(int i = 0; i < (int)nordens_grid; i++)
     {
      if(array_OrdensGrid[i].tick_tp == o_ticket)
         idx_pos = i;
      break;
     }
   return idx_pos;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::CloseTPByPosition()
  {
   string tp_comment = "";
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      if(myposition.SelectByIndex(i))
        {
         ulong ticket = myposition.Ticket();
         if(ticket <= 0 || myposition.Symbol() != original_symbol)
            continue;
         //---
         if(myposition.Magic() != Magic_Number)
            continue;

         tp_comment = myposition.Comment();
         int start = StringFind(tp_comment,"TP_GRID");
         if(start > -1)
           {
            long ticket_by = StringToInteger(StringSubstr(tp_comment,start + 7));
            if(ticket_by > 0)
              {
               if(mytrade.PositionCloseBy(ticket,ticket_by))
                  continue;
              }

           }


         tp_comment = myposition.Comment();
         start = StringFind(tp_comment,"TP_FIRST");
         if(start > -1)
           {
            long ticket_by = StringToInteger(StringSubstr(tp_comment,start + 8));
            if(ticket_by > 0)
              {
               if(mytrade.PositionCloseBy(ticket,ticket_by))
                  continue;
              }

           }

        }
     }

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::Atual_vol_Stop_Take()
  {

   if(pos_open)
     {


      if(isBuyOpen)
        {

         if(myorder.Select((ulong)gv.Get("tp_vd_tick")))
           {
            vol_pos = VolPosType(POSITION_TYPE_BUY);
            vol_stp = myorder.VolumeInitial();
            preco_stp = myorder.PriceOpen();

            if(vol_pos != vol_stp)
              {
               if(mytrade.OrderDelete((ulong)gv.Get("tp_vd_tick")))
                 {
                  if(mytrade.SellLimit(vol_pos,preco_stp,original_symbol,0,0,order_time_type,0,"TAKE PROFIT"))
                     gv.Set("tp_vd_tick",(double)mytrade.ResultOrder());
                 }
              }
           }

        }
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
      if(isSellOpen)
        {

         if(myorder.Select((ulong)gv.Get("tp_cp_tick")))
           {
            vol_pos = VolPosType(POSITION_TYPE_SELL);
            vol_stp = myorder.VolumeInitial();
            preco_stp = myorder.PriceOpen();

            if(vol_pos != vol_stp)
              {
               if(mytrade.OrderDelete((ulong)gv.Get("tp_cp_tick")))
                 {
                  if(mytrade.BuyLimit(vol_pos,preco_stp,original_symbol,0,0,order_time_type,0,"TAKE PROFIT"))
                     gv.Set("tp_cp_tick",(double)mytrade.ResultOrder());
                 }
              }
           }
        }
     }

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::ZeroStop()
  {

   if(pos_open)
     {
      // double vol_buy = VolPosType(POSITION_TYPE_BUY);
      //double vol_sell = VolPosType(POSITION_TYPE_SELL);

      for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
         if(myposition.SelectByIndex(i))
           {
            sl_position = myposition.StopLoss();
            //ticket_pos = myposition.Ticket();
            //vol_pos = myposition.Volume();
            if(myposition.Symbol() != mysymbol.Name())
               continue;
            if(myposition.Magic() != Magic_Number)
               continue;
            if(sl_position > 0)
               continue;
            if(sl_position == 0)
              {
               DeleteALL();
               CloseALL();
               Print("Fechando Posições. Posição Sem Stop!");
              }//SL=0
           }//Select Position
        }// fim for



     }//pos_open


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::BreakEven(string pSymbol,bool usarbreak,double &pBreakEven[],double &pLockProfit[])
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(myposition.SelectByIndex(i) && myposition.Magic() == Magic_Number && usarbreak == true)
        {

         long posType = myposition.PositionType();
         ulong posTicket = myposition.Ticket();
         double currentSL = myposition.StopLoss();
         double openPrice = NormalizeDouble(MathRound(myposition.PriceOpen() / ticksize) * ticksize,digits);
         double currentTP = myposition.TakeProfit();
         double breakEvenStop;
         double currentProfit;

         if(posType == POSITION_TYPE_BUY)
           {
            bid = SymbolInfoDouble(pSymbol,SYMBOL_BID);
            currentProfit = bid - openPrice;
            //Break Even 0 a 1
            for(int k = 0; k < 2; k++)
              {
               if(currentProfit >= pBreakEven[k]*ponto && currentProfit < pBreakEven[k + 1]*ponto)
                 {
                  breakEvenStop = openPrice + pLockProfit[k] * ponto;
                  breakEvenStop = MathRound(breakEvenStop / ticksize) * ticksize;
                  if(currentSL < breakEvenStop || currentSL == 0)
                    {
                     Print("Break even stop:");
                     mytrade.PositionModify(posTicket,breakEvenStop,currentTP);

                    }
                 }
              }
            //----------------------
            //Break Even 2
            if(currentProfit >= pBreakEven[2]*ponto)
              {
               breakEvenStop = openPrice + pLockProfit[2] * ponto;
               breakEvenStop = MathRound(breakEvenStop / ticksize) * ticksize;
               if(currentSL < breakEvenStop || currentSL == 0)
                 {
                  Print("Break even stop:");
                  mytrade.PositionModify(posTicket,breakEvenStop,currentTP);

                 }
              }
           }
         //----------------------

         //----------------------

         if(posType == POSITION_TYPE_SELL)
           {
            ask = SymbolInfoDouble(pSymbol,SYMBOL_ASK);
            currentProfit = openPrice - ask;
            //Break Even 0 a 1
            for(int k = 0; k < 2; k++)
              {
               if(currentProfit >= pBreakEven[k]*ponto && currentProfit < pBreakEven[k + 1]*ponto)
                 {
                  breakEvenStop = openPrice - pLockProfit[k] * ponto;
                  breakEvenStop = MathRound(breakEvenStop / ticksize) * ticksize;
                  if(currentSL > breakEvenStop || currentSL == 0)
                    {
                     Print("Break even stop:");
                     mytrade.PositionModify(posTicket,breakEvenStop,currentTP);

                    }
                 }
              }
            //----------------------
            //Break Even 2
            if(currentProfit >= pBreakEven[2]*ponto)
              {
               breakEvenStop = openPrice - pLockProfit[2] * ponto;
               breakEvenStop = MathRound(breakEvenStop / ticksize) * ticksize;
               if(currentSL > breakEvenStop || currentSL == 0)
                 {
                  Print("Break even stop:");
                  mytrade.PositionModify(posTicket,breakEvenStop,currentTP);

                 }

              }
            //----------------------

           }

        } //Fim Position Select

     }//Fim for
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::Painel(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   int buttons_space = ALT_BUTONS + INDENT_TOP;
   int space_x = INDENT_LEFT;
   int xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   int yy1 = buttons_space + y1 + INDENT_TOP + CONTROLS_GAP_Y;
   int xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   int yy2 = int(yy1 + BUTTON_HEIGHT);


   painel_head.Create(chart,name + "head",subwin,x1,y1,x2,(int)(y1 + 0.2 * (y2 - y1)));
   painel_head.ColorBackground(clrDarkGray);
   painel_head.BorderType(BORDER_RAISED);
   painel_head.ColorBorder(clrYellow);

   painel_middle.Create(chart,name + "middle",subwin,x1,(int)(y1 + 0.2 * (y2 - y1)),x2,y2);
   painel_middle.ColorBackground(clrLightGray);
   painel_middle.BorderType(BORDER_RAISED);
   painel_middle.ColorBorder(clrNavy);




//--- create dependent controls

   m_label[0].Create(chart,"labelmensal",subwin,xx1,yy1,xx2,yy2);
   m_label[0].Text("Lucro Men.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalMes(),2));


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);


   m_label[1].Create(chart,"labelsemanal",subwin,xx1,yy1,xx2,yy2);
   m_label[1].Text("Lucro Sem.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalSemana(),2));

   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 2 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);

   m_label[2].Create(chart,"labeldiario",subwin,xx1,yy1,xx2,yy2);
   m_label[2].Text("Lucro Dia: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotal(),2));


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 3 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);

   m_label[3].Create(chart,"labelgap",subwin,xx1,yy1,xx2,yy2);
   string s_gap = "Não";
   if(Gap())
      s_gap = "Sim";
   m_label[3].Text("Gap Lim: " + DoubleToString(pts_gap,digits) + " Atingido: " + s_gap);


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 4 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);

   m_label[4].Create(chart,"label pontos gap",subwin,xx1,yy1,xx2,yy2);
   m_label[4].Text("Pontos Gap: " + DoubleToString(Pts_Gap(),digits));

   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 5 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);


   string s_pos = "--";
   double painel_vol = 0.0;
   if(isBuyOpen)
      if(ultimo_sinal == SINAL_BUY)
        {
         s_pos = "BUY";
         painel_vol = VolPosType(POSITION_TYPE_BUY);
        }

   if(isSellOpen)
      if(ultimo_sinal == SINAL_SELL)
        {
         s_pos = "SELL";
         painel_vol = VolPosType(POSITION_TYPE_SELL);
        }

   string str_label_pos = StringFormat("Pos: %s Vol: %.2f Lucro %.2f",s_pos,painel_vol,lucro_positions);

   m_label[5].Create(chart,"label posicao atual",subwin,xx1,yy1,xx2,yy2);

   m_label[5].Text(str_label_pos);


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 6 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);


   m_label[6].Create(chart,"label lastmsg",subwin,xx1,yy1,xx2,yy2);
   m_label[6].Text(last_msg);


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 7 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);


   m_label[7].Create(chart,"label dx",subwin,xx1,yy1,xx2,yy2);
   m_label[7].Text("Dx: " + DoubleToString(valor_dx,digits));



   for(int i = 0; i < 8; i++)
     {
      m_label[i].Color(clrBlack);
      m_label[i].FontSize(11);
      m_label[i].Font("Arial");

     }

//--- succeed


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::PainelOntick()
  {

   m_label[0].Text("Lucro Men.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalMes(),2));

   m_label[1].Text("Lucro Sem.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalSemana(),2));
   m_label[2].Text("Lucro Dia: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotal(),2));

   string s_gap = "Não";
   if(Gap())
      s_gap = "Sim";
   m_label[3].Text("Gap Lim.: " + DoubleToString(pts_gap,digits) + " Atingido: " + s_gap);
   m_label[4].Text("Pontos Gap: " + DoubleToString(Pts_Gap(),digits));



   string s_pos = "--";
   double painel_vol = 0.0;
   if(isBuyOpen)
      if(ultimo_sinal == SINAL_BUY)
        {
         s_pos = "BUY";
         painel_vol = VolPosType(POSITION_TYPE_BUY);
        }

   if(isSellOpen)
      if(ultimo_sinal == SINAL_SELL)
        {
         s_pos = "SELL";
         painel_vol = VolPosType(POSITION_TYPE_SELL);
        }

   string str_label_pos = StringFormat("Pos: %s Vol: %.2f Lucro %.2f",s_pos,painel_vol,lucro_positions);


   m_label[5].Text(str_label_pos);




   m_label[6].Text(last_msg);
   m_label[7].Text("Dx: " + DoubleToString(valor_dx,digits));


  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::PainelKey(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   int buttons_space = ALT_BUTONS + INDENT_TOP;
   int space_x = INDENT_LEFT;
   int xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   int yy1 = buttons_space + y1 + INDENT_TOP + CONTROLS_GAP_Y;
   int xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   int yy2 = int(yy1 + BUTTON_HEIGHT);


   painel_head.Create(chart,name + "head",subwin,x1,y1,x2,(int)(y1 + 0.2 * (y2 - y1)));
   painel_head.ColorBackground(clrDarkGray);
   painel_head.BorderType(BORDER_RAISED);
   painel_head.ColorBorder(clrYellow);

   painel_middle.Create(chart,name + "middle",subwin,x1,(int)(y1 + 0.2 * (y2 - y1)),x2,y2);
   painel_middle.ColorBackground(clrLightGray);
   painel_middle.BorderType(BORDER_RAISED);
   painel_middle.ColorBorder(clrNavy);




//--- create dependent controls

   m_label[0].Create(chart,"labelmensal",subwin,xx1,yy1,xx2,yy2);
   m_label[0].Text("Lucro Men.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalMes(),2));


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);


   m_label[1].Create(chart,"labelsemanal",subwin,xx1,yy1,xx2,yy2);
   m_label[1].Text("Lucro Sem.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalSemana(),2));

   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 2 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);

   m_label[2].Create(chart,"labeldiario",subwin,xx1,yy1,xx2,yy2);
   m_label[2].Text("Lucro Dia: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotal(),2));


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 3 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);


   string s_pos = "--";
   double painel_vol = 0.0;
   if(isBuyOpen)
      if(ultimo_sinal == SINAL_BUY)
        {
         s_pos = "BUY";
         painel_vol = VolPosType(POSITION_TYPE_BUY);
        }

   if(isSellOpen)
      if(ultimo_sinal == SINAL_SELL)
        {
         s_pos = "SELL";
         painel_vol = VolPosType(POSITION_TYPE_SELL);
        }

   string str_label_pos = StringFormat("Pos: %s Vol: %.2f Lucro %.2f",s_pos,painel_vol,lucro_positions);

   m_label[3].Create(chart,"label posicao atual",subwin,xx1,yy1,xx2,yy2);

   m_label[3].Text(str_label_pos);


   xx1 = space_x + x1 + int(0.7 * INDENT_LEFT);
   yy1 = buttons_space + y1 + int(INDENT_TOP + 4 * BUTTON_HEIGHT + CONTROLS_GAP_Y);
   xx2 = int(xx1 + 0.7 * BUTTON_WIDTH);
   yy2 = int(yy1 + BUTTON_HEIGHT);

   m_label[4].Create(chart,"label lastmsg",subwin,xx1,yy1,xx2,yy2);
   m_label[4].Text(last_msg);



   for(int i = 0; i < 5; i++)
     {
      m_label[i].Color(clrBlack);
      m_label[i].FontSize(11);
      m_label[i].Font("Arial");

     }

//--- succeed


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::PainelKeyOntick()
  {

   m_label[0].Text("Lucro Men.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalMes(),2));

   m_label[1].Text("Lucro Sem.: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotalSemana(),2));
   m_label[2].Text("Lucro Dia: " + MyEA.GetCurrency() + " " + DoubleToString(MyEA.LucroTotal(),2));



   string s_pos = "--";
   double painel_vol = 0.0;
   if(isBuyOpen)
      if(ultimo_sinal == SINAL_BUY)
        {
         s_pos = "BUY";
         painel_vol = VolPosType(POSITION_TYPE_BUY);
        }

   if(isSellOpen)
      if(ultimo_sinal == SINAL_SELL)
        {
         s_pos = "SELL";
         painel_vol = VolPosType(POSITION_TYPE_SELL);
        }

   string str_label_pos = StringFormat("Pos: %s Vol: %.2f Lucro %.2f",s_pos,painel_vol,lucro_positions);


   m_label[3].Text(str_label_pos);




   m_label[4].Text(last_msg);


  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::CreateButtons()
  {

   click_button_buy = click_button_sell = click_button_close = false;
   string fonte = "Source Coder Pro";
   int fonte_size = 10;

   int text_shift = 30;
   color BuysButtonColor = SeaGreen; // Buys Button Color
   color SellsButtonColor = Crimson; // Sells Button Color
   color CloseButtonColor = clrAqua; // Zerar Button Color


   color ButtonsTextColor = White; // Text Color
   ENUM_BASE_CORNER ButtonsPositionCorner = CORNER_LEFT_UPPER; // Buttons Position Corner
   int BuysButtonPositionX = 2 * INDENT_LEFT; // Buys Button Position X
   int BuysButtonPositionY = 2 * INDENT_TOP - 2; // Buys Button Position Y
   int SellsButtonPositionX = BuysButtonPositionX + LARG_BUTONS + 10; // Sells Button Position X
   int SellsButtonPositionY = 2 * INDENT_TOP - 2; // Sells Button Position Y

   int CloseButtonPositionX = BuysButtonPositionX + 2 * LARG_BUTONS + 20; // Sells Button Position X
   int CloseButtonPositionY = 2 * INDENT_TOP - 2; // Sells Button Position Y



   string on;


   on = exp_name + EnumToString(BuyButton) + IntegerToString(Magic_Number);

   ObjectCreate(0,on,OBJ_BUTTON,0,0,0);
   ObjectSetString(0,on,OBJPROP_TEXT,"Buy");
   ObjectSetString(0,on,OBJPROP_FONT,fonte);
   ObjectSetInteger(0,on,OBJPROP_FONTSIZE,fonte_size);

   ObjectSetInteger(0,on,OBJPROP_WIDTH,0);
   ObjectSetInteger(0,on,OBJPROP_FILL,true);
   ObjectSetInteger(0,on,OBJPROP_BGCOLOR,BuysButtonColor);
   ObjectSetInteger(0,on,OBJPROP_CORNER,ButtonsPositionCorner);
   ObjectSetInteger(0,on,OBJPROP_XDISTANCE,BuysButtonPositionX);
   ObjectSetInteger(0,on,OBJPROP_YDISTANCE,BuysButtonPositionY);
   ObjectSetInteger(0,on,OBJPROP_XSIZE,LARG_BUTONS);
   ObjectSetInteger(0,on,OBJPROP_YSIZE,ALT_BUTONS);
   ObjectSetInteger(0,on,OBJPROP_STATE,false);

   ObjectSetInteger(0,on,OBJPROP_BACK,false);
   ObjectSetInteger(0,on,OBJPROP_ZORDER,1);
   ObjectSetInteger(0,on,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,on,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,on,OBJPROP_HIDDEN,true);










   on = exp_name + EnumToString(SellButton) + IntegerToString(Magic_Number);
   ObjectCreate(0,on,OBJ_BUTTON,0,0,0);
   ObjectSetString(0,on,OBJPROP_TEXT,"Sell");
   ObjectSetString(0,on,OBJPROP_FONT,fonte);
   ObjectSetInteger(0,on,OBJPROP_FONTSIZE,fonte_size);

   ObjectSetInteger(0,on,OBJPROP_WIDTH,0);
   ObjectSetInteger(0,on,OBJPROP_FILL,true);
   ObjectSetInteger(0,on,OBJPROP_BGCOLOR,SellsButtonColor);
   ObjectSetInteger(0,on,OBJPROP_CORNER,ButtonsPositionCorner);
   ObjectSetInteger(0,on,OBJPROP_XDISTANCE,SellsButtonPositionX);
   ObjectSetInteger(0,on,OBJPROP_YDISTANCE,SellsButtonPositionY);
   ObjectSetInteger(0,on,OBJPROP_XSIZE,LARG_BUTONS);
   ObjectSetInteger(0,on,OBJPROP_YSIZE,ALT_BUTONS);
   ObjectSetInteger(0,on,OBJPROP_STATE,false);

   ObjectSetInteger(0,on,OBJPROP_BACK,false);
   ObjectSetInteger(0,on,OBJPROP_ZORDER,1);
   ObjectSetInteger(0,on,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,on,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,on,OBJPROP_HIDDEN,true);


   on = exp_name + EnumToString(CloseButton) + IntegerToString(Magic_Number);

   ObjectCreate(0,on,OBJ_BUTTON,0,0,0);
   ObjectSetString(0,on,OBJPROP_TEXT,"Zerar");
   ObjectSetString(0,on,OBJPROP_FONT,fonte);
   ObjectSetInteger(0,on,OBJPROP_FONTSIZE,fonte_size);

   ObjectSetInteger(0,on,OBJPROP_WIDTH,0);
   ObjectSetInteger(0,on,OBJPROP_FILL,true);
   ObjectSetInteger(0,on,OBJPROP_BGCOLOR,CloseButtonColor);
   ObjectSetInteger(0,on,OBJPROP_CORNER,ButtonsPositionCorner);
   ObjectSetInteger(0,on,OBJPROP_XDISTANCE,CloseButtonPositionX);
   ObjectSetInteger(0,on,OBJPROP_YDISTANCE,CloseButtonPositionY);
   ObjectSetInteger(0,on,OBJPROP_XSIZE,LARG_BUTONS);
   ObjectSetInteger(0,on,OBJPROP_YSIZE,ALT_BUTONS);
   ObjectSetInteger(0,on,OBJPROP_STATE,false);
   ObjectSetInteger(0,on,OBJPROP_BACK,false);
   ObjectSetInteger(0,on,OBJPROP_ZORDER,1);
   ObjectSetInteger(0,on,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,on,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,on,OBJPROP_HIDDEN,true);


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MyRobot::OnChartEvent(const int id,// event ID
                           const long & lparam,  // event parameter of the long type
                           const double & dparam, // event parameter of the double type
                           const string & sparam) // event parameter of the string type
  {

   if(id == CHARTEVENT_OBJECT_CLICK)

     {

      if(sparam == exp_name + EnumToString(BuyButton) + IntegerToString(Magic_Number))
        {

         bool estado = (bool)ObjectGetInteger(0,sparam,OBJPROP_STATE);
         PrintFormat("Botao clicado %s. Estado do botão: %s",EnumToString(BuyButton),(string)estado);

         if(estado)
           {
            isGrid = true;

            // click_button_close = true;
            color BuysButtonColor = SeaGreen; // Buys Button Color
            // color SellsButtonColor = Crimson; // Sells Button Color
            //color CloseButtonColor = clrAqua; // Zerar Button Color

            last_msg = "Botão Compra";
            PrintFormat("Estado: %s",(string)estado);

            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,clrYellow);

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Wait...");

            bid = SymbolInfoDouble(original_symbol,SYMBOL_BID);
            ask = SymbolInfoDouble(original_symbol,SYMBOL_ASK);

            tradebarra = false;
            time_int_ent = TimeCurrent();
            DeleteALL();
            if(isSellOpen)
               ClosePosType(POSITION_TYPE_SELL);
            sl_position = 0;
            tp_position = 0;

            sl_position = NormalizaPreco(bid - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);
            if(_TakeProfit > 0)
               tp_position = NormalizeDouble(ask + _TakeProfit * ponto,digits);

            if(mytrade.PositionOpen(original_symbol,ORDER_TYPE_BUY,Lot,0,sl_position,tp_position,"Bot" + "BUY" + exp_name))
               //   if(mytrade.Buy(Lot,original_symbol,0,sl_position,tp_position,"BUY" + exp_name))
              {
               ticket_pos = mytrade.ResultOrder();
               gv.Set("cp_tick",(double)ticket_pos);
               ultimo_sinal = SINAL_BUY;
              }
            else
               Print("Erro enviar ordem ",GetLastError());




            ObjectSetString(0,sparam,OBJPROP_TEXT,"Buy");
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,BuysButtonColor);
            ObjectSetInteger(0,sparam,OBJPROP_STATE,!estado);

           }


        }

      if(sparam == exp_name + EnumToString(SellButton) + IntegerToString(Magic_Number))
        {

         bool estado = (bool)ObjectGetInteger(0,sparam,OBJPROP_STATE);
         PrintFormat("Botao clicado %s. Estado do botão: %s",EnumToString(SellButton),(string)estado);

         if(estado)
           {

            isGrid = true;
            // click_button_close = true;
            //   color BuysButtonColor = SeaGreen; // Buys Button Color
            color SellsButtonColor = Crimson; // Sells Button Color
            //color CloseButtonColor = clrAqua; // Zerar Button Color

            last_msg = "Botão Venda";
            PrintFormat("Estado: %s",(string)estado);

            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,clrYellow);

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Wait...");

            bid = SymbolInfoDouble(original_symbol,SYMBOL_BID);
            ask = SymbolInfoDouble(original_symbol,SYMBOL_ASK);

            tradebarra = false;
            time_int_ent = TimeCurrent();
            DeleteALL();
            if(isBuyOpen)
               ClosePosType(POSITION_TYPE_BUY);
            sl_position = 0;
            tp_position = 0;

            sl_position = NormalizaPreco(ask + (double)(nordens_grid * dist_grid * ponto) + SL_Grid * ponto);
            if(_TakeProfit > 0)
               tp_position = NormalizeDouble(bid - _TakeProfit * ponto,digits);
            if(mytrade.PositionOpen(original_symbol,ORDER_TYPE_SELL,Lot,0,sl_position,tp_position,"Bot" + "SELL" + exp_name))
               //            if(mytrade.Sell(Lot,original_symbol,0,sl_position,tp_position,"SELL" + exp_name))
              {
               ticket_pos = mytrade.ResultOrder();
               gv.Set("vd_tick",(double)ticket_pos);
               ultimo_sinal = SINAL_SELL;
              }
            else
               Print("Erro enviar ordem ",GetLastError());




            ObjectSetString(0,sparam,OBJPROP_TEXT,"Sell");
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,SellsButtonColor);
            ObjectSetInteger(0,sparam,OBJPROP_STATE,!estado);

           }


        }

      if(sparam == exp_name + EnumToString(CloseButton) + IntegerToString(Magic_Number))
        {
         bool estado = (bool)ObjectGetInteger(0,sparam,OBJPROP_STATE);
         PrintFormat("Botao clicado %s. Estado do botão: %s",EnumToString(CloseButton),(string)estado);
         if(estado)
           {

            // click_button_close = true;
            // color BuysButtonColor = SeaGreen; // Buys Button Color
            // color SellsButtonColor = Crimson; // Sells Button Color
            color CloseButtonColor = clrAqua; // Zerar Button Color


            PrintFormat("Estado: %s",(string)estado);

            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,clrYellow);

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Wait...");
            MyEA.DeleteALL();
            MyEA.CloseALL();


            ObjectSetString(0,sparam,OBJPROP_TEXT,"Zerar");
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,CloseButtonColor);
            ObjectSetInteger(0,sparam,OBJPROP_STATE,!estado);

           }
        }
     }

  }



void MyRobot::BotaoBackTest(Objects botao)

  {
   string sparam;
   switch(botao)
     {
      case BuyButton:
        {
         sparam = exp_name + EnumToString(BuyButton) + IntegerToString(Magic_Number);
         bool estado = (bool)ObjectGetInteger(0,sparam,OBJPROP_STATE);

         if(estado)
           {
            PrintFormat("Botao clicado %s. Estado do botão: %s",EnumToString(BuyButton),(string)estado);
            isGrid = true;

            // click_button_close = true;
            color BuysButtonColor = SeaGreen; // Buys Button Color
            // color SellsButtonColor = Crimson; // Sells Button Color
            //color CloseButtonColor = clrAqua; // Zerar Button Color

            last_msg = "Botão Compra";
            PrintFormat("Estado: %s",(string)estado);

            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,clrYellow);

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Wait...");

            bid = SymbolInfoDouble(original_symbol,SYMBOL_BID);
            ask = SymbolInfoDouble(original_symbol,SYMBOL_ASK);

            tradebarra = false;
            time_int_ent = TimeCurrent();
            DeleteALL();
            if(isSellOpen)
               ClosePosType(POSITION_TYPE_SELL);
            sl_position = 0;
            tp_position = 0;

            sl_position = NormalizaPreco(bid - (double)(nordens_grid * dist_grid * ponto) - SL_Grid * ponto);
            if(_TakeProfit > 0)
               tp_position = NormalizeDouble(ask + _TakeProfit * ponto,digits);

            if(mytrade.PositionOpen(original_symbol,ORDER_TYPE_BUY,Lot,0,sl_position,tp_position,"Bot" + "BUY" + exp_name))
               //   if(mytrade.Buy(Lot,original_symbol,0,sl_position,tp_position,"BUY" + exp_name))
              {
               ticket_pos = mytrade.ResultOrder();
               gv.Set("cp_tick",(double)ticket_pos);
               ultimo_sinal = SINAL_BUY;
              }
            else
               Print("Erro enviar ordem ",GetLastError());

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Buy");
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,BuysButtonColor);
            ObjectSetInteger(0,sparam,OBJPROP_STATE,!estado);

           }

         break;
        }
      case SellButton:
        {
         sparam = exp_name + EnumToString(SellButton) + IntegerToString(Magic_Number);
         bool estado = (bool)ObjectGetInteger(0,sparam,OBJPROP_STATE);

         if(estado)
           {
            PrintFormat("Botao clicado %s. Estado do botão: %s",EnumToString(SellButton),(string)estado);
            isGrid = true;
            // click_button_close = true;
            //   color BuysButtonColor = SeaGreen; // Buys Button Color
            color SellsButtonColor = Crimson; // Sells Button Color
            //color CloseButtonColor = clrAqua; // Zerar Button Color

            last_msg = "Botão Venda";
            PrintFormat("Estado: %s",(string)estado);

            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,clrYellow);

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Wait...");

            bid = SymbolInfoDouble(original_symbol,SYMBOL_BID);
            ask = SymbolInfoDouble(original_symbol,SYMBOL_ASK);

            tradebarra = false;
            time_int_ent = TimeCurrent();
            DeleteALL();
            if(isBuyOpen)
               ClosePosType(POSITION_TYPE_BUY);
            sl_position = 0;
            tp_position = 0;

            sl_position = NormalizaPreco(ask + (double)(nordens_grid * dist_grid * ponto) + SL_Grid * ponto);
            if(_TakeProfit > 0)
               tp_position = NormalizeDouble(bid - _TakeProfit * ponto,digits);
            if(mytrade.PositionOpen(original_symbol,ORDER_TYPE_SELL,Lot,0,sl_position,tp_position,"Bot" + "SELL" + exp_name))
               //            if(mytrade.Sell(Lot,original_symbol,0,sl_position,tp_position,"SELL" + exp_name))
              {
               ticket_pos = mytrade.ResultOrder();
               gv.Set("vd_tick",(double)ticket_pos);
               ultimo_sinal = SINAL_SELL;
              }
            else
               Print("Erro enviar ordem ",GetLastError());

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Sell");
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,SellsButtonColor);
            ObjectSetInteger(0,sparam,OBJPROP_STATE,!estado);

           }

         break;
        }
      case CloseButton:
        {
         sparam = exp_name + EnumToString(CloseButton) + IntegerToString(Magic_Number);
         bool estado = (bool)ObjectGetInteger(0,sparam,OBJPROP_STATE);
         if(estado)
           {
            PrintFormat("Botao clicado %s. Estado do botão: %s",EnumToString(CloseButton),(string)estado);

            // click_button_close = true;
            // color BuysButtonColor = SeaGreen; // Buys Button Color
            // color SellsButtonColor = Crimson; // Sells Button Color
            color CloseButtonColor = clrAqua; // Zerar Button Color

            PrintFormat("Estado: %s",(string)estado);
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,clrYellow);
            ObjectSetString(0,sparam,OBJPROP_TEXT,"Wait...");
            MyEA.DeleteALL();
            MyEA.CloseALL();

            ObjectSetString(0,sparam,OBJPROP_TEXT,"Zerar");
            ObjectSetInteger(0,sparam,OBJPROP_BGCOLOR,CloseButtonColor);
            ObjectSetInteger(0,sparam,OBJPROP_STATE,!estado);

           }
         break;
        }
     }//fim switch
  }


//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool MyRobot::TimeDayFilter()
  {
   bool filter;
   MqlDateTime TimeToday;
   TimeToStruct(TimeCurrent(),TimeToday);
   switch(TimeToday.day_of_week)
     {
      case 0:
         filter = trade0;
         break;
      case 1:
         filter = trade1;
         break;
      case 2:
         filter = trade2;
         break;
      case 3:
         filter = trade3;
         break;
      case 4:
         filter = trade4;
         break;
      case 5:
         filter = trade5;
         break;
      case 6:
         filter = trade6;
         break;
      default:
         filter = false;
         break;

     }
   return filter;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction & trans,
                        const MqlTradeRequest & request,
                        const MqlTradeResult & result)
  {
   MyEA.OnTradeTransaction(trans,request,result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {


   if(!ChartSetInteger(ChartID(),CHART_SHIFT,0,LARGURA_PAINEL + 30))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__ + ", Error Code = ",GetLastError());
     }


   return MyEA.OnInit();

//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   MyEA.OnTimer();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

//--- Código de motivo de desinicialização
   Print(__FUNCTION__," UninitializeReason() = ",getUninitReasonText(UninitializeReason()));
   MyEA.OnDeinit(reason);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   MyEA.OnTick();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,// event ID
                  const long & lparam,  // event parameter of the long type
                  const double & dparam, // event parameter of the double type
                  const string & sparam) // event parameter of the string type
  {
   MyEA.OnChartEvent(id,lparam,dparam,sparam);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ChartWidthInPixels(const long chart_ID = 0)
  {
//--- prepare the variable to get the property value
   long result = -1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_WIDTH_IN_PIXELS,0,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__ + ", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ChartHeightInPixelsGet(const long chart_ID = 0,const int sub_window = 0)
  {
//--- prepare the variable to get the property value
   long result = -1;
//--- reset the error value
   ResetLastError();
//--- receive the property value
   if(!ChartGetInteger(chart_ID,CHART_HEIGHT_IN_PIXELS,sub_window,result))
     {
      //--- display the error message in Experts journal
      Print(__FUNCTION__ + ", Error Code = ",GetLastError());
     }
//--- return the value of the chart property
   return((int)result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
string getUninitReasonText(int reasonCode)
  {
   string text = "";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//---
   switch(reasonCode)
     {
      case REASON_ACCOUNT:
         text = "Account was changed";
         break;
      case REASON_CHARTCHANGE:
         text = "Symbol or timeframe was changed";
         break;
      case REASON_CHARTCLOSE:
         text = "Chart was closed";
         break;
      case REASON_PARAMETERS:
         text = "Input-parameter was changed";
         break;
      case REASON_RECOMPILE:
         text = "Program " + __FILE__ + " was recompiled";
         break;
      case REASON_REMOVE:
         text = "Program " + __FILE__ + " was removed from chart";
         break;
      case REASON_TEMPLATE:
         text = "New template was applied to chart";
         break;
      default:
         text = "Another reason";
     }
//---
   return text;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Returns the text description of a transaction                    |
//+------------------------------------------------------------------+
string TransactionDescription(const MqlTradeTransaction &trans,
                              const bool detailed = true)
  {
//--- prepare a string for returning from the function
   string desc = EnumToString(trans.type) + "\r\n";
//--- all possible data is added in detailed mode
   if(detailed)
     {
      desc += "Symbol: " + trans.symbol + "\r\n";
      desc += "Deal ticket: " + (string)trans.deal + "\r\n";
      desc += "Deal type: " + EnumToString(trans.deal_type) + "\r\n";
      desc += "Order ticket: " + (string)trans.order + "\r\n";
      desc += "Order type: " + EnumToString(trans.order_type) + "\r\n";
      desc += "Order state: " + EnumToString(trans.order_state) + "\r\n";
      desc += "Order time type: " + EnumToString(trans.time_type) + "\r\n";
      desc += "Order expiration: " + TimeToString(trans.time_expiration) + "\r\n";
      desc += "Price: " + StringFormat("%G",trans.price) + "\r\n";
      desc += "Price trigger: " + StringFormat("%G",trans.price_trigger) + "\r\n";
      desc += "Stop Loss: " + StringFormat("%G",trans.price_sl) + "\r\n";
      desc += "Take Profit: " + StringFormat("%G",trans.price_tp) + "\r\n";
      desc += "Volume: " + StringFormat("%G",trans.volume) + "\r\n";
     }
//--- return a received string
   return desc;
  }
//+------------------------------------------------------------------+
//| Returns the text description of the trade request                |
//+------------------------------------------------------------------+
string RequestDescription(const MqlTradeRequest &request,
                          const bool detailed = true)
  {
//--- prepare a string for returning from the function
   string desc = EnumToString(request.action) + "\r\n";
//--- add all available data in detailed mode
   if(detailed)
     {
      desc += "Symbol: " + request.symbol + "\r\n";
      desc += "Magic Number: " + StringFormat("%d",request.magic) + "\r\n";
      desc += "Order ticket: " + (string)request.order + "\r\n";
      desc += "Order type: " + EnumToString(request.type) + "\r\n";
      desc += "Order filling: " + EnumToString(request.type_filling) + "\r\n";
      desc += "Order time type: " + EnumToString(request.type_time) + "\r\n";
      desc += "Order expiration: " + TimeToString(request.expiration) + "\r\n";
      desc += "Price: " + StringFormat("%G",request.price) + "\r\n";
      desc += "Deviation points: " + StringFormat("%G",request.deviation) + "\r\n";
      desc += "Stop Loss: " + StringFormat("%G",request.sl) + "\r\n";
      desc += "Take Profit: " + StringFormat("%G",request.tp) + "\r\n";
      desc += "Stop Limit: " + StringFormat("%G",request.stoplimit) + "\r\n";
      desc += "Volume: " + StringFormat("%G",request.volume) + "\r\n";
      desc += "Comment: " + request.comment + "\r\n";
     }
//--- return the received string
   return desc;
  }
//+------------------------------------------------------------------+
//| Returns the text description of request handling result          |
//+------------------------------------------------------------------+
string TradeResultDescription(const MqlTradeResult &result,
                              const bool detailed = true)
  {
//--- prepare the string for returning from the function
   string desc = "Retcode " + (string)result.retcode + "\r\n";
//--- add all available data in detailed mode
   if(detailed)
     {
      desc += "Request ID: " + StringFormat("%d",result.request_id) + "\r\n";
      desc += "Order ticket: " + (string)result.order + "\r\n";
      desc += "Deal ticket: " + (string)result.deal + "\r\n";
      desc += "Volume: " + StringFormat("%G",result.volume) + "\r\n";
      desc += "Price: " + StringFormat("%G",result.price) + "\r\n";
      desc += "Ask: " + StringFormat("%G",result.ask) + "\r\n";
      desc += "Bid: " + StringFormat("%G",result.bid) + "\r\n";
      desc += "Comment: " + result.comment + "\r\n";
     }
//--- return the received string
   return desc;
  }
//+------------------------------------------------------------------+
