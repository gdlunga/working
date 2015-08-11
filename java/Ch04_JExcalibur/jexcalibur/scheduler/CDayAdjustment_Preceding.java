package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CDayAdjustment_Preceding implements IDayAdjustment {

	public void modify(GregorianCalendar date) 
	{
		// TODO Auto-generated method stub
		do
		{
			date.add(GregorianCalendar.DATE,-1);
		}while(dateUtility.IsHoliday(date));
	}

}
