package finobject;

public class CPayoff_CallAsianAAvRate extends CPayoff {

	int    		nFixing     = 0;
	double[]    fixingTimes;

	public double value(double[] s)
	{
		double payoff 	= 0;
		double average	= 0;
		
		average = 0;
		for(int i = 1; i < s.length; i++)
		{
			average += s[i];
		}
		average /= nFixing;
		
		if(average > strike) payoff = average - strike;
		
		return payoff;
	}
	
	public double value(double s)
	{
		double[] sv = new double[1];
		sv[0] = s;
		return value(sv);
	}
		
	/**
	 */
	public CPayoff_CallAsianAAvRate(double strike,
			                    int    nFixing)
	{
		description = "Call Asian Aritmetic Average Rate";
		this.strike			= strike;
		this.nFixing		= nFixing;
		
		if(nFixing > 0){
			fixingTimes = new double[nFixing];
		}
	}
	
	public CPayoff_CallAsianAAvRate(double   strike,
                                double[] fixingTimes,
                                int      nFixing)
	{
		description = "Call Asian Aritmetic Average Rate";
		this.strike			= strike;
		this.nFixing		= nFixing;
		
		if(nFixing > 0){
			this.fixingTimes = new double[nFixing];
			for(int i = 0; i < nFixing; i++)
				this.fixingTimes[i] = fixingTimes[i];
		}
	}

	public void printOut() 
	{
		System.out.println("Payoff type           : " + description);
		System.out.println("Exercise price        = " + strike);
		System.out.println("Fixing number         = " + nFixing);
	}

}
