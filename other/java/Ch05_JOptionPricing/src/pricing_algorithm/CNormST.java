package pricing_algorithm;

import java.lang.Math;
/**
 * class for mathematical computation related to the normal standard distribution
 * @author Giovanni Della Lunga
 * @version 1.0
*/
public class CNormST {		
/**
 * @return The value of the normal standard density function
*/
public double Dist(double x)
{
	return (1.0/Math.sqrt(2*Math.PI))*Math.exp(-x*x/2.0);
}
/**
 * This method compute the value of the cumulative standard normal distribution
 * using the algorithm described in 
 * 
 * Stuart, Alan and J. Keith Orr, "Kendall's Advanced Theory of Statistics" Vol. 1
 * Distributin Theory, 5th ed (New York, Oxford University Press, 1987)
 * 
 * @return The value of the cumulative normal distribution
*/
public double Cum(double x)
{
	int    i		= 0;	/* counter */
    double CN		= 0;	/* dummy variable */

	/* test on extreme values */
	if(Math.abs(x) > 7)
	{
		if(x > 0)	/* high positive values  */
		{
			return 1.0;
		}
		else	/* negative values */
		{
			return 0.0;
		}
	}
	/* start computation */
	CN = 0;
	for(i = 0; i <= 12; i++)
	{
		CN += Math.exp(-(Math.pow((i + 0.5),2.0))/9.0)*Math.sin(Math.abs(x)*(i+.5)*Math.sqrt(2.0)/3.0)*Math.pow((i + 0.5),-1.0);
	}
	CN = 0.5 + (1/Math.PI)*CN;
	if(x > 0)
	{
		return CN;
	}
	else
	{
		return 1.0 - CN;
	}
}
/** Constructor
*/
public CNormST()
{
				
}

public static double CNormInvCum(double p) 
{

	double arg, t, t2, t3, xnum, xden, qinvp, x, pc;

	final double c[] = { 2.515517, .802853, .010328 };

	final double d[] = { 1.432788, .189269, .001308 };

	if (p <= .5) {

		arg = -2.0 * Math.log(p);
		t = Math.sqrt(arg);
		t2 = t * t;
		t3 = t2 * t;

		xnum = c[0] + c[1] * t + c[2] * t2;
		xden = 1.0 + d[0] * t + d[1] * t2 + d[2] * t3;
		qinvp = t - xnum / xden;
		x = -qinvp;

		return x;

	} else {

		pc = 1.0 - p;
		arg = -2.0 * Math.log(pc);
		t = Math.sqrt(arg);
		t2 = t * t;
		t3 = t2 * t;

		xnum = c[0] + c[1] * t + c[2] * t2;
		xden = 1.0 + d[0] * t + d[1] * t2 + d[2] * t3;
		x = t - xnum / xden;

		return x;

	}

}

}
