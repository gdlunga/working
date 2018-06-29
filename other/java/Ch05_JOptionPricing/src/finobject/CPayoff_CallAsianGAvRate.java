package finobject;

public class CPayoff_CallAsianGAvRate extends CPayoff {

	int    		nFixing     = 0;
	double[]    fixingTimes;

	public int getNrFixing(){
		return nFixing;
	}
	
	public double value(double[] s)
	{
		double payoff 	= 0;
		double average	= 0;
		
		average = 1;
		for(int i = 1; i < s.length; i++)
		{
			average *= Math.pow(s[i],1.0/(double)nFixing);
		}
		
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
	public CPayoff_CallAsianGAvRate(double strike,
			                    int    nFixing)
	{
		description = "Call Asian Geometric Average Rate";
		this.strike			= strike;
		this.nFixing		= nFixing;
		
		if(nFixing > 0){
			fixingTimes = new double[nFixing];
		}
	}
	
	public CPayoff_CallAsianGAvRate(double   strike,
                                double[] fixingTimes,
                                int      nFixing)
	{
		description = "Call Asian Geometric Average Rate";
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
