package jexcalibur.scheduler;


public class CInterval_Factory {

	public static final int daily		= 0;	
	public static final int weekly		= 1;	
	public static final int biweekly	= 2;	
	public static final int monthly		= 3;	
	public static final int quarterly	= 4;	
	public static final int fourmonthly	= 5;	
	public static final int semiannual	= 6;	
	public static final int annual		= 7;	
	public static final int expiry		= 9;	   
	public static final int bimonthly   = 10;   
	
	public IInterval createInstance(int code)
	{
		switch(code)
		{
		case daily:
			return new CInterval_Daily();
		case monthly:
			return new CInterval_Monthly();
		case quarterly:
			return new CInterval_Quarterly();
		case semiannual:
			return new CInterval_Semiannual();
		case annual:
			return new CInterval_Annual();
		case bimonthly:
			return new CInterval_Bimonthly();
		}
		return null;
	}
}
