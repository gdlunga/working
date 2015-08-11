package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CInterval_Annual implements IInterval {

	public int period() {
		// TODO Auto-generated method stub
		return GregorianCalendar.YEAR;
	}

	public int periodMultiplier() {
		// TODO Auto-generated method stub
		return 1;
	}
	
	public String periodCode() {
		return "1Y";
	}

}
