// SVN: $Id: ErrorHandler.java 7240 2015-09-07 13:46:20Z arjan $

package nl.imvertor.SchemaValidator.xerces;

import java.util.Iterator;
import java.util.Vector;

import org.apache.xerces.xni.parser.XMLParseException;

public class ErrorHandler {

	Vector<ErrorHandlerMessage> errors;
	Boolean quiet = false;
	
	public ErrorHandler(Boolean quiet) {
		this.errors = new Vector<ErrorHandlerMessage>();
		this.quiet = quiet;
	}
	
	public void genericMessage(String type, String arg0, String arg1, XMLParseException arg2) {
		ErrorHandlerMessage m = new ErrorHandlerMessage();
		m.file = arg2.getExpandedSystemId();
		m.line = arg2.getLineNumber();
		m.column = arg2.getColumnNumber();
		m.message = arg2.getLocalizedMessage();
		m.type = type;
		m.context = arg0;
		m.code = arg1;
		errors.add(m);
		if (!quiet) show(m); 
	}
	
	public void show(ErrorHandlerMessage m) {
		System.out.println(m.type + ": " + m.message + ", in file: " + m.file + " [" + m.line + "," + m.column + "]");
	}

	public void showAll() {
		Iterator<ErrorHandlerMessage> it = errors.iterator();
		while (it.hasNext()) {
			show(it.next());
		}
	}
	
	public Vector<ErrorHandlerMessage> getErrors() {
		return errors;
	}
}


