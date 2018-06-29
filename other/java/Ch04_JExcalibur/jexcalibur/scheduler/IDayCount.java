package jexcalibur.scheduler;

import java.util.GregorianCalendar;

public interface IDayCount {

		
		/**
		 */
		public abstract double Calculate(GregorianCalendar begin, GregorianCalendar end);
		
}
