package pricing_algorithm;

import finobject.COption;

public class CBlackScholes_GeometricAsian extends CBlackScholes {

	/**
	 * note: this method overwrite the Execute method of the super class
	 * CBlackScholes
	 */
	public double Execute(COption option){
		return BS_GeometricAsian(option);
	}

	private double BS_GeometricAsian(COption option)
	{
			System.out.println("Running Black & Scholes Algorithm for Geometric Asian Option");
			option.printOut();
			
			CNormST 		N	=	new CNormST();
			
			double price = 0;

			double		S   		= (option.getUnderlying()).getLevel();
			double      sigma		= (option.getUnderlying()).getVolatility();
			double      K       	= (option.getPayoff()).getStrike();
			double      r       	= (option.getDiscounting()).getDiscountRate();
			double      T       	= (option.getExercise()).getExpirationTime();

			int         m_ave		= (option.getPayoff()).getNrFixing();
			
			double      h = T / (double)m_ave;
			double      mg = Math.log(S) + (r - sigma * sigma / 2) * (T + h) / 2.0;
			double      sg = Math.sqrt((sigma * sigma) * h * (2 * m_ave + 1) * (m_ave + 1) / (6 * m_ave));

			double      d1 = (mg - Math.log(K) + sg * sg) / sg;
			double      d2 = d1 - sg;

			price       = Math.exp(-r * T) * (Math.exp(mg + sg * sg / 2) * N.Cum(d1) - K * N.Cum(d2));
			
			return price;
	}
}
