package nl.imvertor.common.wrapper;

import javax.xml.transform.Transformer;

import nl.imvertor.common.Configurator;

import org.apache.commons.configuration2.CombinedConfiguration;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.configuration2.io.FileLocator;
import org.apache.commons.configuration2.io.FileLocator.FileLocatorBuilder;
import org.apache.commons.configuration2.io.FileLocatorUtils;

/**
 * Wrapper for apache XMLConfiguration, required for creating a transformer with a locator (bug fix).
 * 
 * @author arjan
 *
 */
public class XMLConfiguration extends org.apache.commons.configuration2.XMLConfiguration {

	
	public XMLConfiguration() {
		super();
	}
	
	public XMLConfiguration(CombinedConfiguration cc) {
		super(cc);
	}
	
    public Transformer createTransformer() throws ConfigurationException  {
    	FileLocatorBuilder builder = FileLocatorUtils.fileLocator();
    	builder.basePath(Configurator.getInstance().getConfigFilepath());
    	builder.encoding("UTF-8");
		FileLocator locator = new FileLocator(builder);
		initFileLocator(locator);
        return super.createTransformer();
    }
  
}
