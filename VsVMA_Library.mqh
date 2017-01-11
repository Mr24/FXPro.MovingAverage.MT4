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
#property description "VsV.MT4.MovingAverage - Ver.0.5.3 Update:2017.01.11"

#include <MovingAverages.mqh>

// double ExtTop200Buffer[];

//+------------------------------------------------------------------+
//| Custom Indicator Initialization Function                         |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//| Exponential Moving Average                                       |
//+------------------------------------------------------------------+
double OnMALevelsCalculate(const int levels,
						   const double MainBuffer)
{
	double result=0.0;
	double p=1.0;
	int l=levels/2;
	double ll;
	// double ll=(double)levels/2;

	if(levels%2==0)
	{
		ll = (double)l;
		result=MainBuffer-(ll*p/10);
		// result=MainBuffer-(ll*p/10);
		// result=MainBuffer-((levels/2)*p/10);
		// result=MainBuffer-(p/10);
	}
	else
	{
		l=l+1;
		ll = (double)l;
		result=MainBuffer+(ll*p/10);
		// result=MainBuffer+((ll+1)*p/10);
		// l=levels/2;
		// ll = (double)l;
		// result=MainBuffer+((levels/2+1)*p/10);
		// result=MainBuffer+(p/10);
	}

	return(result);

}
/*
// double OnMACalculate(const int position,const int period,const double &bb,const double &price[])
double OnMACalculate(const int levels,
					 const int position,
					 const int period,
					 const double bb,
					 const double prev_value,
					 const double &price[])
{	
	double result=0.0;
	double p=1.0;

	if(levels==0) {
		result = ExponentialMA(position,InpMAPeriod,prev_value,price);
	}

	if(levels % 2 == 0)
	{
		result = bb-(p/10);	
	} 
	
	else
	{
		result = bb+(p/10);
	}

	/*
	//# double result=0.0;
	//# double p=1.0;
	//# result = bb+(p/10);
	

	return(result);
}

*/

//+------------------------------------------------------------------+
//| MovingAverage : Level BufferArray                                |
//+------------------------------------------------------------------+
double MALevelBuffer(const string sLevels)
{
	string ExtTop="ExtTop"+sLevels+"00Buffer[]";
	//# double ExtTop100Buffer[];

	return(StrToDouble(ExtTop));
}




