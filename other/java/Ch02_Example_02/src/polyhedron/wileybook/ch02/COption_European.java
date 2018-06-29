package polyhedron.wileybook.ch02;


public class COption_European extends polyhedron.wileybook.ch02.COption {

		
		/**
		 */
		public double Value(){
		
			System.out.println("Pricing European Option...");
			
			return 0;
		}

			
			/**
			 */
			public COption_European(double s, 
					                double k, 
					                double r, 
					                double t, 
					                double sigma, 
					                int type){
			
				asset_Price 			= s;
				asset_Volatility 		= sigma;
				country_RiskFreeRate 	= r;
				expiry 					= t;
				strike 					= k;	

			}

}
