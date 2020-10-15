#include <Trade\Trade.mqh>
CTrade trade;

input double lowRSI = 30;         // LOW RSI - BUY POINT
input double highRSI = 70;        // HIGH RSI - SELL POINT
input double stopLoss = 200;      // STOP LOSS POINTS
input double takeProfit = 400;    // TAKE PROFIT POINTS
input double lotSize = 0.01;      // TRADING LOT SIZE (1 = 100,000$)
input int periodRSI = 14;         // RSI PERIOD - BY DEFAULT 14 CANDLES


void OnTick()
  {
  
  
   double myRSIArray[];
   double myRSIValue;
   
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits); // MARKET ASK PRICE
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits); // MARKET BID PRICE
  
   
   MqlRates PriceInfo[];
   
   
   int myRSIDef = iRSI(_Symbol, _Period, periodRSI, PRICE_CLOSE);
   
   ArraySetAsSeries(PriceInfo, true);
   ArraySetAsSeries(myRSIArray, true);
   
   CopyBuffer(myRSIDef, 0, 0, 3, myRSIArray);
   
   myRSIValue = NormalizeDouble(myRSIArray[0], 2);
   
   Comment("RSI Value: ", myRSIValue);
  
   
   int PriceData = CopyRates(
   
      _Symbol, // Current Symbol
      _Period, // Time Frame
      0,       // Start (First Candle)
      3,       // End (3 Candles)
      PriceInfo
      
   
   );
   
   // if the candle is bullish
   if(PriceInfo[1].close > PriceInfo[1].open) {
      // If we have no open positions and rsi low
      if((PositionsTotal() == 0) && myRSIValue < lowRSI) {
      
         trade.Buy( // LONG TRADE
         
            lotSize,                        //LOT SIZE
            NULL,                        // CURRENT SYMBOL
            Ask,                         // PRICE
            Ask - stopLoss * _Point,   // STOP LOSS PRICE
            Ask + takeProfit * _Point, // TAKE PROFIT PRICE
            NULL                         // COMMENT
         
         );
      
      }
      
    }
    
    
    // if the candle is bearish
    if(PriceInfo[1].close < PriceInfo[1].open) {
      
      // no positions open and rsa is high
      if((PositionsTotal() == 0) && myRSIValue > highRSI) {
      
         trade.Sell( // MARKET ORDER SHORT TRADE
         
            lotSize,                      //LOT SIZE
            NULL,                      // CURRENT SYMBOL
            Bid,                       // PRICE
            Bid + stopLoss * _Point,   // STOP LOSS PRICE
            Bid - takeProfit * _Point, // TAKE PROFIT PRICE
            NULL                       // COMMENT
         
         );
      
      }
      
    }
    
    
    // LIMIT ORDER
    
     /*
   
   if(PriceInfo[1].close < PriceInfo[1].open) {
   
      if((PositionsTotal() == 0) && (myRSIValue > 70) && (OrdersTotal() == 0)) {
      
         trade.SellLimit( // LIMIT ORDER SHORT TRADE
         
            lotSize,                 //LOT SIZE
            (Ask + (20 * _Point)),
            _Symbol,                 // CURRENT SYMBOL
            Bid + 150 * _Point, // STOP LOSS PRICE
            Bid - 300 * _Point, // TAKE PROFIT PRICE
            ORDER_TIME_DAY,     // ORDER EXPARATION
            0,                  // EXPARATION DATE 
            NULL                  // COMMENT
         
         );
      
      }
      */
      
      
   
  }
  
  
