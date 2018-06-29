package polyhedron.wileybook.ch02;

public class Application {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		System.out.println("Start Calculation");
		
		COption_American	american_Option = new COption_American(1.0,1.0,0.02,0.25,0.20,0);
		COption_European    european_Option = new COption_European(1.0,1.0,0.02,0.25,0.20,0);
		
		american_Option.Value();
		european_Option.Value();
		
		System.out.println("End Calculation");
		
	}

}
