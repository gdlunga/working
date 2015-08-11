package pricing_algorithm;

public class CNormBivariate {
		/**
		 * --------------------------------------------------------------------------------
		 */
		public double Cum( double a
    			         , double b
			             , double rho
			         )
		{
			CNormST		N			= new CNormST();
	
			double AA[] = {0.325303, 0.4211071, 0.1334425, 0.006374323};
			double BB[] = {0.1337764, 0.6243247, 1.3425378, 2.2626645};
	
			double 	d	 	= 	0;
			double 	somma 	= 	0;
			double 	rho1	= 	0;
			double 	rho2	= 	0;
			double 	delta	= 	0;
			double 	NA 		= 	0; 
			double 	NB 		=	0;
			
			int 	i 		=	0;
			int 	j 		=	0;
	
			if(rho == 1) rho =  0.999999999;
			if(rho == -1) rho = -0.999999999;
	
			NA = N.Cum(a);
			NB = N.Cum(b);
	
			if(a <= 0 && b <= 0 && rho <= 0) 
			{
			    somma = 0;
			    for(i = 1; i <= 4; i++)
			    {
			       for(j = 1; j <= 4; j++)
			       {
			            somma = somma + AA[i - 1] * AA[j - 1] * f(BB[i - 1], BB[j - 1], a, b, rho);
			       }
			    }
			    return Math.sqrt(1 - rho * rho) * somma / Math.PI;
			}
			else
			{
			    if(a * b * rho <= 0)
			    {
			       if(a <= 0)
			       {
			          return  NA - Cum(a, -b, -rho);
			       }
			       else if(b <= 0)
			       {
			          return  NB - Cum(-a, b, -rho);
			       }
			       else if(rho <= 0)
			       {
			          return  NA + NB - 1 + Cum(-a, -b, rho);
			       }
			    }
			    else
			    {
			       d = Math.sqrt(a * a - 2 * rho * a * b + b * b);
			       rho1 = (rho * a - b) * Math.signum(a) / d;
			       rho2 = (rho * b - a) * Math.signum(b) / d;
			       delta = 0.25 * (1 - Math.signum(a) * Math.signum(b));
			       return  Cum(a, 0, rho1) + Cum(b, 0, rho2) - delta;
			    }
			}
			return 0;
		}
		/**
		 * --------------------------------------------------------------------------------
		 */
		private double f( double x
				        , double y
				        , double a
				        , double b
				        , double rho
				        ){
	
			double a_prime 	=	0;
			double b_prime 	=	0;
			double f		=	0;
			double d		=	0;
		
			d = Math.sqrt(2 * (1 - rho * rho));
			a_prime = a / d;
			b_prime = b / d;
		
			f = a_prime * (2 * x - a_prime) + b_prime * (2 * y - b_prime) +
			    2 * rho * (x - a_prime) * (y - b_prime);
			
			return Math.exp(f);
		}

}	