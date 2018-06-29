package finobject;


public class CPayoff_CallPV extends CPayoff 
{
		/**
		 */
		public CPayoff_CallPV(double strike)
		{
			description = "Call Plain Vanilla";
			this.strike	= strike;
		}

		/**
		 */
		public void printOut()
		{
			System.out.println("Payoff type           : " + description);
			System.out.println("Exercise price        = " + strike);
		}

		/**
		 */
		public double value(double[] s)
		{
			double payoff 		= 0.0;
			
			if(s[s.length - 1] > strike) 
				payoff = s[s.length - 1] - strike;
			
			return payoff;
		}
		
		public double value(double s)
		{
			double[] sv = new double[1];
			sv[0] = s;
			return value(sv);
		}

}
