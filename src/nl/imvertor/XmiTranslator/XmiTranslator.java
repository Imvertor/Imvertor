package nl.imvertor.XmiTranslator;

import nl.imvertor.common.Step;
import nl.imvertor.common.Transformer;

import org.apache.log4j.Logger;


/**
 * Translate XMI file to Imvertor format.
 *  
 * 
 * @author arjan
 *
 */
public class XmiTranslator extends Step {

	protected static final Logger logger = Logger.getLogger(XmiTranslator.class);
	
	public static final String STEP_NAME = "XmiTranslator";
	public static final String VC_IDENTIFIER = "$Id: XmiTranslator.java 7419 2016-02-09 15:42:49Z arjan $";

	/**
	 *  run the main translation
	 */
	public boolean run() {
		
		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Translating XMI to Imvertor format");

			// create a transformer
			Transformer transformer = new Transformer();
			    
		    // transform 
			boolean succeeds = true;
			succeeds = succeeds ? transformer.transformStep("system/xmi-file-path", "properties/WORK_BASE_FILE",  "properties/XMI_IMVERTOR_XSLPATH","cur-imvertor-filepath") : false ;
			
			configurator.setStepDone(STEP_NAME);
			
			// save any changes to the work configuration for report and future steps
		    configurator.save();
		    
		    report();
		    
			return runner.succeeds();
			
		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
	
}
