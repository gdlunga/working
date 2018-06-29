package finobject;


public abstract class CPayoff 
{
	/* attributes */
	
	protected String 	description = "";
	protected double 	strike		= 0;
	protected double[] 	strikes		= null;
	protected CBarrier 	barrier		= null;
	
	/* inspectors */
	
	public double 	getStrike()		{return strike;}
	public double[] getStrikes()	{return strikes;}
	public String 	getDescription(){return description;}
	public CBarrier getBarrier() 	{return barrier;}
	public int      getNrFixing()   {return 0;};
	
	/* methods */

	public abstract double value(double s);
	public abstract double value(double[] s);
	public abstract void printOut();
}
