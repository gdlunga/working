package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CInterval_Monthly implements IInterval {

	public int period() {
		// TODO Auto-generated method stub
		return GregorianCalendar.MONTH;
	}

	public int periodMultiplier() {
		// TODO Auto-generated method stub
		return 1;
	}
	
	public String periodCode(){
		return "1M";
	}

}
