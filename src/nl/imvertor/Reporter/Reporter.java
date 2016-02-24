package nl.imvertor.Reporter;

import nl.imvertor.common.Step;
import nl.imvertor.common.file.AnyFolder;
import nl.imvertor.common.file.OutputFolder;

import org.apache.log4j.Logger;

/**
 * This class reports on the state of a run, 
 * Based on the current parms.xml, and possible XHTML fragments found in the work folder in files with names [step]-report.xml. 
 * 
 * @author arjan
 *
 */
public class Reporter extends Step {

	protected static final Logger logger = Logger.getLogger(Reporter.class);
	
	public static final String STEP_NAME = "Reporter";
	public static final String VC_IDENTIFIER = "$Id: Reporter.java 7419 2016-02-09 15:42:49Z arjan $";
	
	/**
	 *  run the main translation
	 * @throws Exception 
	 */
	public boolean run() {

		try {
			// set up the configuration for this step
			configurator.setActiveStepName(STEP_NAME);
			prepare();
			runner.info(logger,"Compiling final report");

			// copy the HTML stuff to the result documentation workfolder
			String owner = configurator.getParm("cli", "owner");
			String sourceHtml = configurator.getParm("system", "cfg-folder-path") + "/common/owners/" + owner + "/web";
			AnyFolder sourceHtmlFolder = new AnyFolder(sourceHtml);
			if (!sourceHtmlFolder.isDirectory())
				throw new Exception("Not a folder: " + sourceHtmlFolder.getAbsolutePath());
			OutputFolder targetHtmlFolder = new OutputFolder(configurator.getParm("system","work-doc-folder-path") + "/web");
			if (targetHtmlFolder.exists()) 
				targetHtmlFolder.clear(false);
			sourceHtmlFolder.copy(targetHtmlFolder);
			
			configurator.setStepDone(STEP_NAME);
			
			// no additional transformations, just report
			report();
			return runner.succeeds();

		} catch (Exception e) {
			runner.fatal(logger, "Step fails by system error.", e);
			return false;
		} 
	}
}
