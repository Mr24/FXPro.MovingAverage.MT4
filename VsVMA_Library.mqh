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
#property description "VsV.MT4.MovingAverage - Ver.0.6.2 Update:2017.01.11"

#include <MovingAverages.mqh>

//--- MovingAverage : Indicator parameters
input int             InpMAPeriod=200;        // Period
input int             InpMAShift=0;          // Shift
input ENUM_MA_METHOD  InpMAMethod=MODE_EMA;  // Method
input int             InpLevels=5;

//--- MovingAverage : Indicator buffer
//### MA.Main ###//
double ExtMainBuffer[];
//### Levels ###//
double ExtTop100Buffer[];
double ExtBtm100Buffer[];
double ExtTop200Buffer[];
double ExtBtm200Buffer[];



//+------------------------------------------------------------------+
//| Custom Indicator Initialization Function                         |
//+------------------------------------------------------------------+
int OnMAInit(void)
{
	string sInpLevel;
	int l,ll;

//--- 1 additional buffer used for counting.
 	// IndicatorBuffers(5);
 	IndicatorBuffers(InpLevels);  
  	IndicatorDigits(Digits);
  
//--- MovingAverage : Drawing Settings
//+ MA.Main
  	SetIndexStyle(0,DRAW_LINE);
  	SetIndexShift(0,InpMAShift);
  	SetIndexLabel(0,"MA.Main");

//+ Top.100
	for(l=1;l<InpLevels;l++)
	{
		ll = l/2;
    	
    	if(l % 2 == 0)
    	{
      		sInpLevel = (string)ll;

      		SetIndexStyle(l,DRAW_LINE);
      		SetIndexShift(l,InpMAShift);
      		SetIndexLabel(l,"Btm."+sInpLevel+"00");
      		continue;
      	}
    	else
    	{
      		ll = ll+1;
      		sInpLevel = (string)ll;

		    SetIndexStyle(l,DRAW_LINE);
      		SetIndexShift(l,InpMAShift);
      		SetIndexLabel(l,"Top."+sInpLevel+"00");
      		continue;
    	}
	}

//--- MovingAverage : Indicator Buffers Mapping
	SetIndexBuffer(0,ExtMainBuffer);
	SetIndexBuffer(1,ExtTop100Buffer);
	SetIndexBuffer(2,ExtBtm100Buffer);
	SetIndexBuffer(3,ExtTop200Buffer);
	SetIndexBuffer(4,ExtBtm200Buffer);


	return 0;
}


//+------------------------------------------------------------------+
//| Exponential Moving Average                                       |
//+------------------------------------------------------------------+
int OnMACalculate(const int total,const int prev, const double &price[])
{

//--- MovingAverage.Calucurate.Setup ---//
  int i,limit;
  double p=1.0;

//--- Check for Bars Count
  if(total<InpMAPeriod-1 || InpMAPeriod<2)
    return(0);

//--- Counting from 0 to rates_total
	ArraySetAsSeries(ExtMainBuffer,false);  //# OLD => New
	ArraySetAsSeries(ExtTop100Buffer,false);  //# OLD => New
  	ArraySetAsSeries(ExtBtm100Buffer,false);  //# OLD => New
  	ArraySetAsSeries(ExtTop200Buffer,false);  //# OLD => New
  	ArraySetAsSeries(ExtBtm200Buffer,false);  //# OLD => New
  	ArraySetAsSeries(price,false);          //# OLD => New

//--- First Calculation or Number of Bars was Changed
	if(prev==0)
	{
    	ArrayInitialize(ExtMainBuffer,0); //# ExtMainBuffer=0 : ALL
    	ArrayInitialize(ExtTop100Buffer,0);
    	ArrayInitialize(ExtBtm100Buffer,0);
    	ArrayInitialize(ExtTop200Buffer,0);
    	ArrayInitialize(ExtBtm200Buffer,0);

    	limit=InpMAPeriod;
    	ExtMainBuffer[0]=price[0];

    
    	for(i=1;i<limit;i++)
    	{
      		ExtMainBuffer[i]=ExponentialMA(i,InpMAPeriod,ExtMainBuffer[i-1],price);
      		ExtTop100Buffer[i]=OnMALevelsCalculate(1,ExtMainBuffer[i]);
      		ExtBtm100Buffer[i]=OnMALevelsCalculate(2,ExtMainBuffer[i]);
      		ExtTop200Buffer[i]=OnMALevelsCalculate(3,ExtMainBuffer[i]);
      		ExtBtm200Buffer[i]=OnMALevelsCalculate(4,ExtMainBuffer[i]);
      	}
    }

//--- Main Loop Calculation
	else
    limit=prev-1;

  	for( i=limit; i<total && !IsStopped(); i++ )
  	{
    	ExtMainBuffer[i]=ExponentialMA(i,InpMAPeriod,ExtMainBuffer[i-1],price);
    	ExtTop100Buffer[i]=OnMALevelsCalculate(1,ExtMainBuffer[i]);
    	ExtBtm100Buffer[i]=OnMALevelsCalculate(2,ExtMainBuffer[i]);
    	ExtTop200Buffer[i]=OnMALevelsCalculate(3,ExtMainBuffer[i]);
    	ExtBtm200Buffer[i]=OnMALevelsCalculate(4,ExtMainBuffer[i]);
  	}

  	return 0;

}




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


//+------------------------------------------------------------------+
//| MovingAverage : Level BufferArray                                |
//+------------------------------------------------------------------+
double MALevelBuffer(const string sLevels)
{
	string ExtTop="ExtTop"+sLevels+"00Buffer[]";
	//# double ExtTop100Buffer[];

	return(StrToDouble(ExtTop));
}




