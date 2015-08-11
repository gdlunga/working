package jexcalibur.scheduler;


public class CDayAdjustment_Factory {

	public static final int unadjusted = 0;
	public static final int preceding = 1;
	public static final int following = 2;
	public static final int modpreceding = 3;
	public static final int modfollowing = 4;
		
		/**
		 */
		public IDayAdjustment createInstance(int code)
		{
			switch(code)
			{
			case preceding:
				return new CDayAdjustment_Preceding();
			case following:
				return new CDayAdjustment_Following();
			case modpreceding:
				return new CDayAdjustment_ModPreceding();
			case modfollowing:
				return new CDayAdjustment_ModFollowing();
			default:
				return null;	
			}
		
		}
}
