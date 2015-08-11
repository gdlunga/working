package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public class CInterval_Bimonthly implements IInterval {

	public int period() {
		// TODO Auto-generated method stub
		return GregorianCalendar.MONTH;
	}

	public int periodMultiplier() {
		// TODO Auto-generated method stub
		return 2;
	}

	public String periodCode() {
		// TODO Auto-generated method stub
		return "2M";
	}

}
