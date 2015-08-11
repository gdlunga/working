package pricing_algorithm;

import java.util.Random;

/**
 * This class ... 
 * 
 * @author Giovanni Della Lunga
 * 
 * Credits:
 * 
 */
public class CPathGenerator 
{
	private int nStep = 0;
	private int nPath = 0;
	
	public CPathGenerator(int nStep, int nPath)
	{
		this.nStep = nStep;
		this.nPath = nPath;
	}
	
	public boolean gbmUnivariate(double iniValue,
			                     double stdev,
			                     double sqrDt,
					             double drift,
					             double[] t,
					             double[][] path)
	{
		double dt	= sqrDt*sqrDt;	
		Random gen 	= new Random();

		t[0] = 0;
		for (int i = 1; i < t.length; i++)
		{
			t[i] = t[i - 1] + dt;
		}

		for (int i = 0; i < nPath; i++)
		{
			path[i][0] = iniValue;
			for (int j = 1; j < nStep; j++)
			{
				double z = CNormST.CNormInvCum(gen.nextDouble());
				path[i][j] = path[i][j - 1]
						* Math.exp((drift * sqrDt + stdev*z)*sqrDt);
			}
		}
		return true;
	}
	
	public boolean gbmUnivariate(double iniValue,
			                     double stdev,
			                     double sqrDt,
					             double drift,
					             double[][] path)
	{
		double z    = 0;
		
		Random gen 	= new Random();

		for (int i = 0; i < nPath; i++)
		{
			path[i][0] = iniValue;
			for (int j = 1; j < nStep; j++)
			{
				z 	= CNormST.CNormInvCum(gen.nextDouble());
				path[i][j]  = path[i][j-1] * Math.exp((drift * sqrDt + stdev*z)*sqrDt);
			}
		}
		return true;
	}

	public boolean gbmUnivariate(double iniValue,
			                     double stdev,
			                     double sqrDt,
					             double drift,
					             double[] path)
	{
		double z    = 0;
		
		Random gen 	= new Random();
	
		path[0] = iniValue;
		for (int j = 1; j < nStep; j++)
		{
			z 	= CNormST.CNormInvCum(gen.nextDouble());
			path[j]  = path[j-1] * Math.exp((drift * sqrDt + stdev*z)*sqrDt);
		}
		return true;
	}
}
