package jexcalibur.scheduler;

import java.util.*;

public class CDateUtility {

	public boolean IsHoliday(GregorianCalendar date)
	{
		return(date.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY || 
			   date.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY);
	}
	
	public long DateToJulian(int d, int m, int y)
	{
        long julian = (long)(( 1461 * ( y + 4800 + ( m - 14 ) / 12 ) ) / 4 +
        ( 367 * ( m - 2 - 12 * ( ( m - 14 ) / 12 ) ) ) / 12 -
        ( 3 * ( ( y + 4900 + ( m - 14 ) / 12 ) / 100 ) ) / 4 +
        d - 32075);      
		
		return julian;
	}
	
	public long DateToJulian(GregorianCalendar date)
	{
		int d = date.get(Calendar.DAY_OF_MONTH);
		int m = date.get(Calendar.MONTH);
		int y = date.get(Calendar.YEAR);
		
		long julian = (long)(( 1461 * ( y + 4800 + ( m - 14 ) / 12 ) ) / 4 +
                ( 367 * ( m - 2 - 12 * ( ( m - 14 ) / 12 ) ) ) / 12 -
                ( 3 * ( ( y + 4900 + ( m - 14 ) / 12 ) / 100 ) ) / 4 +
                d - 32075);      
        		
   		return julian;
	}
}
