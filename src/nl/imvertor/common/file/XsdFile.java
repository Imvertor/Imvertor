// SVN: $Id: XsdFile.java 7240 2015-09-07 13:46:20Z arjan $

package nl.imvertor.common.file;

import java.io.File;
import java.io.IOException;
import java.util.Vector;

import nl.imvertor.SchemaValidator.xerces.ErrorHandler;
import nl.imvertor.SchemaValidator.xerces.ErrorHandlerMessage;
import nl.imvertor.SchemaValidator.xerces.XMLGrammarBuilder;

import org.apache.log4j.Logger;
import org.apache.xerces.xni.XNIException;

public class XsdFile extends XmlFile {

	private static final long serialVersionUID = -3939175124241905868L;
	
	protected static final Logger logger = Logger.getLogger(XsdFile.class);
	
	public XsdFile(File file) throws XNIException, IOException {
		super(file);
	}

	/*
	 * Validate the schema in this file.
	 */
	public Vector<ErrorHandlerMessage> validateGrammar(Boolean quiet, Boolean setHonourAllSchemaLocations, Boolean setSchemaFullChecking) throws Exception {
		XMLGrammarBuilder gb = new XMLGrammarBuilder(quiet);
		gb.setHonourAllSchemaLocations(setHonourAllSchemaLocations);
		gb.setSchemaFullChecking(setSchemaFullChecking);
		gb.parseXSD(this.getCanonicalPath());
		ErrorHandler e = gb.getErrorHandler();
		return e.getErrors();
	}
	
}
