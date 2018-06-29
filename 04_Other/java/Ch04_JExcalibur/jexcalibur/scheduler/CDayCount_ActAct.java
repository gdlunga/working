package jexcalibur.scheduler;

import java.util.*;

public class CDayCount_ActAct implements IDayCount {

		
		/**
		 */
		public double Calculate(GregorianCalendar begin, GregorianCalendar end)
		{
			CDateUtility        util        = new CDateUtility();

			double divisore	= -1;
			double days		=  0;
			
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
			
			/* dates are converted into julian numbers */
			long lbegin	= util.DateToJulian(begin);
			long lend 	= util.DateToJulian(end);

			days = (double)(lend - lbegin);
					
			return days/divisore;
		}

}
