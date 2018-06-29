package jexcalibur.scheduler;

import java.util.GregorianCalendar;


public class CDayCount_NLAct implements jexcalibur.scheduler.IDayCount {

	public double Calculate(GregorianCalendar begin, GregorianCalendar end)
	{
		int                 leaps       = 0;
		long                lbegin      = 0;
		long                lend        = 0;
		double 				divisore 	= -1;
		double              days        = 0.0;
		GregorianCalendar 	currentDate = new GregorianCalendar();
		CDateUtility        util        = new CDateUtility();
		
		/* In the next loop we count how many leap days there are 
		 * between begin and end.
		 */
		currentDate = (GregorianCalendar)begin.clone();
		do
		{
			if(currentDate.get(GregorianCalendar.DAY_OF_MONTH) == 29 && 
			   currentDate.get(GregorianCalendar.MONTH)        == GregorianCalendar.FEBRUARY)
			{
				leaps++;
			}
			currentDate.add(GregorianCalendar.DAY_OF_MONTH,1);
		}while(currentDate.before(end));
		/* dates are converted into julian numbers. */
		lbegin 	= util.DateToJulian(begin);
		lend	= util.DateToJulian(end);
		/* finally we count elapsed days between begin and end and 
		 * subtract from this result the number of leap days.
		 */
		days = (double)(lend - lbegin - leaps);		
		
		int february 	= GregorianCalendar.FEBRUARY;
		int beginMonth	= begin.get(GregorianCalendar.MONTH);
		int endMonth	= end.get(GregorianCalendar.MONTH);
		int beginYear	= begin.get(GregorianCalendar.YEAR);
		int endYear		= end.get(GregorianCalendar.YEAR);
		
		if((beginMonth < february && endMonth > february) && 
			(begin.isLeapYear(beginYear) || end.isLeapYear(endYear)))
			divisore = 366.0;
		else
			divisore = 365.0;
		
		
		return days/divisore;
	}

}
