//+------------------------------------------------------------------+
//|                       VerysVeryInc.MetaTrader4.MovingAverege.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                                         https://github.com/Mr24/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                       Custom Moving Averages.mq4 |
//|                   Copyright 2005-2015, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
//|                                              Band Moving Average |
//|                                        Copyright 2009, EarnForex |
//|                                        http://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/"
#property description "VsV.MT4.MovingAverage - Ver.0.4.1 Update:2017.01.06"
#property strict

#include <MovingAverages.mqh>

//--- MovingAverage : Initial Setup ---//
#property indicator_chart_window
#property indicator_buffers 2
//+ MA.Main
#property indicator_color1  Red
#property indicator_type1   DRAW_LINE
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//+ Top.100
#property indicator_color2  LightGoldenrod
#property indicator_type2   DRAW_LINE
#property indicator_style2  STYLE_DOT
#property indicator_width2  1


//--- MovingAverage : Indicator parameters
input int            InpMAPeriod=200;        // Period
input int            InpMAShift=0;          // Shift
input ENUM_MA_METHOD InpMAMethod=MODE_EMA;  // Method

//--- MovingAverage : Indicator buffer
double ExtMainBuffer[];
double ExtTop100Buffer[];

//+------------------------------------------------------------------+
//| Custom Indicator Initialization Function                         |
//+------------------------------------------------------------------+
int OnInit(void)
{
  string short_name;
  int    draw_begin=0;

//--- MovingAverage : Indicator Short Name
  short_name="EMA(";
  IndicatorShortName(short_name+string(InpMAPeriod)+")");

//--- 1 additional buffer used for counting.
  IndicatorBuffers(2);  
  IndicatorDigits(Digits);
  
//--- MovingAverage : Drawing Settings
//+ MA.Main
  SetIndexStyle(0,DRAW_LINE);
  SetIndexShift(0,InpMAShift);
  SetIndexLabel(0,"MA.Main");
//+ Top.100
  SetIndexStyle(1,DRAW_LINE);
  SetIndexShift(1,InpMAShift);
  SetIndexLabel(1,"Top.100");


//--- MovingAverage : Indicator Buffers Mapping
  SetIndexBuffer(0,ExtMainBuffer);
  SetIndexBuffer(1,ExtTop100Buffer);

//--- MovingAverage : Drawing Begin
  SetIndexDrawBegin(0,draw_begin);
  SetIndexDrawBegin(1,draw_begin);
  //# SetIndexDrawBegin(0,InpMAPeriod+InpMAShift);


//--- MovingAverage : Initialization Done
  return(INIT_SUCCEEDED);

}
//***//


//+------------------------------------------------------------------+
//|  Moving Average                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

//--- MovingAverage.Calucurate.Setup ---//
  int i,limit;
  double p=1.0;

//--- Check for Bars Count
  if(rates_total<InpMAPeriod-1 || InpMAPeriod<2)
    return(0);

//--- Counting from 0 to rates_total
  ArraySetAsSeries(ExtMainBuffer,false);  //# OLD => New
  ArraySetAsSeries(ExtTop100Buffer,false);  //# OLD => New
  ArraySetAsSeries(close,false);          //# OLD => New

//--- First Calculation or Number of Bars was Changed
  if(prev_calculated==0)
  {
    ArrayInitialize(ExtMainBuffer,0); //# ExtMainBuffer=0 : ALL
    ArrayInitialize(ExtTop100Buffer,0);

    limit=InpMAPeriod;
    ExtMainBuffer[0]=close[0];

    for(i=1;i<limit;i++)
    {
      ExtMainBuffer[i]=ExponentialMA(i,InpMAPeriod,ExtMainBuffer[i-1],close);
      ExtTop100Buffer[i]=ExtMainBuffer[i]+(p/10);
    }
  }

//--- Main Loop Calculation
  else
    limit=prev_calculated-1;

  for( i=limit; i<rates_total && !IsStopped(); i++ )
  {
     ExtMainBuffer[i]=ExponentialMA(i,InpMAPeriod,ExtMainBuffer[i-1],close);
     ExtTop100Buffer[i]=ExtMainBuffer[i]+(p/10);
  }

//--- MovingAverage.Calucurate.End ---//


//--- Return Value of prev_calculated for Next Call
  return(rates_total);

}

//+------------------------------------------------------------------+
