package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CInterval_Quarterly implements IInterval {

	public int period() {
		// TODO Auto-generated method stub
		return GregorianCalendar.MONTH;
	}

	public int periodMultiplier() {
		// TODO Auto-generated method stub
		return 3;
	}
	
	public String periodCode(){
		return "3M";
	}

}
