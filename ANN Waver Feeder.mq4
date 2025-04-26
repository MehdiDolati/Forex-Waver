//+------------------------------------------------------------------+
//|                                                   ANN Feeder.mq4 |
//|                                   Copyright © 2012, Mehdi Dolati |
//|                                                      ocw.mit.edu |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Mehdi Dolati"
#property link      "ocw.mit.edu"

int startDate = 1991;

int Tenkan=9;
int Kijun=26;
int Senkou=52;

int ExtDepth=12;
int ExtDeviation=5;
int ExtBackstep=3;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
   string sym = Symbol();
   string File_Name = sym + Period() + " Waver ANN.csv";
   int Handle=FileOpen(File_Name ,FILE_CSV|FILE_WRITE,",");
   if(Handle<0)
   {
      if(GetLastError()==4103)
         Alert("There is no file named ",File_Name, ". Please create one.");
      else
         Alert("Error while opening file ",File_Name);
      PlaySound("Bzrrr.wav");
      return;
   }
   else
   {
    if (FileWrite(Handle, "Index", "Date", "Yesterday", "Last Week", "Last Month", "Last Year",
                          "YO", "YH", "YL", "YC", "Open", "LWO", "LWH", "LWL", "LWC", "Hour", "Day", 
                          "ATRW", "ATRM", "ATRY", "MAW", "MAM", "MAY", 
                          "Tenkansen", "Kijunsen", "Span A", "Span B", "Waver", "+Waver", "Waver +0.5",
                          "Waver -0.5", "Waver +0.2", "Waver -0.2","Waver Sign", "+Waver 0.5", "+Waver 0.2")<0)
        Alert(GetLastError());
   }
   int counter = 0;
   for (int i = Bars; i >= 0; i--)
   {
      if (TimeYear(Time[i]) >= startDate && iCustom(NULL,0,"Waver",ExtDepth,ExtDeviation,ExtBackstep,0,i) != 0)
      {
         counter++;
         int LastWeek = 6;
         int LastMonth = 24;
         int LastYear = 250;
         bool loopFlag = false;
         int today;
         int oonday;
         if (Period() == 1440)
         {
            while(true)
            {
               LastWeek++;
               if (!loopFlag && TimeDayOfWeek(Time[i+LastWeek]) != (TimeDayOfWeek(Time[i]) - LastWeek))
                  if (TimeDayOfWeek(Time[i+LastWeek]) == 5 || TimeDayOfWeek(Time[i+LastWeek]) == 6)
                     loopFlag = true;
               if (loopFlag && (TimeDayOfWeek(Time[i]) >= TimeDayOfWeek(Time[i+LastWeek]) || LastWeek >=6))
               {
                  today = TimeDayOfWeek(Time[i]);
                  oonday = TimeDayOfWeek(Time[i+LastWeek]);
                  break;
               }
            }
            loopFlag = false;
            while(true)
            {
               LastMonth++;
               if (!loopFlag && TimeMonth(Time[i+LastMonth]) != TimeMonth(Time[i]))
                  loopFlag = true;
               if (loopFlag)
                  if (TimeDay(Time[i]) >= TimeDay(Time[i+LastMonth]))
                     break;
                  else if (TimeYear(Time[i]) > TimeYear(Time[i+LastMonth]))
                  {
                     if (TimeMonth(Time[i+LastMonth]) - TimeMonth(Time[i]) < 11)
                        break;
                  }
                  else if (TimeMonth(Time[i+LastMonth]) < TimeMonth(Time[i]) - 1)
                     break;
            }
            loopFlag = false;
            while(true)
            {
               LastYear++;
               if (!loopFlag && TimeYear(Time[i+LastYear]) != TimeYear(Time[i]))
                  loopFlag = true;
               if (loopFlag && TimeDayOfYear(Time[i]) >= TimeDayOfYear(Time[i+LastYear]))
                  break;
               else if (TimeYear(Time[i+LastYear]) < TimeYear(Time[i]) - 1)
                  break;
            }
         }
         double Waver = iCustom(NULL,0,"Waver",ExtDepth,ExtDeviation,ExtBackstep,0,i);
         double WaverPlus = Waver;
         if (WaverPlus < 0)
            WaverPlus = -WaverPlus;
            
         int Waver05 = 0;
         if (Waver > 0.5)
            Waver05 = 1;
         
         int Waver05M = 0;
         if (Waver < -0.5)
            Waver05M = 1;
            
         int Waver02 = 0;
         if (Waver > 0.2)
            Waver02 = 1;
            
         int Waver02M = 0;
         if (Waver < -0.2)
            Waver02M = 1;
         
         int WaverSign = 0;
         if (Waver > 0)
            WaverSign = 1;
         
         int Waver05P = 0;
         if (WaverPlus > 0.5)
            Waver05P = 1;
         
         int Waver02P = 0;
         if (WaverPlus > 0.2)
            Waver02P = 1;
                  
         FileWrite(Handle,counter, TimeToStr(Time[i]), TimeToStr(Time[i+1]), TimeToStr(Time[i + LastWeek]), 
                                   TimeToStr(Time[i + LastMonth]), TimeToStr(Time[i + LastYear]), 
                                   Open[i + 1], High[i + 1], Low[i + 1], Close[i + 1], Open[i],
                                   Open[i + LastWeek], High[i + LastWeek], Low[i + LastWeek],
                                   Close[i + LastWeek], TimeHour(Time[i]), TimeDayOfWeek(Time[i]), iATR(sym,  0, LastWeek, i+1),
                                   iATR(sym,  0, LastMonth, i+1), iATR(sym,  0, LastYear, i+1), iMA(sym,0, LastWeek, 0, MODE_SMA, PRICE_CLOSE, i+1), 
                                   iMA(sym,0, LastMonth, 0, MODE_SMA, PRICE_CLOSE, i+1), iMA(sym,0, LastYear, 0, MODE_SMA, PRICE_CLOSE, i+1),
                                   iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_TENKANSEN, i+1),
                                   iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_KIJUNSEN, i+1),
                                   iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANA, i+1),
                                   iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANB, i+1),
                                   Waver, WaverPlus,Waver05, Waver05M, Waver02, Waver02M, WaverSign, Waver05P, Waver02P);
      }
   }
   FileClose(Handle);
 //----
   return(0);
  }
//+------------------------------------------------------------------+