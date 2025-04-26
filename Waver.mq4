//+------------------------------------------------------------------+
//|                                               MarketStrenght.mq4 |
//|                                    Copyright 2012, Mehdi Dolati  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, Mehdi Dolati"
#property link      ""
extern int ExtDepth=12;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Lime
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1
#property indicator_minimum -1
#property indicator_maximum 1

double LastWaveEnd=0;
double NextWaveStart=0;
double WaveLengh=0;
double B[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,B);
   SetIndexDrawBegin(0,0);
   SetIndexLabel(0,NULL);
   IndicatorShortName("Waver("+ExtDepth+","+ExtDeviation+","+ExtBackstep+")");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int BarCounter=IndicatorCounted();
   int  pos=Bars-BarCounter-1;
    
   for (int i=pos;i>=0;i--)
   {
      if (LastWaveEnd == 0)
      {
         while (iCustom(NULL,0,"ZigZag",ExtDepth, ExtDeviation, ExtBackstep,0,i) == 0 && i>0)
            i--;
         LastWaveEnd = iCustom(NULL,0,"ZigZag",ExtDepth, ExtDeviation, ExtBackstep,0,i);
         int j = i-1;
         while (iCustom(NULL,0,"ZigZag",ExtDepth, ExtDeviation, ExtBackstep,0,j) == 0 && j>0)
            j--;
         NextWaveStart = iCustom(NULL,0,"ZigZag",ExtDepth, ExtDeviation, ExtBackstep,0,j);
      }
      if (High[i] == NextWaveStart || Low[i] == NextWaveStart)
      {
         LastWaveEnd = NextWaveStart;
         j = i-1;
         while (iCustom(NULL,0,"ZigZag",ExtDepth, ExtDeviation, ExtBackstep,0,j) == 0 && j>0)
            j--;
         if (j<=0)
            NextWaveStart = LastWaveEnd;
         else
            NextWaveStart = iCustom(NULL,0,"ZigZag",ExtDepth, ExtDeviation, ExtBackstep,0,j);
      }
      WaveLengh = NextWaveStart - LastWaveEnd;
      if (WaveLengh > 0)
         B[i] = (NextWaveStart - Open[i]) / WaveLengh;
      else if (WaveLengh < 0)
         B[i] = (Open[i] - NextWaveStart) / WaveLengh;
      else B[i] = 0;
   }
   return(0);
  }
//+------------------------------------------------------------------+  