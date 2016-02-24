package nl.imvertor.common;

import nl.imvertor.common.xsl.extensions.ImvertorParseHTML;

/**
 * A step is a class that is runnable, and is able to report on the run. 
 * 
 * All steps inherit a protected configurator and runner.
 * 
 * @author arjan
 *
 */
public class Step {

	protected Configurator configurator = Configurator.getInstance();
	protected Runner runner = configurator.getRunner();
	
	public boolean run() throws Exception {
		throw new Exception("Step run not implemented.");
	}

	/**
	 * Default implementation of reporting.
	 * This method compiles a XML documentation fragment file [stepname]-report.xml, based on the current configuration and 
	 * the step reporting stylesheet ([stepname]-report.xsl).
	 * 
	 * @return
	 * @throws Exception
	 */
	public boolean report(Transformer transformer) throws Exception {
		// create a transformer
		String sn = configurator.getActiveStepName();
		String infile = configurator.getConfigFilepath(); 
		String outfile = configurator.getParm("system","work-rep-folder-path") + "/" + sn + "-report.xml"; 
		String xslfile = configurator.getParm("system","xsl-folder-path") + "/" + sn + "/" + sn + "-report.xsl"; 
		return transformer.transform(infile,outfile,xslfile);
	}
	
	/**
	 * Report by using a default transformer.
	 * 
	 * See report(Transformer transformer)
	 * 
	 * @return
	 * @throws Exception
	 */
	public boolean report() throws Exception {
		Transformer transformer = new Transformer();
		transformer.setExtensionFunction(new ImvertorParseHTML());
		return report(transformer);
	}
		
	public void prepare() throws Exception {
		configurator.prepareStep();
	}
	
}
