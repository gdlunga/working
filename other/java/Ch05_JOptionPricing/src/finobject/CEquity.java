package finobject;

public class CEquity extends CFinancialActivity {

		private double dividendYield	= 0;
		public double getDividendYield() {
			return dividendYield;
		}
	
		/**
		 */
	    public CEquity(){activityType = CFinancialActivity.EQUITY;} 
		public CEquity(double level, 
				       double volatility)
		{
			activityType = CFinancialActivity.EQUITY;
			this.level 			= 	level;
			this.volatility		=	volatility;
		}
		public CEquity(double level, 
			           double volatility,
			           double dividendYield)
		{
			activityType = CFinancialActivity.EQUITY;
			this.level 			= 	level;
			this.volatility		=	volatility;
			this.dividendYield	= 	dividendYield;
		}
			
		/**
		 */
		public void printOut()
		{
			System.out.println("Underlying value      = " + level);
			System.out.println("Underlying volatility = " + volatility + "(" + 100*volatility + "%)");
	 	}


}
