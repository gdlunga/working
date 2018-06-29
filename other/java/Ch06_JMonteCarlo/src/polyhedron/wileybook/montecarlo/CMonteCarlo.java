package polyhedron.wileybook.montecarlo;

import polyhedron.wileybook.chart.*;

public class CMonteCarlo {
	
		/**
		 */
		public void Simulation(int scenarios, 
				               int step, 
				               double strike, 
				               double riskFreeRate, 
				               double expiry, 
				               double assetPrice, 
				               double assetVolatility, 
				               String optionType)
		{
		    step++;
			double riskNeutralDrift = riskFreeRate - 0.5*assetVolatility*assetVolatility;
			double sqrtDeltaT 		= Math.sqrt(expiry/(step-1));
			
			double[] 	time 	= new double[step];
			double[][] 	paths	= new double[scenarios][step]; 	
			
			CPathGenerator generator = new CPathGenerator(); 
			
			generator.GBM(step,
					      scenarios,
					      assetPrice,
                          assetVolatility,
                          sqrtDeltaT,
                          riskNeutralDrift,
                          time,
                          paths);
			
			chartXY grafico = new chartXY("Chart XY",
					                      "Geometric Brownian Paths",
					                      "time",
					                      "asset price",
					                      time,
					                      paths,
					                      expiry,
					                      scenarios);
			
		}

}
