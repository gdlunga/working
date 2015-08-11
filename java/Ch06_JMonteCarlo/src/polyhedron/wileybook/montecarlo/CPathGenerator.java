package polyhedron.wileybook.montecarlo;

import java.util.Random;
import polyhedron.wileybook.montecarlo.CDF_Normal;

/**
 * This class ... 
 * 
 * @author Giovanni Della Lunga
 * 
 * Credits:
 * 
 */
public class CPathGenerator {
	
	public boolean GBM(int nStep,
			           int nPath,
			           double iniValue,
			           double stdev,
			           double sqrDt,
					   double drift,
					   double[] t,
					   double[][] path)
	{
		double dt	= sqrDt*sqrDt;	
		Random gen 	= new Random();

		t[0] = 0;
		for (int i = 1; i < t.length; i++){
			t[i] = t[i - 1] + dt;
		}

		for (int i = 0; i < nPath; i++){
			path[i][0] = iniValue;
			for (int j = 1; j < nStep; j++){
				double z = CDF_Normal.xnormi(gen.nextDouble());
				path[i][j] = path[i][j - 1]
						* Math.exp((drift * sqrDt + stdev*z)*sqrDt);
			}
		}
		
		return true;
	}
	
	
}
