package nl.imvertor.common.file;

import java.io.File;

/**
 * A representation of an XMI file.
 * 
 * The XmiFile is an AnyFile and therefore does not access the chain environment. 
 *  
 * @author arjan
 *
 */

public class XmiFile extends XmlFile {

	private static final long serialVersionUID = 7001368764997266115L;

	public XmiFile(String pathname) {
		super(pathname);
	}
	
	public XmiFile(File file) {
		super(file);
	}
	
}
