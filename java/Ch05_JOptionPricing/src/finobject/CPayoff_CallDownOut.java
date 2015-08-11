package finobject;


public class CPayoff_CallDownOut extends CPayoff {

	/* constructors */
	
	public CPayoff_CallDownOut(double strike, 
            CBarrier barrier)
	{
		description = "Barrier Call Down and Out";
		this.strike		=	strike;
		this.barrier	=	barrier;	
	}

	/* methods */
	
	public double value(double s) 
	{
		// TODO Auto-generated method stub
		return 0;
	}

	public double value(double[] s) 
	{
		double  payoff = 0;
		boolean enable = true;
		
		for(int i = 0; i < s.length; i++)
		{
			if(s[i] < barrier.getLowerLevel())
			{
				enable = false;
				break;
			}
		}
		
		if(enable && s[s.length-1] > strike) 
			payoff = s[s.length-1] - strike;
		
		return payoff;
	}

	public void printOut() 
	{
		System.out.println("Payoff type           : " + description);
		System.out.println("Exercise price        = " + strike);
		System.out.println("Lower Level           = " + barrier.getLowerLevel());
		System.out.println("Upper Level           = " + barrier.getUpperLevel());
	}
}
