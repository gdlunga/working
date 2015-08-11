package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CInterval_Daily implements IInterval {

	public int period() {
		// TODO Auto-generated method stub
		return GregorianCalendar.DAY_OF_MONTH;
	}

	public int periodMultiplier() {
		// TODO Auto-generated method stub
		return 1;
	}

	public String periodCode() {
		// TODO Auto-generated method stub
		return "1D";
	}

}
