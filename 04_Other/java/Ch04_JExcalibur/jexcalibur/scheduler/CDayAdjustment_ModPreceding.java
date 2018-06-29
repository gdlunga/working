package jexcalibur.scheduler;

import java.util.*;

public class CDayAdjustment_ModPreceding implements IDayAdjustment {

	public void modify(GregorianCalendar date) 
	{
		CDayAdjustment_Following fadj = new CDayAdjustment_Following();
		CDayAdjustment_Preceding padj = new CDayAdjustment_Preceding();

		// TODO Auto-generated method stub
		GregorianCalendar temp = (GregorianCalendar)date.clone();
		
		padj.modify(date);
		if(temp.get(GregorianCalendar.MONTH) != date.get(GregorianCalendar.MONTH))
		{
			fadj.modify(temp);
            date.setTime(temp.getTime());		
		}
	}

}
