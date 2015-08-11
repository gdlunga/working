package finobject;

import java.util.*;

public class CExercise_Bermuda extends CExercise {

	private Hashtable exercisePeriod;

	public double earlyExerciseValue(double intrinsicValue,
                                     double continuationValue,
                                     double exerciseTime)
	{
		if(exercisePeriod.containsKey(new Double(exerciseTime)))
			return Math.max(intrinsicValue,continuationValue);
		else
			return continuationValue;
	}

	public double earlyExerciseValue(double intrinsicValue,
                                     double continuationValue,
                                     GregorianCalendar exerciseDate)
	{
		return -1;
	}
	
	public void printOut()
	{
		System.out.println("Exercise type         : " + description);
		//System.out.println("First Exercise Time   = " + commencementTime + " years");
		System.out.println("Last  Exercise Time   = " + expirationTime  + " years");

	}
	
	public CExercise_Bermuda(){}
	public CExercise_Bermuda(double expirationTime,
			                 Hashtable exercisePeriod)
	{
		description	= "Bermuda";
		this.expirationTime     = expirationTime;
		this.exercisePeriod		= exercisePeriod;
	}
}
