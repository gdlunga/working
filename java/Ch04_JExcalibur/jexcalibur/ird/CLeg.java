package jexcalibur.ird;


public class CLeg {

		
		/**
		 */
		public CLeg(){
		
		}

		/**
		 * @uml.property  name="interestRateStream"
		 */
		private CInteresRateStream interestRateStream;

		/**
		 * Getter of the property <tt>interestRateStream</tt>
		 * @return  Returns the interestRateStream.
		 * @uml.property  name="interestRateStream"
		 */
		public CInteresRateStream getInterestRateStream() {
			return interestRateStream;
		}

		/**
		 * Setter of the property <tt>interestRateStream</tt>
		 * @param interestRateStream  The interestRateStream to set.
		 * @uml.property  name="interestRateStream"
		 */
		public void setInterestRateStream(CInteresRateStream interestRateStream) {
			this.interestRateStream = interestRateStream;
		}

		/**
		 * @uml.property  name="couponPayoff"
		 */
		private ICouponPayoff couponPayoff;

		/**
		 * Getter of the property <tt>couponPayoff</tt>
		 * @return  Returns the couponPayoff.
		 * @uml.property  name="couponPayoff"
		 */
		public ICouponPayoff getCouponPayoff() {
			return couponPayoff;
		}

		/**
		 * Setter of the property <tt>couponPayoff</tt>
		 * @param couponPayoff  The couponPayoff to set.
		 * @uml.property  name="couponPayoff"
		 */
		public void setCouponPayoff(ICouponPayoff couponPayoff) {
			this.couponPayoff = couponPayoff;
		}

}
