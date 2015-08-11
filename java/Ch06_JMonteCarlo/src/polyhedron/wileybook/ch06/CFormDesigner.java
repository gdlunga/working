package polyhedron.wileybook.ch06;

import polyhedron.wileybook.montecarlo.*;
import java.awt.Button;
import java.awt.Choice;
import java.awt.Frame;
import java.awt.Label;
import java.awt.TextArea;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/**
 * This class produce an input user form for option pricing 
 * @author  Giovanni Della Lunga
 */
public class CFormDesigner extends Frame{

	private static final long serialVersionUID = 1L;

	// variables
	/** vertical offset */
    final int 	yOffset 		= 40;
    /** horizontal offset */
    final int   xOffset 		= 20;
    /** this is the default text width */
    final int   txtWidth  		= 100;
    /** form width */
    final int   frmWidth        = 2*txtWidth + 3*xOffset;
    /** form height */
    final int   frmHeight    	= frmWidth + 2*yOffset;
    
    /** strike price input text box */
    TextField txtStrike;
    /** risk free rate input text box */
    TextField txtRiskFree;
    /** asset price input text box */
    TextField txtAsset;
    /** number of scenario to generate input text box */
    TextField txtScenariosNumber;
    /** number of step for path generation */
    TextField txtStepNumber; 
	/** expiry input text box */
    TextField txtExpiry;
    /** asset volatility input text box */
    TextField txtVolatility;
      
    /** output area */
    static TextArea	textOutput;
    
    /** option type input combo box */
    Choice cmbOptionType;
    /** option exercise type input combo box */
    //  in this version the option exercise can be only EUROPEAN so
    //  this control is disabled
    //Choice cmbOptionExercise;
    
    /** Pricing button */
    Button btnCalculate;
    /** Quit button */
    Button btnQuit;
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * Default constructor
	 *
	 */
	public CFormDesigner() {

        addWindowListener 
        (
        	new WindowAdapter () 
        	{
            	public void windowClosing (WindowEvent evt) 
            	{
            		exitForm (evt);
                }
            }
        );

        this.setLayout(null);
        // Input text boxes (first column)
        txtAsset 			= addTextBox("Asset Price",		   xOffset,         1*yOffset,txtWidth);
        txtVolatility 		= addTextBox("Volatility (%)",     xOffset,         2*yOffset,txtWidth);
        txtRiskFree 		= addTextBox("Interest Rate (%)",  xOffset,         3*yOffset,txtWidth);
        txtExpiry 			= addTextBox("Expiry (years)",	   xOffset,         4*yOffset,txtWidth);
        // txtStrike 			= addTextBox("Strike Price",	   xOffset,         5*yOffset,txtWidth);
        // Input text boxes (second column)
        txtScenariosNumber	= addTextBox("Simulation Nr.", 	 2*xOffset+txtWidth,1*yOffset,txtWidth);
        txtStepNumber       = addTextBox("Step Nr.", 	     2*xOffset+txtWidth,2*yOffset,txtWidth);
        // Combo boxes (remember that cmbOptionExercise is disabled)
        cmbOptionType	= addChoice("Option Payoff",	     2*xOffset+txtWidth,3*yOffset,txtWidth);
        cmbOptionType.add("CALL");
        cmbOptionType.add("PUT");
        //cmbOptionExercise	= addChoice("Option Exercise",	 2*xOffset+txtWidth,4*yOffset,txtWidth);
        //cmbOptionExercise.add("EUROPEAN");
        //cmbOptionExercise.add("AMERICAN");
        // Output text area
	    //textOutput 		= addTextArea("Price",      xOffset,           6*yOffset, xOffset+2*txtWidth,true,false,false);
	    // buttons
        btnCalculate 	= addButton("Scenarios", 1,   xOffset,           7*yOffset);
        btnQuit 		= addButton("Quit",    2, 2*xOffset+1*txtWidth,7*yOffset);
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
	/**
	 * This method show the user form on the screen
	 * */
	void Show()
	{
		int xLocation = 100;
		int yLocation = 100;
		
		/** set window title */
        setTitle("Your Second Java Option Pricing Calculator");
        /** set window dimension */
        setSize(frmWidth, frmHeight + yOffset);
        setLocation(xLocation,yLocation);
        /** the user form is not resizable */
        setResizable(false);
        setVisible(true);
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Add a new combo box, with the related label, to the user form
     * 
     * This method create a new object of type Choice and return a 
     * reference the object. The class Choice is defined within the
     * awt library.  
     * 
     * @param Caption	combo box label
     * @param cmbXPos	top-left corner horizontal position
     * @param cmbYPos	top-left corner vertical position
     * @param cmbWidth  combo box width
     * 
     * @return a reference to an object of type Choice
     * */
    Choice addChoice(String Caption,
    		         int cmbXPos,
    		         int cmbYPos,
    		         int cmbWidth)
    {
        /* default values */
    	int lblWidth 	= cmbWidth;
        int lblXPos  	= cmbXPos;
        int lblYPos    	= cmbYPos;
        int lblHeight 	= 20;
        int cmbHeight 	= 20;
        int InterSpace 	= 20;
   	    	
    	Label lbl = new Label(Caption);
        lbl.setBounds(lblXPos, lblYPos,lblWidth, lblHeight);
        this.add(lbl);
        
        Choice choice = new Choice();
        choice.setBounds(cmbXPos,cmbYPos + InterSpace,cmbWidth, cmbHeight);
        this.add(choice);
    	
    	return choice;
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Add a new text area to the user form.
     * <p>
     * This method create a new object of type TextArea and return a 
     * reference the object. The class TextArea is defined in the
     * awt library.  
     * 
     * @param Caption		the caption for the area label 
     * @param txtXPos		top-left corner horizontal position
     * @param txtYPos		top-left corner vertical position
     * @param txtWidth  	area's width
     * @param label			a boolean value which specify if the area has a label or not
     * @param editability	a boolean value which specify if the area is editable or not
     * @param scrollbars    a boolean value which specify if the text area has a vertical scrool bar or not	
     * 
     * @return a reference to an object of type TextArea
     * */
    TextArea addTextArea(String Caption,
    		             int txtXPos,
    		             int txtYPos,
    		             int textWidth,
    		             boolean label,
    		             boolean editability,
    		             boolean scrollbars)
    {
    	int lblXPos		= txtXPos;
    	int lblYPos		= txtYPos;
    	int lblHeight	= 20;
    	int txtHeight   = 20;
    	int lblWidth	= textWidth;
    	
        if(label) addLabel(Caption,lblXPos,lblYPos, lblWidth, lblHeight);
        
        TextArea txtArea;
        if(scrollbars)
            txtArea = new TextArea("",0,0,TextArea.SCROLLBARS_VERTICAL_ONLY );
        else
            txtArea = new TextArea("",0,0,TextArea.SCROLLBARS_NONE);
        
        txtArea.setBounds(txtXPos, txtYPos+lblHeight, textWidth, txtHeight);
        
        if(editability)
        	txtArea.setEditable(true);
        else
        	txtArea.setEditable(false);
        
        this.add(txtArea);	
    	
    	return txtArea;
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Add a new label to the user form.
     * <p>
     * This method create a new object of type Label and return a 
     * reference the object. The class Label is defined in the
     * awt library.  
     * 
     * @param Caption		label caption 
     * @param xpos			top-left corner horizontal position
     * @param ypos			top-left corner vertical position
     * @param width  		label width
     * @param height		label height
     * 
     * @return a reference to an object of type Label
     * */
    void addLabel(String Caption,
    		      int xpos,
    		      int ypos,
    		      int width,
    		      int height)
    {
        Label lab = new Label(Caption);
        lab.setBounds(xpos, ypos, width, height);
        this.add(lab);
	}
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Add a new button to the user form.
     * <p>
     * This method create a new object of type Button and return a 
     * reference the object. The class Button is defined in the
     * awt library.  
     * 
     * @param Caption		button caption 
     * @param codeButton	to each button the user must associate a unique identifier
     * 						which is used in the buttonActionPerformed method					 
     * @param xpos			top-left corner horizontal position
     * @param ypos  		top-left corner vertical position
     * 
     * @return a reference to an object of type Button
     * 
     * @see #buttonActionPerformed(int, ActionEvent)
     * */
    Button addButton(String Caption,
    		         final int codeButton,
    		         int xpos,
    		         int ypos)
    {
    	/* default values */
    	int width 	= 100;
    	int height	= 30;
    	
	    Button button = new Button(Caption);
	    
	    button.setBounds(xpos, ypos + yOffset, width, height);
	    button.addActionListener (new ActionListener () {
	        public void actionPerformed (ActionEvent evt) {
	            buttonActionPerformed (codeButton, evt);
	            }
	        }
	    );
	    this.add(button);
	    
	    return button;
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Add a new text box to the user form.
     * <p>
     * This method create a new object of type TextField and return a 
     * reference the object. The class TextField is defined in the
     * awt library.  
     * 
     * @param Caption		the caption of the text field 
     * @param txtXPos		top-left corner horizontal position					 
     * @param txtYPos		top-left corner vertical position
     * @param txtLenght  	text field lenght
     * 
     * @return a reference to an object of type TextField
     * */
    TextField addTextBox(String Caption, 
                         int txtXPos, 
                         int txtYPos, 
                         int txtLenght)
    {
    	int InterSpace 	= 20;
    	int lblWidth 	= InterSpace;
    	int textWidth 	= InterSpace;
        int lblLenght 	= txtLenght;
           	
        Label label = new Label(Caption);
        label.setBounds(txtXPos, txtYPos,lblLenght, lblWidth);
        this.add(label);
        TextField textfield = new TextField();
        textfield.setBounds(txtXPos, InterSpace + txtYPos, txtLenght, textWidth);
        this.add(textfield);
        
        return textfield;
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Exit Form
     * <p>
     * */
    void exitForm(WindowEvent event) 
    {
        setVisible(false);      
        dispose();      
        System.exit(0); 
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Call the appropriate subroutine when the user press a button
     * <p>
     * This method uses the parameter nButton which is defined in the addButton method  
     * 
     * @param nButton		button identifier 
     * @param event			action event	
     * 
     * @see #addButton(String, int, int, int)				 
     * */
    void buttonActionPerformed(final int nButton, ActionEvent event)
    {
    	switch(nButton)
    	{
    	case 1: // Calculate method
    		btnCalculate_ActionPerformed(event);
    		break;
    	case 2: // Quit event
    		btnQuit_ActionPerformed(event);
    		break;
    	}
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Perform the action associated to the button 'Calculate'
     * <p>
     * This method compute the option price according to 
     * the parameters value of the input form.
     * 
     * @param  event  	the event associated to the button press
     */
    void btnCalculate_ActionPerformed(ActionEvent event) 
    {
    	/* Variables declaration */	
    	int    nScenario		= 	0;  /* number of monte carlo simulations	*/
    	int    nStep            =   0;  /* number of step for each simulation   */
    	double dPrice 			=   0;  /* plain vanilla option price 			*/
    	double dStrike			= 	0;	/* strike price 						*/
    	double dAssetPrice		=	0;	/* underlying asset price 				*/
    	double dAssetVolatility	=	0;	/* underlying asset volatility      	*/
    	double dRiskFreeRate	=	0;  /* risk free rate						*/
    	double dExpiry			=	0;	/* expiry (years) 						*/
    	
    	String sOptionType		=   "";
    	
    	try
    	{
    		/* read data from text boxes */
    		nScenario			= Integer.parseInt(txtScenariosNumber.getText());
    		nStep    			= Integer.parseInt(txtStepNumber.getText());
    		//dStrike			= Double.parseDouble(txtStrike.getText());
       		dRiskFreeRate	    = Double.parseDouble(txtRiskFree.getText())/100.0;
      		dExpiry			    = Double.parseDouble(txtExpiry.getText());
      		dAssetPrice			= Double.parseDouble(txtAsset.getText());	
    		dAssetVolatility	= Double.parseDouble(txtVolatility.getText())/100.0;	
    		/* read option type from combo box */
    		sOptionType			= cmbOptionType.getSelectedItem();
    		/* set the attribute value and volatility of the Asset object */
    		/* the plain vanilla option price is calcolated */

    		CMonteCarlo monteCarlo = new CMonteCarlo();
    		
    		monteCarlo.Simulation(nScenario, 
    				              nStep, 
    				              0.0, //dStrike, 
    				              dRiskFreeRate, 
    				              dExpiry, 
    				              dAssetPrice, 
    				              dAssetVolatility, 
    				              sOptionType);
    		
    		/* the output price is written into the text area textOutput */
    		//textOutput.setText(Double.toString(dPrice));
    	}
    	catch (NumberFormatException e)
    	{
    		textOutput.setText("Errore");
    	}
    }
    /*---------------------------------------------------------------------------------------------------------------------------------------*/
    /**
     * Perform the action associated to the button 'Quit'
     * <p>
     * Terminate the program
     * 
     * @param  event  	the event associated to the button press
     */
    void btnQuit_ActionPerformed(ActionEvent event) 
    {
    	setVisible(false);
        dispose();      
        System.exit(0); 

    }
}
