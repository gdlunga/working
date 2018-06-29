package statistics;

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

}
