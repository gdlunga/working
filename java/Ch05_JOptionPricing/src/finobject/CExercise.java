package finobject;

import java.util.GregorianCalendar;

public abstract class CExercise {

	protected GregorianCalendar expirationDate;
	public GregorianCalendar getExpirationDate() 
	{
		return expirationDate;
	}
	
	protected double expirationTime;
	public double getExpirationTime() 
	{
		return expirationTime;
	}

	protected int expirationTimeUnit;
	public double getExpirationTimeUnit()
	{
		return expirationTimeUnit;
	}
	
	/**
	 * @uml.property  name="description"
	 */
	protected String description = "";
	/**
	 * Getter of the property <tt>description</tt>
	 * @return  Returns the description.
	 * @uml.property  name="description"
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * Setter of the property <tt>description</tt>
	 * @param description  The description to set.
	 * @uml.property  name="description"
	 */
	public void setDescription(String description) {
		this.description = description;
	}
		
		/**
		 */
	public abstract void printOut();

		/**
		 * @uml.property  name="relevantUnderlyingDates" multiplicity="(0 -1)" dimension="1"
		 */
		private GregorianCalendar[] relevantUnderlyingDates;
		/**
		 * Getter of the property <tt>relevantUnderlyingDates</tt>
		 * @return  Returns the relevantUnderlyingDates.
		 * @uml.property  name="relevantUnderlyingDates"
		 */
		public GregorianCalendar[] getRelevantUnderlyingDates() {
			return relevantUnderlyingDates;
		}
		/**
		 * Setter of the property <tt>relevantUnderlyingDates</tt>
		 * @param relevantUnderlyingDates  The relevantUnderlyingDates to set.
		 * @uml.property  name="relevantUnderlyingDates"
		 */
		public void setRelevantUnderlyingDates(GregorianCalendar[] relevantUnderlyingDates) {
			this.relevantUnderlyingDates = relevantUnderlyingDates;
		}

		/**
		 * @uml.property  name="relevantUnderlyingTimes" multiplicity="(0 -1)" dimension="1"
		 */
		private double[] relevantUnderlyingTimes;
		/**
		 * Getter of the property <tt>relevantUnderlyingTimes</tt>
		 * @return  Returns the relevantUnderlyingTimes.
		 * @uml.property  name="relevantUnderlyingTimes"
		 */
		public double[] getRelevantUnderlyingTimes() {
			return relevantUnderlyingTimes;
		}
		/**
		 * Setter of the property <tt>relevantUnderlyingTimes</tt>
		 * @param relevantUnderlyingTimes  The relevantUnderlyingTimes to set.
		 * @uml.property  name="relevantUnderlyingTimes"
		 */
		public void setRelevantUnderlyingTimes(double[] relevantUnderlyingTimes) {
			this.relevantUnderlyingTimes = relevantUnderlyingTimes;
		}
			
		public abstract double earlyExerciseValue(double intrinsicValue, 
				                                  double continuationValue, 
				                                  double exerciseTime);

		public abstract double earlyExerciseValue(double intrinsicValue, 
				                                  double continuationValue, 
				                                  GregorianCalendar exerciseDate);
}