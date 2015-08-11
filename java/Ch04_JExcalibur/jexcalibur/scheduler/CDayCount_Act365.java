package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CDayCount_Act365 implements IDayCount {

	public double Calculate(GregorianCalendar begin, GregorianCalendar end){
		
		long                lbegin      = 0;
		long                lend        = 0;
		double 				divisore 	= 365.0;
		double              days        = 0.0;
		CDateUtility        util        = new CDateUtility();
		
		/* dates are converted into julian numbers */
		lbegin 	= util.DateToJulian(begin);
		lend	= util.DateToJulian(end);

		days = (double)(lend - lbegin);
		
		return days/divisore;
	}

}
