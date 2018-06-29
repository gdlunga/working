package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CDayCount_A30360 implements IDayCount {

	public double Calculate(GregorianCalendar begin, GregorianCalendar end){

		int dayBegin 	= begin.get(GregorianCalendar.DAY_OF_MONTH);
		int dayEnd		= end.get(GregorianCalendar.DAY_OF_MONTH);
		int day  		= dayBegin;
		
		if(dayBegin == 31) day = 30;
		if(dayEnd   == 31 && dayBegin == 30) dayEnd = 30;
		
		double divisore	=	360.0;
		double days 	= (double)
		      ((end.get(GregorianCalendar.YEAR) - begin.get(GregorianCalendar.YEAR))*360 
			  +(end.get(GregorianCalendar.MONTH) - begin.get(GregorianCalendar.MONTH))*30 
			  +(dayEnd-day));
		
		return days/divisore;
	}

}
