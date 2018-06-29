/**
 * 
 */
package jexcalibur.scheduler;

/** 
 * @author Giovanni Della Lunga
 */
public class CDayCount_Factory {

	public static final int _actact = 0;
	public static final int _365act = 1;
	public static final int _act365 = 2;
	public static final int _act360 = 3;
	public static final int _a30360 = 4;
	public static final int _e30360 = 5;
	public static final int _365360 = 6;
	public static final int _365365 = 7;

	/**
	 */
	public IDayCount createInstance(int code)
	{
		switch(code)
		{
		case _actact:
			return new CDayCount_ActAct();
		case _365act:
			return new CDayCount_NLAct();
		case _act365:
			return new CDayCount_Act365();
		case _act360:
			return new CDayCount_Act360();
		case _a30360:
			return new CDayCount_A30360();
		case _e30360:
			return new CDayCount_E30360();
		case _365360:
			return new CDayCount_365360();
		case _365365:
			return new CDayCount_365365();
		default:
				return null;
		}
		
	}




}
