//+------------------------------------------------------------------+
//|                       VerysVeryInc.MetaTrader4.MovingAverege.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                                         https://github.com/Mr24/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/"
#property description "VsV.MT4.MovingAverage - Ver.0.1.1 Update:2017.01.11"

#include <MovingAverages.mqh>

double ExtTop200Buffer[];

//+------------------------------------------------------------------+
//| Custom Indicator Initialization Function                         |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| Exponential Moving Average                                       |
//+------------------------------------------------------------------+
double OnMACalculate(const int position,const int period,const double &bb,const double &price[])
{	
	double result=0.0;
	double p=1.0;
	result = bb+(p/10);

	return(result);
}


//+------------------------------------------------------------------+
//| MovingAverage : Level BufferArray                                |
//+------------------------------------------------------------------+
double MALevelBuffer(const string sLevels)
{
	string ExtTop="ExtTop"+sLevels+"00Buffer[]";
	//# double ExtTop100Buffer[];

	return(StrToDouble(ExtTop));
}




