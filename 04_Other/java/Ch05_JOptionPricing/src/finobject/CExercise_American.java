package finobject;

import java.util.GregorianCalendar;

public class CExercise_American extends CExercise 
{
	/**
	 */
	private GregorianCalendar 	commencementDate;
	public GregorianCalendar getCommencementDate() 
	{
		return commencementDate;
	}
	/**
	 */
	private double 				commencementTime;
	public double getCommencementTime() 
	{
		return commencementTime;
	}
	/**
	 */
	public CExercise_American(){}
			
	/**
	 */
	public CExercise_American(double commencementTime, 
			                  double expirationTime,
			                  int    timeUnit)
	{
		description	= "American";

		this.expirationTimeUnit =   timeUnit;
		switch(expirationTimeUnit)
		{
		case GregorianCalendar.YEAR:
			this.expirationTime		=	expirationTime;	
			this.commencementTime 	= 	commencementTime;
			break;
		case GregorianCalendar.DAY_OF_MONTH:
			this.expirationTime		=	expirationTime/365.2425;	
			this.commencementTime 	= 	commencementTime/365.2425;
			break;
		case GregorianCalendar.MONTH:
			this.expirationTime		=	expirationTime/12;	
			this.commencementTime 	= 	commencementTime/12;
			break;
		}
	}
				
	/**
	 */
	public CExercise_American(GregorianCalendar commencementDate, 
			                  GregorianCalendar expirationDate)
	{
		description	= "American";
		this.commencementDate	=	commencementDate;
		this.expirationDate		=	expirationDate;
   	}

	public double earlyExerciseValue(double intrinsicValue,
                                     double continuationValue,
                                     double exerciseTime)
	{
		return Math.max(intrinsicValue, continuationValue);
	}

	public double earlyExerciseValue(double intrinsicValue,
                                     double continuationValue,
                                     GregorianCalendar exerciseDate)
	{
		return Math.max(intrinsicValue, continuationValue);
	}

	/**
	 */
	public void printOut()
	{
		System.out.println("Exercise type         : " + description);
		System.out.println("First Exercise Time   = " + commencementTime + " years");
		System.out.println("Last  Exercise Time   = " + expirationTime  + " years");
	}
}
