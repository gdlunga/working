package finobject;

import java.util.GregorianCalendar;

public class CExercise_European extends CExercise {

		public CExercise_European(){};
		/**
		 */
		public CExercise_European(double expirationTime, 
				                  int expirationTimeUnit)
		{
			description	= "European";
			this.expirationTimeUnit =   expirationTimeUnit;
			switch(expirationTimeUnit)
			{
			case GregorianCalendar.YEAR:
				this.expirationTime		=	expirationTime;	
				break;
			case GregorianCalendar.DAY_OF_MONTH:
				this.expirationTime		=	expirationTime/365.2425;
				break;
			case GregorianCalendar.MONTH:
				this.expirationTime		=	expirationTime/12;
				break;
			}
		}

		/**
		*/
		public CExercise_European(GregorianCalendar expirationDate)
		{
			description	= "European";
			this.expirationDate		=	expirationDate;
		}
		
		public double earlyExerciseValue(double intrinsicValue,
                                         double continuationValue,
                                         double exerciseTime)
		{
				return continuationValue;
		}
		public double earlyExerciseValue(double intrinsicValue,
                                         double continuationValue,
                                         GregorianCalendar exerciseDate)
		{
			return continuationValue;
		}
		
		/**
		 */
		public void printOut()
		{
			System.out.println("Exercise type         : " + description);
			System.out.println("Expiration            = " + expirationTime  + " years");
		}
}
