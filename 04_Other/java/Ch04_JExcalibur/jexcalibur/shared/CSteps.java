package jexcalibur.shared;

import jexcalibur.shared.CStep;

public class CSteps {

		
		/**
		 */
		public CSteps(int count)
		{
			this.count = 0;
			if(count > 0)
			{
				this.count = count;
				steps = new CStep[count];
			}
			else
			{
				/* gestione errore */
			}
		}

		/**
		 * @uml.property  name="steps" multiplicity="(0 -1)" dimension="1"
		 */
		private CStep[] steps;

		/**
		 * Getter of the property <tt>steps</tt>
		 * @return  Returns the steps.
		 * @uml.property  name="steps"
		 */
		public CStep[] getSteps() {
			return steps;
		}

		/**
		 * Setter of the property <tt>steps</tt>
		 * @param steps  The steps to set.
		 * @uml.property  name="steps"
		 */
		public void setSteps(CStep[] steps) {
			this.steps = steps;
		}

		/**
		 * @uml.property  name="count"
		 */
		private int count;

		/**
		 * Getter of the property <tt>count</tt>
		 * @return  Returns the count.
		 * @uml.property  name="count"
		 */
		public int getCount() {
			return count;
		}

		/**
		 * Setter of the property <tt>count</tt>
		 * @param count  The count to set.
		 * @uml.property  name="count"
		 */
		public void setCount(int count) {
			this.count = count;
		}

}
